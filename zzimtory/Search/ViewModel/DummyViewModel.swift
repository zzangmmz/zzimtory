//
//  DummyViewModel.swift
//  zzimtory
//
//  Created by 김하민 on 1/26/25.
//

import RxSwift

final class ItemSearchViewModel: SearchViewModel {
    let searchResult = BehaviorSubject(value: [Item]())
    
    private var query = ""
    private let disposeBag = DisposeBag()
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
