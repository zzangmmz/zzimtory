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
    var searchHistory = UserDefaults.standard.array(forKey: "searchHistory") as? [String] ?? [] {
        didSet {
            // 10개 이상일 경우 초과되는 기록 제거
            if searchHistory.count > 10 {
                searchHistory.removeSubrange(10..<searchHistory.count)
            }
            
            searchHistory = searchHistory.filter { !$0.isEmpty }
            UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
        }
    }
    
    struct Input {
        var query: Observable<String>
        var didSelectCard: Observable<Int>
        var didSwipeCard: Observable<(Int, SwipeDirection)>
        var didSwipeAllCards: Observable<Void>
        var didSelectItemAt: ControlEvent<IndexPath>
        var didSelectSearchHistoryAt: ControlEvent<IndexPath>
        var didRemoveItemAt: ControlEvent<IndexPath>
    }
    
    struct Output {
        let searchResult: Driver<[Item]>
        let selectedCard: Driver<Item>
        let swipedCard: Driver<SwipedCard>
        let swipedAllCards: Driver<Void>
        let selectedCell: Driver<Item>
        let searchHistory: Driver<[String]>
        let selectedSearchHistory: Driver<String>
    }
    
    struct SwipedCard {
        let item: Item
        let direction: SwipeDirection
    }
    
    func transform(input: Input) -> Output {
        
        let selectedSearchHistory = input.didSelectSearchHistoryAt
            .debug("Rx: selectedSearchHistory")
            .withUnretained(self)
            .flatMap { viewModel, indexPath -> Observable<String> in
                print("tapped \(indexPath.item)")
                let selectedHistory = viewModel.searchHistory[indexPath.item]
                return Observable.just(selectedHistory)
            }
            .share()
            
        let query = Observable.merge(
            input.query,
            selectedSearchHistory
        )
        
        let searchResult = query
            .debug("Rx: searchResult")
            .withUnretained(self)
            .flatMap { viewModel, query -> Observable<[Item]> in
                
                if viewModel.searchHistory.contains(query) {
                    viewModel.searchHistory.removeAll(where: { $0 == query })
                }
                
                viewModel.searchHistory.insert(query, at: 0)
                
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
        
        let searchHistoryRemoved = input.didRemoveItemAt
            .withUnretained(self)
            .flatMap { viewModel, indexPath -> Observable<[String]> in
                viewModel.searchHistory.remove(at: indexPath.item)
                return Observable.just(viewModel.searchHistory)
            }
        
        let searchHistory = Observable.merge(
            Observable.just(searchHistory),
            searchHistoryRemoved
        )
        
        let output = Output(searchResult: searchResult,
                            selectedCard: selectedCard,
                            swipedCard: swipedCard,
                            swipedAllCards: swipedAllCards,
                            selectedCell: selectedCell,
                            searchHistory: searchHistory.asDriver(onErrorDriveWith: .empty()),
                            selectedSearchHistory: selectedSearchHistory.asDriver(onErrorDriveWith: .empty())
        )
        
        return output
    }
}
