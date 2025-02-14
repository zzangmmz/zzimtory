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
final class ItemSearchViewModel {
    private let shoppingRepository = ShoppingRepository()
    var disposeBag = DisposeBag()

    var currentItems: Observable<[Item]> = Observable.just([])
    
    struct Input {
        var query: Observable<String>
        var didSelectCard: Observable<Int>
        var didSwipeCard: Observable<(Int, SwipeDirection)>
        var didSwipeAllCards: Observable<Void>
        var didSelectItemAt: ControlEvent<IndexPath>
    }
    
    struct Output {
        let searchResult: Driver<[Item]>
        let selectedCard: Driver<Item>
        let swipedCard: Driver<SwipedCard>
        let swipedAllCards: Driver<Void>
        let selectedCell: Driver<Item>
    }
    
    struct SwipedCard {
        let item: Item
        let direction: SwipeDirection
    }
    
    func transform(input: Input) -> Output {
        let searchResult = input.query
            .withUnretained(self)
            .flatMap { viewModel, query -> Observable<[Item]> in
                let fetchedItems = viewModel.shoppingRepository.fetchForViewModel(with: query)
                viewModel.currentItems = fetchedItems
                return fetchedItems
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let selectedCard = input.didSelectCard
            .withUnretained(self)
            .flatMap { viewModel, index -> Observable<Item> in
                return viewModel.currentItems.compactMap { $0[index] }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let swipedCard = input.didSwipeCard
            .withUnretained(self)
            .flatMap { viewModel, didSwipeCardAt -> Observable<SwipedCard> in
                let observableItem = viewModel.currentItems.compactMap { $0[didSwipeCardAt.0] }
                
                let swipedCard = observableItem
                    .map { SwipedCard(item: $0, direction: didSwipeCardAt.1)}
                
                return swipedCard
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let swipedAllCards = input.didSwipeAllCards
            .asDriver(onErrorJustReturn: ())
        
        let selectedCell = input.didSelectItemAt
            .withUnretained(self)
            .flatMap { viewModel, indexPath -> Observable<Item> in
                return viewModel.currentItems.compactMap { $0[indexPath.item] }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let output = Output(searchResult: searchResult,
                            selectedCard: selectedCard,
                            swipedCard: swipedCard,
                            swipedAllCards: swipedAllCards,
                            selectedCell: selectedCell
        )
        
        return output
    }
}
