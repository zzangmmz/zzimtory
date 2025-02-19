//
//  SimilarItemViewModel.swift
//  zzimtory
//
//  Created by seohuibaek on 2/13/25.
//

import RxSwift
import RxRelay

final class SimilarItemViewModel {
    private let disposeBag = DisposeBag()
    private let shoppingRepository = ShoppingRepository()
    
    private let similarItemsRelay = BehaviorRelay<[Item]>(value: [])
    var similarItems: Observable<[Item]> { similarItemsRelay.asObservable() }
    
    init(item: Item) {
        fetchSimilarItems(for: item)
    }
    
    private func fetchSimilarItems(for item: Item) {
        let cleanTitle = item.title.removingHTMLTags
        let words = cleanTitle.components(separatedBy: " ")
        let searchQuery = words.count >= 3 ? words.prefix(3).joined(separator: " ") : cleanTitle
        
        shoppingRepository.fetchSearchData(query: searchQuery)
            .subscribe(onSuccess: { [weak self] response in
                let filteredItems = response.items.filter { $0.productID != item.productID }
                self?.similarItemsRelay.accept(filteredItems)
            }, onFailure: { error in
                print("유사 상품 검색 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
