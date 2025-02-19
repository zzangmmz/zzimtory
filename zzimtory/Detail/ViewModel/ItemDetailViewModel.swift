//
//  ItemDetailViewModel.swift
//  zzimtory
//
//  Created by seohuibaek on 2/12/25.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

final class ItemDetailViewModel {
    private let disposeBag = DisposeBag()
    private let shoppingRepository = ShoppingRepository()
    
    var items: Driver<[Item]>
    private var itemsRelay = BehaviorRelay<[Item]>(value: [])
    private let itemStatusRelay = BehaviorRelay<[String: Bool]>(value: [:]) // 아이템 저장 상태
    
    var currentItem: Item { itemsRelay.value[currentIndexRelay.value] } // 현재 보여줄 아이템
    private let currentIndexRelay: BehaviorRelay<Int>
    
    let similarItems = BehaviorSubject<[Item]>(value: [])
    private var searchQuery: String = ""
    
    init(items: [Item], currentIndex: Int) {
        self.itemsRelay = BehaviorRelay<[Item]>(value: items)
        self.items = itemsRelay.asDriver()
        self.currentIndexRelay = BehaviorRelay<Int>(value: currentIndex)
        
        setupSearchQuery()
        fetchSimilarItems()
        checkItemStatus(for: items)
    }
    
    // 인덱스 업데이트
    func updateCurrentIndex(_ index: Int) {
        currentIndexRelay.accept(index)
    }
    
    // 검색어 설정 메서드
    private func setupSearchQuery() {
        // HTML 태그를 제거한 제품명을 검색
        let cleanTitle = currentItem.title.removingHTMLTags
        let words = cleanTitle.components(separatedBy: " ")
        
        // 검색어 정제 로직
        if words.count >= 3 { // 제품명 전체를 검색하니 유사상품이 너무 안떠서, 앞에 3단어만 검색하도록 시도
            searchQuery = words.prefix(3).joined(separator: " ")
        } else {
            searchQuery = cleanTitle
        }
    }
    
    // 유사 상품 검색
    private func fetchSimilarItems() {
        shoppingRepository.fetchSearchData(query: searchQuery)
            .subscribe(onSuccess: { [weak self] response in
                let filteredItems = response.items.filter { $0.productID != self?.currentItem.productID }
                self?.similarItems.onNext(filteredItems)
            }, onFailure: { error in
                print("유사 상품 검색 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    // 아이템 저장 상태 확인
    private func checkItemStatus(for items: [Item]) {
        DatabaseManager.shared.readPocket { [weak self] pockets in
            guard let self = self else { return }
            
            var statusMap: [String: Bool] = [:]
            for item in items {
                statusMap[item.productID] = pockets.contains { pocket in
                    pocket.items.contains { $0.productID == item.productID }
                }
            }
            self.itemStatusRelay.accept(statusMap)
        }
    }
    
    // 아이템 상태를 Driver로 제공
    func itemStatus(for productID: String) -> Driver<Bool> {
        return itemStatusRelay
            .map { $0[productID] ?? false }
            .asDriver(onErrorJustReturn: false)
    }
    
    // 아이템의 저장 상태 토글
    func togglePocketStatus(for productID: String) {
        let currentStatus = itemStatusRelay.value[productID] ?? false
        
        if currentStatus {
            DatabaseManager.shared.readPocket { [weak self] pockets in
                guard let self = self else { return }
                
                for pocket in pockets {
                    if pocket.items.contains(where: { $0.productID == productID }) {
                        DatabaseManager.shared.deleteItem(productID: productID, from: pocket.title)
                        // print("아이템 삭제됨: productID \(productID) from \(pocket.title)")
                    }
                }
                var currentMap = self.itemStatusRelay.value
                currentMap[productID] = false
                self.itemStatusRelay.accept(currentMap)
            }
        } else {
            if let item = itemsRelay.value.first(where: { $0.productID == productID }) {
                DatabaseManager.shared.addItemToAggregatePocket(newItem: item) {
                    // print("전체보기 주머니에 아이템 추가 완료")
                }
                var currentMap = self.itemStatusRelay.value
                currentMap[productID] = true
                self.itemStatusRelay.accept(currentMap)
            }
        }
    }
}
