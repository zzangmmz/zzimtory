//
//  DummyViewModel.swift
//  zzimtory
//
//  Created by 김하민 on 1/26/25.
//

import Foundation
import RxSwift
import RxCocoa

// ItemSearchView, ItemCardsView와 바인딩하여 사용하는 ItemSearchViewModel입니다.
// SearchViewModel 프로토콜에 대한 설명은 SearchViewModel+Bindable 파일에 기재되어 있습니다.
final class ItemSearchViewModel: ViewModel {
    private let shoppingRepository = ShoppingRepository()
    var disposeBag = DisposeBag()

    struct Input {
        var query: Observable<String>
    }
    
    struct Output {
        let searchResult: Driver<[Item]>
    }
    
    func transform(input: Input) -> Output {
        let searchResult = input.query
            .withUnretained(self)
            .flatMap { vm, query -> Observable<[Item]> in
                return vm.shoppingRepository.fetchForViewModel(with: query)
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(searchResult: searchResult)
    }
}
