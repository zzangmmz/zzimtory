//
//  DetailViewModel.swift
//  zzimtory
//
//  Created by seohuibaek on 1/31/25.
//

import RxSwift
import UIKit
import FirebaseAuth

final class DetailViewModel {
    private let disposeBag = DisposeBag()
    private let shoppingRepository = ShoppingRepository()
    
    // Input
    let currentItem: Item // 현재 보여줄 아이템
    private var searchQuery: String = ""
    
    // Output
    let itemTitle = BehaviorSubject<String>(value: "")
    let itemBrand = BehaviorSubject<String>(value: "")
    let itemPrice = BehaviorSubject<String>(value: "")
    let itemImageUrl = BehaviorSubject<String>(value: "")
    let similarItems = BehaviorSubject<[Item]>(value: [])
    
    let isInPocket = BehaviorSubject<Bool>(value: false)
    var isInPocketStatus: Bool = false
    
    init(item: Item) {
        self.currentItem = item
        setupData()
        setupSearchQuery()
        fetchSimilarItems()
        checkItemStatus()
    }
    
    private func setupData() {
        // HTML 태그 제거하여 타이틀 설정
        let cleanTitle = currentItem.title.removingHTMLTags
        itemTitle.onNext(cleanTitle)
        
        // 브랜드명 설정
        let brandText = currentItem.brand.isEmpty ? currentItem.mallName : currentItem.brand
        itemBrand.onNext("\(brandText) >")
        
        // 가격 설정
        if let price = Int(currentItem.price) {
            itemPrice.onNext("\(price.withSeparator)원")
        }
        
        // 이미지 URL 설정
        itemImageUrl.onNext(currentItem.image)
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
    
    // 검색어 재설정 및 재검색을 위한 메서드
    func refreshSimilarItems() {
        setupSearchQuery()
        fetchSimilarItems()
    }
    
    private func checkItemStatus() {
        DatabaseManager.shared.readPocket { [weak self] pockets in
            guard let self = self else { return }
            
            // 모든 주머니를 순회하면서 현재 아이템이 있는지 확인
            let isInPocket = pockets.contains { pocket in
                pocket.items.contains { item in
                    item.productID == self.currentItem.productID
                }
            }
            
            self.isInPocketStatus = isInPocket
            self.isInPocket.onNext(isInPocket)
        }
    }

    func handlePocketButton() {
        if isInPocketStatus {
            // 아이템이 있는 주머니를 찾아서 삭제
            DatabaseManager.shared.readPocket { [weak self] pockets in
                guard let self = self else { return }
                
                for pocket in pockets {
                    if pocket.items.contains(where: { $0.productID == self.currentItem.productID }) {
                        // 해당 주머니에서 아이템 삭제
                        DatabaseManager.shared.deleteItem(productID: self.currentItem.productID, from: pocket.title)
                        print("아이템 삭제됨: \(self.currentItem.title) from \(pocket.title)")
                        break
                    }
                }
            }
            isInPocketStatus = false
            isInPocket.onNext(false)
        }
    }
    
    func addToPocket() {
        isInPocketStatus = true
        isInPocket.onNext(true)
    }
}
