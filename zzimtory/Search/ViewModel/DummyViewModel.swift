//
//  DummyViewModel.swift
//  zzimtory
//
//  Created by 김하민 on 1/26/25.
//

import RxSwift

protocol SearchViewModel {
    var searchResult: BehaviorSubject<[Item]> { get set }
    
    func setQuery(to string: String)
    func search()
}

protocol SearchViewModelBindable {
    func bind(to viewModel: some SearchViewModel)
}

final class ItemSearchViewModel: SearchViewModel {
    var searchResult = BehaviorSubject(value: [Item]())
    
    private var query = ""
    private let disposeBag = DisposeBag()
    private let shoppingRepository = ShoppingRepository()
    
    private func fetchResponse() {
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
    
    func search() {
        fetchResponse()
    }
}
