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
    
    private let userDefaults = UserDefaults.standard
    private let recentItemsKey = "recentItems"
    private(set) var recentItems = [Item]()
    
    private var currentItems: Observable<[Item]> = Observable.just([])
    private var searchHistory = UserDefaults.standard.array(forKey: "searchHistory") as? [String] ?? [] {
        didSet {
            // 10개 이상일 경우 초과되는 기록 제거
            if searchHistory.count > 10 {
                searchHistory.removeSubrange(10..<searchHistory.count)
            }
            
            searchHistory = searchHistory.filter { !$0.isEmpty }
            UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
        }
    }
    
    // MARK: - 무한 스크롤 프로퍼티
    private var currentPage = 1     // 현재 페이지
    private var isLoading = false   // 로딩중인지 체크
    private var hasMoreData = true  // 더 가져올 데이터가 있는지 체크
    private let itemsPerPage = 10   // request당 가져올 데이터 개수
    
    struct Input {
        var query: Observable<String>
        var didSelectCard: Observable<Int>
        var didSwipeCard: Observable<(Int, SwipeDirection)>
        var didSwipeAllCards: Observable<Void>
        var didSelectItemAt: ControlEvent<IndexPath>
        var didSelectSearchHistoryAt: ControlEvent<IndexPath>
        var didRemoveItemAt: ControlEvent<IndexPath>
        var didTapClearHistory: ControlEvent<Void>
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
        
        // MARK: - 검색 기록
        let searchHistoryRemoved = input.didRemoveItemAt
            .withUnretained(self)
            .flatMap { viewModel, indexPath -> Observable<[String]> in
                viewModel.searchHistory.remove(at: indexPath.item)
                return Observable.just(viewModel.searchHistory)
            }
        
        let searchHistoryCleared = input.didTapClearHistory
            .withUnretained(self)
            .flatMap { viewModel, _ -> Observable<[String]> in
                viewModel.searchHistory.removeAll()
                return Observable.just(viewModel.searchHistory)
            }
        
        let searchHistory = Observable.merge(
            Observable.just(searchHistory),
            searchHistoryRemoved,
            searchHistoryCleared
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
    
    func loadItems() {
        if let data = userDefaults.data(forKey: recentItemsKey) {
            do {
                let items = try JSONDecoder().decode([Item].self, from: data)
                self.recentItems = items
            } catch {
                print("최근 본 아이템 - 유저 디폴트 디코딩 에러: \(error)")
            }
        }
    }
}
