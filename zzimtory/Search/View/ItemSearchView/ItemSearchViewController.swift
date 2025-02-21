//
//  SearchViewController.swift
//  zzimtory
//
//  Created by 김하민 on 1/24/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemSearchViewController: ZTViewController {
    
    private let searchBar = UISearchBar()
    private let recentItemsView = RecentItemsView()
    private let searchHistory = UITableView()
    private let searchHistoryHeader = SearchHistoryHeader()
    private let itemCollectionView = ItemCollectionView()
    private let itemCollectionViewHeader = ItemCollectionViewHeader()
    
    private let cardStack = SwipeCardStack()
    
    private let itemSearchViewModel = ItemSearchViewModel()
    private var disposeBag = DisposeBag()
    
    private let dimLayerTapRecognizer = UITapGestureRecognizer()
    private let dismissKeyboardTapRecognizer = UITapGestureRecognizer()
    
    // MARK: - Background layer
    private lazy var dimLayer: CALayer = {
        let layer = CALayer()
        
        layer.frame = self.view.bounds
        layer.backgroundColor = CGColor(gray: 0.1, alpha: 0.7)
        
        return layer
    }()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ItemSearchViewController Loaded")
        
        addComponents()
        setSearchBar()
        setCardStack()
        setCollectionView()
        setRecectItems()
        setSearchHistory()
        setConstraints()
        
        bind()
        bindRecentItemsCollectionView()
        otherRxCocoaStuff()
        
        hideCardStack()
        showRecents()
        hideSearchResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        itemSearchViewModel.loadItems()
    }
    
    // MARK: - Private functions
    private func addComponents() {
        [
            searchBar,
            recentItemsView,
            searchHistory,
            searchHistoryHeader,
            cardStack,
            itemCollectionViewHeader,
            itemCollectionView
        ].forEach { view.addSubview($0) }
    }
    
    private func setSearchBar() {
        searchBar.placeholder = "검색"
        searchBar.searchBarStyle = .default
        searchBar.layer.cornerRadius = 14
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .white100Zt
        
        view.addSubview(searchBar)
        
        searchBar.rx.searchButtonClicked
            .withUnretained(self)
            .subscribe(onNext: { itemSearchVC, _ in
                // 키보드 내리기
                itemSearchVC.searchBar.resignFirstResponder()
                
                itemSearchVC.hideRecents()
                itemSearchVC.showSearchResults()
                itemSearchVC.showCardStack()
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .withUnretained(self)
            .subscribe(onNext: { itemSearchVC, _ in
                itemSearchVC.searchBar.becomeFirstResponder()
                itemSearchVC.view.addSubview(itemSearchVC.searchHistory)
                itemSearchVC.showRecents()
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .withUnretained(self)
            .subscribe(onNext: { itemSearchVC, _ in
                itemSearchVC.view.addGestureRecognizer(itemSearchVC.dismissKeyboardTapRecognizer)
                itemSearchVC.searchHistory.visibleCells.forEach { $0.selectionStyle = .none }
            })
            .disposed(by: disposeBag)
                       
        dismissKeyboardTapRecognizer.rx.event
            .withUnretained(self)
            .subscribe(onNext: { itemSearchVC, _ in
                itemSearchVC.view.endEditing(true)
                itemSearchVC.view.removeGestureRecognizer(itemSearchVC.dismissKeyboardTapRecognizer)
                itemSearchVC.searchHistory.visibleCells.forEach { $0.selectionStyle = .default }
            })
            .disposed(by: disposeBag)
    }
    
    private func setRecectItems() {
        recentItemsView.backgroundColor = .clear
        
        [
            recentItemsView.titleLabel,
            recentItemsView.collectionView,
            recentItemsView.placeHolder
        ]
            .forEach {
                $0.snp.makeConstraints { make in
                    make.horizontalEdges.equalToSuperview()
                }
            }
        
        // loadRecentItems()
    }
    
//    private func loadRecentItems() {
//        itemSearchViewModel.loadItems()
//        
//        if itemSearchViewModel.recentItems.isEmpty {
//            recentItemsView.showPlaceHolderLabel()
//        } else {
//            recentItemsView.hidePlaceHolderLabel()
//        }
//        
//        recentItemsView.collectionView.reloadData()
//    }
    
    private func setSearchHistory() {
        searchHistory.backgroundColor = .clear
        searchHistory.separatorStyle = .singleLine
        
        searchHistory.register(ItemSearchHistoryTableCell.self,
                               forCellReuseIdentifier: String(describing: ItemSearchHistoryTableCell.self))
        searchHistory.showsHorizontalScrollIndicator = false
        searchHistory.showsVerticalScrollIndicator = false
        searchHistory.isScrollEnabled = false
        searchHistory.separatorInset = .zero
        searchHistory.rowHeight = 40
    }
    
    private func setCollectionView() {
        itemCollectionView.register(ItemCollectionViewCell.self,
                                    forCellWithReuseIdentifier: String(describing: ItemCollectionViewCell.self))
        itemCollectionView.isScrollEnabled = true
        
        itemCollectionViewHeader.cardButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { itemSearchVC, _ in
                itemSearchVC.showCardStack()
            })
            .disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        
        searchBar.searchTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        recentItemsView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            // make.horizontalEdges.equalToSuperview().inset(24)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(4)
            make.height.equalTo(170)
        }
        
        searchHistoryHeader.snp.makeConstraints { make in
            make.top.equalTo(recentItemsView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
            
        }
        
        searchHistory.snp.makeConstraints { make in
            make.top.equalTo(searchHistoryHeader.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(400)
        }
        
        cardStack.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.9)
            make.height.equalTo(UIScreen.main.bounds.height * 0.7)
            make.center.equalToSuperview()
        }
        
        itemCollectionViewHeader.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(40)
        }
        
        itemCollectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.top.equalTo(itemCollectionViewHeader.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    private func setCardStack() {
        cardStack.backgroundColor = .clear
        cardStack.layer.cornerRadius = 14
        
        dimLayerTapRecognizer.rx.event
            .withUnretained(self)
            .subscribe(onNext: { itemSearchVC, _ in
                print("Dismiss Card Stack")
                itemSearchVC.hideCardStack()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - CardStack 보이기/숨기기
    private func showCardStack() {
        cardStack.isHidden = false
        view.layer.addSublayer(dimLayer)
        dimLayer.isHidden = false
        
        view.addGestureRecognizer(dimLayerTapRecognizer)
        
        self.tabBarController?.tabBar.isHidden = true
        
        view.bringSubviewToFront(cardStack)
        searchBar.isUserInteractionEnabled = false
        
        let userDefaults = UserDefaults.standard
        
        let hasShownTutorialBefore = userDefaults.bool(forKey: "hasShownTutorialBefore")
    
        if !hasShownTutorialBefore {
            showOnBoardingTutorial()
            userDefaults.set(true, forKey: "hasShownTutorialBefore")
        }
        
    }
    
    private func hideCardStack() {
        cardStack.isHidden = true
        dimLayer.isHidden = true
        
        self.tabBarController?.tabBar.isHidden = false
        
        view.removeGestureRecognizer(dimLayerTapRecognizer)
        searchBar.isUserInteractionEnabled = true
    }
    
    private func showOnBoardingTutorial() {

        let tutorialView = ItemSearchTutorial()
        
        view.addSubview(tutorialView)
        
        tutorialView.snp.makeConstraints { make in
            make.edges.equalTo(cardStack.snp.edges)
            make.center.equalTo(cardStack.snp.center)
        }

        tutorialView.beginTutorial(onComplete: { tutorialView.removeFromSuperview() })

    }
 
    // MARK: - 최근 검색어 보이기/숨기기
    private func showRecents() {
        recentItemsView.isHidden = false
        
        searchHistory.isHidden = false
        searchHistoryHeader.isHidden = false

        searchHistory.reloadData()
        searchHistory.layoutIfNeeded()
    }
    
    private func hideRecents() {
        recentItemsView.isHidden = true
        
        searchHistory.isHidden = true
        searchHistoryHeader.isHidden = true
    }
    
    private func hideSearchResults() {
        itemCollectionView.isHidden = true
        itemCollectionViewHeader.isHidden = true
    }
    
    private func showSearchResults() {
        itemCollectionView.isHidden = false
        itemCollectionViewHeader.isHidden = false
    }
    
}

// MARK: - View/ViewModel 바인딩
extension ItemSearchViewController {
    func bind() {
        // MARK: - Inputs
        let input = ItemSearchViewModel.Input(
            query: searchBar.rx.searchButtonClicked
                .withLatestFrom(searchBar.rx.text.orEmpty),
            didSelectCard: cardStack.rx.didSelectCardAt,
            didSwipeCard: cardStack.rx.didSwipeCardAt,
            didSwipeAllCards: cardStack.rx.didSwipeAllCards,
            didSelectItemAt: itemCollectionView.rx.itemSelected,
            didSelectSearchHistoryAt: searchHistory.rx.itemSelected,
            didRemoveItemAt: searchHistory.rx.itemDeleted,
            didTapClearHistory: searchHistoryHeader.tappedClearHistory()
        )
        
        // MARK: - Outputs
        let output = itemSearchViewModel.transform(input: input)
        
        // MARK: - 검색 결과값 CollectionView에 바인딩
        output.searchResult
            .drive(itemCollectionView.rx.items(
                cellIdentifier: String(describing: ItemCollectionViewCell.self),
                cellType: ItemCollectionViewCell.self)
            ) { (row, element, cell) in
                cell.setCell(with: element)
            }
            .disposed(by: disposeBag)
        
        // MARK: - 검색 결과를 CardStack으로 표시해주는 코드
        output.searchResult
            .drive(cardStack.rx.items(with: { item in
                let card = SwipeCard()
                
                card.swipeDirections = [.left, .right, .up]
                // TO-DO: card.footer 확인해서 넣을지 결정
                card.content = ItemCardContents(item: item)
                card.contentMode = .scaleAspectFill
                
                let leftOverlay = ItemCardOverlay(with: .left)
                
                let rightOverlay = ItemCardOverlay(with: .right)
                
                let upOverlay = ItemCardOverlay(with: .up)
                
                card.setOverlays([.left: leftOverlay, .right: rightOverlay, .up: upOverlay])
                
                card.layer.cornerRadius = 8
                
                return card
            }))
            .disposed(by: disposeBag)
        
        // MARK: - 카드 선택 시 아이템 상세화면 표시
        output.selectedCard
            .drive(onNext: { cardItem in
                
                let detailVC = ItemDetailViewController(items: [cardItem])
                detailVC.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(detailVC, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        // MARK: - 카드 스와이프 제스쳐 지정
        output.swipedCard
            .drive(onNext: { swipedCard in
                switch swipedCard.direction {
                case .right:
                    DatabaseManager.shared.addItemToAggregatePocket(newItem: swipedCard.item) { return }
                case .left: break
                case .up:
                    guard DatabaseManager.shared.hasUserLoggedIn() else {
                        self.navigationController?.present(LoginViewController(), animated: true)
                        
                        return
                    }
                    
                    let pocketSelectionVC = PocketSelectionViewController(selectedItems: [swipedCard.item])
                    
                    self.navigationController?.present(pocketSelectionVC, animated: true)
                    
                default: print("Undefined swipe direction")
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: - 모든 카드 스와이프 완료
        output.swipedAllCards
            .drive(with: self, onNext: { itemSearchVC, _ in
                itemSearchVC.cardStack.removeFromSuperview()
                itemSearchVC.dimLayer.removeFromSuperlayer()
                itemSearchVC.view.removeGestureRecognizer(itemSearchVC.dimLayerTapRecognizer)
            })
            .disposed(by: disposeBag)
        
        // MARK: - CollectionView에서 셀 선택 시 동작
        //        output.selectedCell
        //            .drive(onNext: { item in
        //                print("Tapped: \(item)")
        //                let detailVC = ItemDetailViewController(items: [item])
        //                detailVC.hidesBottomBarWhenPushed = true
        //
        //                self.navigationController?.pushViewController(detailVC, animated: true)
        //            })
        //            .disposed(by: disposeBag)
        // 
        
        output.selectedCell
            .drive(onNext: { (items, selectedIndex) in
                let detailVC = ItemDetailViewController(items: items, currentIndex: selectedIndex)
                detailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // MARK: - 최근 검색기록 바인딩
        output.searchHistory
            .drive(searchHistory.rx.items(cellIdentifier: String(describing: ItemSearchHistoryTableCell.self),
                                          cellType: ItemSearchHistoryTableCell.self)
            ) { row, element, cell in
                cell.setCell(with: element)
            }
            .disposed(by: disposeBag)
        
        // MARK: - 최근 검색기록 선택 시 동작
        output.selectedSearchHistory
            .drive(with: self, onNext: { itemSearchVC, query in
                print("Rx: VC Output selected search history: \(query)")
                itemSearchVC.searchBar.searchTextField.text = query
                itemSearchVC.searchBar.resignFirstResponder()
                itemSearchVC.hideRecents()
                itemSearchVC.showSearchResults()
                itemSearchVC.showCardStack()
            })
            .disposed(by: disposeBag)
    }
    
    // 최근 본 아이템 CollectionView 바인딩
    func bindRecentItemsCollectionView() {
        // 구독하여 UI 업데이트
        itemSearchViewModel.recentItems
            .withUnretained(self)
            .subscribe(onNext: { itemSearchVC, items in
                if items.isEmpty {
                    itemSearchVC.recentItemsView.showPlaceHolderLabel()
                } else {
                    itemSearchVC.recentItemsView.hidePlaceHolderLabel()
                }
            })
            .disposed(by: disposeBag)
        
        // 데이터소스 바인딩
        itemSearchViewModel.recentItems
            .bind(to: recentItemsView.collectionView.rx.items(
                cellIdentifier: String(describing: RecentItemCell.self),
                cellType: RecentItemCell.self
            )) { _, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        
        // 상세 화면 이동 로직
        recentItemsView.collectionView.rx.itemSelected
            .withLatestFrom(itemSearchViewModel.recentItems) { indexPath, items in
                return items[indexPath.item]
            }
            .withUnretained(self)
            .subscribe(onNext: { itemSearchVC, item in
                let detailVC = ItemDetailViewController(items: [item])
                detailVC.hidesBottomBarWhenPushed = true
                itemSearchVC.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func otherRxCocoaStuff() {
        // MARK: - Delegate 설정
        itemCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // MARK: -
        searchBar.rx.textDidBeginEditing
            .withUnretained(self)
            .subscribe(onNext: { _ in
                self.showRecents()
                self.hideSearchResults()
            }).disposed(by: disposeBag)
    }
}

extension ItemSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsInRow: CGFloat = 2
        let spacing: CGFloat = 12
        let totalSpacing = spacing * (numberOfCellsInRow - 1)
        
        let availableWidth = collectionView.bounds.width - totalSpacing
        let cellWidth = availableWidth / numberOfCellsInRow
        
        return CGSize(width: cellWidth, height: cellWidth * 1.25)
    }
}

extension ItemSearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 터치된 뷰가 컬렉션뷰나 버튼이면 제스처를 무시
        if touch.view?.isDescendant(of: itemCollectionView) == true {
            return false
        }
        return true
    }
}

extension ItemSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == itemCollectionView else { return }
        
        let offsetY = scrollView.contentOffset.y            // 현재 스크롤된 위치
        let contentHeight = scrollView.contentSize.height   // 스크롤뷰 내부 컨텐츠들의 전체 높이
        let height = scrollView.frame.size.height           // 현재 화면에 보이는 스크롤뷰의 높이
        
        // 스크롤이 완전히 끝에 도달했을 때만!! 다음 페이지 로드
        if offsetY >= contentHeight - height {
            loadNextPageIfNeeded()
        }
    }
    
    private func loadNextPageIfNeeded() {
        guard
            let query = searchBar.text,
            !query.isEmpty
        else { return }
        
        // 다음 페이지 로드
        itemSearchViewModel.loadNextPage(query: query)
    }
}
