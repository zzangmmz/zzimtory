//
//  DetailViewModel.swift
//  zzimtory
//
//  Created by seohuibaek on 1/31/25.
//

import RxSwift
import UIKit

final class DetailViewModel {
    private let disposeBag = DisposeBag()
    private let shoppingRepository = ShoppingRepository()
    
    // 임시 로그인 상태 변수
    static var isLoggedIn: Bool = true
    
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
    private var isInPocketStatus: Bool = false
    
    init(item: Item) {
        self.currentItem = item
        setupData()
        setupSearchQuery()
        fetchSimilarItems()
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
        
        print("검색어: \(searchQuery)")
    }
    
    // 유사 상품 검색
    private func fetchSimilarItems() {
        // 임시로 더미 데이터 사용
        // let dummyItems = DetailDummyItems.dummyItems.filter { $0.productID != currentItem.productID }
        // similarItems.onNext(dummyItems)
        
        shoppingRepository.fetchSearchData(query: searchQuery)
            .subscribe(onSuccess: { [weak self] response in
                let filteredItems = response.items.filter { $0.productID != self?.currentItem.productID }
                self?.similarItems.onNext(filteredItems)
                print(filteredItems)
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
    
    func handlePocketButton() -> Bool {
        // 로그인 체크
        guard DetailViewModel.isLoggedIn else {
            return false
        }
        
        // 주머니에 있을 때만 상태 변경
        if isInPocketStatus {
            isInPocketStatus = false
            isInPocket.onNext(false)
        }
        
        return isInPocketStatus
    }
    
    func addToPocket() {
        isInPocketStatus = true
        isInPocket.onNext(true)
    }
}
