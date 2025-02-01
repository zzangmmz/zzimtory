//
//  DummyViewModel.swift
//  zzimtory
//
//  Created by 김하민 on 1/26/25.
//

import RxSwift

// ItemSearchView, ItemCardsView와 바인딩하여 사용하는 ItemSearchViewModel입니다.
// SearchViewModel 프로토콜에 대한 설명은 SearchViewModel+Bindable 파일에 기재되어 있습니다.
final class ItemSearchViewModel: SearchViewModel {
    
    let searchResult = BehaviorSubject(value: [Item]())
    
    private var query = ""
    internal let disposeBag = DisposeBag()
    private let shoppingRepository = ShoppingRepository()
    
    func search() {
        shoppingRepository.fetchSearchData(query: query)
            .subscribe(
                onSuccess: { [weak self] (result: ShoppingAPIResponse) in
                    self?.searchResult.onNext(result.items)
                },
                onFailure: { [weak self] error in
                    self?.searchResult.onError(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func setQuery(to string: String) {
        query = string
    }
    
}
