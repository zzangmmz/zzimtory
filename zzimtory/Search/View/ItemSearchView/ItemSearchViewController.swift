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
    
    var items: [Item] = []
    
    private lazy var dimLayerTapRecognizer = UITapGestureRecognizer(target: self,
                                                                    action: #selector(onTap))
    
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
        setRecectItems()
        setSearchHistory()
        setConstraints()
        
        bind()
        bindRecentItemsCollectionView()
        otherRxCocoaStuff()
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
            searchHistoryHeader
        ].forEach { view.addSubview($0) }
    }
    
    private func setSearchBar() {
        searchBar.placeholder = "검색"
        searchBar.searchBarStyle = .default
        searchBar.layer.cornerRadius = 14
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.backgroundColor = .white100Zt
        
        view.addSubview(searchBar)
        
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [unowned self] in
            searchBar.resignFirstResponder() // 키보드 내리기
            
            // TabBar 숨기기
            if let viewController = self.next as? UIViewController {
                viewController.tabBarController?.tabBar.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked.subscribe(onNext: { [unowned self] in
            
            searchBar.becomeFirstResponder()
            view.addSubview(searchHistory)
            
        }).disposed(by: disposeBag)
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
        view.addSubview(itemCollectionViewHeader)
        view.addSubview(itemCollectionView)
        
        itemCollectionView.register(ItemCollectionViewCell.self,
                                    forCellWithReuseIdentifier: String(describing: ItemCollectionViewCell.self))
        itemCollectionView.isScrollEnabled = true
        
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
    
    private func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).offset(16)
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
    }
    
    private func setCardStack() {
        cardStack.backgroundColor = .clear
        
        view.layer.addSublayer(dimLayer)
        view.addSubview(cardStack)
        
        cardStack.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.9)
            make.height.equalTo(UIScreen.main.bounds.height * 0.7)
            make.center.equalToSuperview()
        }
        
        view.addGestureRecognizer(dimLayerTapRecognizer)
        
    }
    
    private func showRecentsAndHideSearchResults() {
        recentItemsView.isHidden = false
        searchHistory.isHidden = false
        searchHistoryHeader.isHidden = false
        
        itemCollectionView.isHidden = true
        itemCollectionViewHeader.isHidden = true
        searchHistory.reloadData()
    }
    
    private func hideRecentsAndShowSearchResults() {
        recentItemsView.isHidden = true
        searchHistory.isHidden = true
        searchHistoryHeader.isHidden = true
        
        itemCollectionView.isHidden = false
        itemCollectionViewHeader.isHidden = false
    }
    
    @objc private func onTap() {
        print("ItemCardsView Tapped")
        cardStack.removeFromSuperview()
        dimLayer.removeFromSuperlayer()
        
        // TabBar 다시 보이기
        if let viewController = self.next as? UIViewController {
            viewController.tabBarController?.tabBar.isHidden = false
        }
        
        view.removeGestureRecognizer(dimLayerTapRecognizer)
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
            .do(onNext: { [weak self] _ in
                self?.setCollectionView()
                self?.hideRecentsAndShowSearchResults()
            })
            .drive(itemCollectionView.rx.items(
                cellIdentifier: String(describing: ItemCollectionViewCell.self),
                cellType: ItemCollectionViewCell.self)
            ) { (row, element, cell) in
                cell.setCell(with: element)
            }
            .disposed(by: disposeBag)
        
        // MARK: - 검색 결과를 CardStack으로 표시해주는 코드
        output.searchResult
            .do(onNext: { [weak self] _ in
                self?.setCardStack()
            })
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
            .drive(onNext: { [weak self] swipedCard in
                switch swipedCard.direction {
                case .right: break
                case .left: break
                case .up:
                    guard DatabaseManager.shared.hasUserLoggedIn() else {
                        self?.navigationController?.present(LoginViewController(), animated: true)
                        
                        return
                    }
                    
                    let pocketSelectionVC = PocketSelectionViewController(selectedItems: [swipedCard.item])
                    
                    self?.navigationController?.present(pocketSelectionVC, animated: true)
                    
                default: print("Undefined swipe direction")
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: - 모든 카드 스와이프 완료
        output.swipedAllCards
            .drive(onNext: { [unowned self] in
                cardStack.removeFromSuperview()
                dimLayer.removeFromSuperlayer()
                view.removeGestureRecognizer(dimLayerTapRecognizer)
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
            .drive(onNext: { [unowned self] query in
                print("Rx: VC Output selected search history: \(query)")
                self.searchBar.searchTextField.text = query
                self.searchBar.resignFirstResponder()
                self.hideRecentsAndShowSearchResults()
            })
            .disposed(by: disposeBag)
    }
    
    // 최근 본 아이템 CollectionView 바인딩
    func bindRecentItemsCollectionView() {
        // 구독하여 UI 업데이트
        itemSearchViewModel.recentItems
            .subscribe(onNext: { [weak self] items in
                guard let self = self else { return }
                
                if items.isEmpty {
                    self.recentItemsView.showPlaceHolderLabel()
                } else {
                    self.recentItemsView.hidePlaceHolderLabel()
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
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                let detailVC = ItemDetailViewController(items: [item])
                detailVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func otherRxCocoaStuff() {
        // MARK: - Delegate 설정
        itemCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // MARK: -
        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [unowned self] _ in
                self.showRecentsAndHideSearchResults()
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
