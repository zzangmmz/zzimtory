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
    private let recentItemsRelay = BehaviorRelay<[Item]>(value: []) // 최근 아이템 Relay 적용
    var recentItems: Observable<[Item]> { return recentItemsRelay.asObservable() }
    
    private let searchHistoryKey = "searchHistory"
    private let searchHistoryRelay = BehaviorRelay<[String]>(value: [])
    private var currentItems = BehaviorRelay<[Item]>(value: [])
    
    // MARK: - 무한 스크롤 프로퍼티
    private var currentPage = 1     // 현재 페이지
    private(set) var isLoading = false   // 로딩중인지 체크
    private(set) var hasMoreData = true  // 더 가져올 데이터가 있는지 체크
    private let itemsPerPage = 10   // request당 가져올 데이터 개수
    
    init() {
        let searchHistory = userDefaults.array(forKey: searchHistoryKey) as? [String] ?? []
        searchHistoryRelay.accept(searchHistory)
    }
    
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
        // let selectedCell: Driver<Item>
        let selectedCell: Driver<([Item], Int)>
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
                let searchHistory = viewModel.searchHistoryRelay.value
                let selectedHistory = searchHistory[indexPath.item]
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
            .flatMap { viewModel, query -> BehaviorRelay<[Item]> in
                viewModel.currentPage = 1
                viewModel.hasMoreData = true
                
                var searchHistory = viewModel.searchHistoryRelay.value
                
                if searchHistory.contains(query) {
                    searchHistory.removeAll(where: { $0 == query })
                }
                
                searchHistory.insert(query, at: 0)
                
                let fetchedItems = viewModel.shoppingRepository.fetchForViewModel(with: query)
                // 불러온 아이템들 추가
                fetchedItems
                    .subscribe(onNext: { [weak viewModel] items in
                        viewModel?.currentItems.accept(items)
                    })
                    .disposed(by: viewModel.disposeBag)
                
                return viewModel.currentItems
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let selectedCard = input.didSelectCard
            .withUnretained(self)
            .flatMap { viewModel, index -> Observable<Item> in
                let items = viewModel.currentItems.value
                return Observable.just(items[index])
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let swipedCard = input.didSwipeCard
            .withUnretained(self)
            .flatMap { viewModel, didSwipeCardAt -> Observable<SwipedCard> in
                let items = viewModel.currentItems.value
                let observableItem = Observable.just(items[didSwipeCardAt.0])
                
                let swipedCard = observableItem
                    .map { SwipedCard(item: $0, direction: didSwipeCardAt.1)}
                
                return swipedCard
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let swipedAllCards = input.didSwipeAllCards
            .asDriver(onErrorJustReturn: ())
        
//        let selectedCell = input.didSelectItemAt
//            .withUnretained(self)
//            .flatMap { viewModel, indexPath -> Observable<Item> in
//                return viewModel.currentItems.compactMap { $0[indexPath.item] }
//            }
//            .asDriver(onErrorDriveWith: .empty())
        
        let selectedCell = input.didSelectItemAt
            .withUnretained(self)
            .flatMap { viewModel, indexPath -> Observable<([Item], Int)> in
                let items = viewModel.currentItems.value
                return Observable.just((items, indexPath.item))
            }
            .asDriver(onErrorDriveWith: .empty())
        
        // MARK: - 검색 기록
        let _ = query.subscribe(onNext: { [weak self] query in
            let searchHistory = self?.searchHistoryRelay.value.filter { $0 != query }
            
            let updatedSearchHistory: [String] = [query] + (searchHistory ?? [])
            
            self?.searchHistoryRelay.accept(updatedSearchHistory)
        })
        
        let _ = input.didRemoveItemAt.subscribe(onNext: { [weak self] index in
            var searchHistory = self?.searchHistoryRelay.value ?? []
            
            searchHistory.remove(at: index.item)
            
            self?.searchHistoryRelay.accept(searchHistory)
        })
        
        let _ = input.didTapClearHistory.subscribe(onNext: { [weak self] in
            self?.searchHistoryRelay.accept([])
        }).disposed(by: disposeBag)
        
        let searchHistory = searchHistoryRelay.asDriver(onErrorDriveWith: .empty())
        
        searchHistoryRelay.bind { [weak self] history in
            var updatedSearchHistory = history
            
            if updatedSearchHistory.count > 10 {
                updatedSearchHistory.removeSubrange(10..<history.count)
                self?.searchHistoryRelay.accept(updatedSearchHistory)
            }
            
            updatedSearchHistory = updatedSearchHistory.filter { !$0.isEmpty }
            self?.userDefaults.set(updatedSearchHistory, forKey: self?.searchHistoryKey ?? "searchHistory")

        }.disposed(by: disposeBag)
        
        let output = Output(searchResult: searchResult,
                            selectedCard: selectedCard,
                            swipedCard: swipedCard,
                            swipedAllCards: swipedAllCards,
                            selectedCell: selectedCell,
                            searchHistory: searchHistory,
                            selectedSearchHistory: selectedSearchHistory.asDriver(onErrorDriveWith: .empty())
        )
        
        return output
    }
    
    func loadItems() {
        if let data = userDefaults.data(forKey: recentItemsKey) {
            do {
                let items = try JSONDecoder().decode([Item].self, from: data)
                // self.recentItems = items
                recentItemsRelay.accept(items) //relay에 넣어줌
            } catch {
                print("최근 본 아이템 - 유저 디폴트 디코딩 에러: \(error)")
            }
        }
    }
    
    func loadNextPage(query: String) {
        // 로딩중이 아니고 && 로드할 데이터가 남은 경우에만 다음 페이지 호출
        guard !isLoading && hasMoreData else { return }
        
        isLoading = true
        currentPage += 1
        
        shoppingRepository.fetchForViewModel(
            with: query,
            page: currentPage,
            itemsPerPage: itemsPerPage
        ).subscribe(
            onNext: { [weak self] newItems in
                guard let self = self else { return }
                
                // 기존 아이템에 새 아이템들 추가
                let currentItems = self.currentItems.value
                let updatedItems = currentItems + newItems
                // 추가로 불러온 데이터 합쳐서 방출
                self.currentItems.accept(updatedItems)

                self.isLoading = false
                self.hasMoreData = newItems.count == self.itemsPerPage
            },
            onError: { [weak self] error in
                self?.isLoading = false
                self?.hasMoreData = false
                print("페이지 로드 중 에러 발생: \(error)")
            }
        ).disposed(by: disposeBag)
    }
}
