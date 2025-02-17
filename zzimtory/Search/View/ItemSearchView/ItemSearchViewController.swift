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
    private let searchHistory = UITableView()
    private let itemCollectionView = ItemCollectionView()
    
    private let cardStack = SwipeCardStack()
    
    private let itemSearchViewModel = ItemSearchViewModel()
    private let disposeBag = DisposeBag()
    
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
        navigationController?.navigationBar.isHidden = true
        
        addComponents()
        setSearchBar()
        setSearchHistory()
        setConstraints()
        
        bind()
    }
    
    // MARK: - Private functions
    private func addComponents() {
        [
            searchBar,
            searchHistory
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
            
//            searchBar.becomeFirstResponder()
            view.addSubview(searchHistory)
            
        }).disposed(by: disposeBag)
    }
    
    private func setSearchHistory() {
        searchHistory.backgroundColor = .clear
        searchHistory.separatorStyle = .singleLine
        
        searchHistory.register(ItemSearchHistoryTableCell.self,
                               forCellReuseIdentifier: String(describing: ItemSearchHistoryTableCell.self))
        searchHistory.showsHorizontalScrollIndicator = false
        searchHistory.rowHeight = 40
        
        let headerLabel: UILabel = {
            let label = UILabel()
            
            label.text = "최근 검색어"
            label.font = .systemFont(ofSize: 16, weight: .semibold)
            label.textColor = .black900Zt
            label.textAlignment = .left
            
            return label
        }()
        
        searchHistory.tableHeaderView = headerLabel
        
        headerLabel.snp.makeConstraints { make in
            make.width.equalTo(searchHistory.snp.width).inset(24)
        }
    }
    
    private func setColletionView() {
        view.addSubview(itemCollectionView)
        
        itemCollectionView.register(ItemCollectionViewCell.self,
                                    forCellWithReuseIdentifier: String(describing: ItemCollectionViewCell.self))
        itemCollectionView.delegate = self
        itemCollectionView.isScrollEnabled = true
    
        itemCollectionView.register(ItemCollectionViewHeader.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: String(describing: ItemCollectionViewHeader.self))
        
        itemCollectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.top.equalTo(searchBar.snp.bottom).offset(12)
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
        
        searchHistory.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.width.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
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
            didSelectSearchHistoryAt: searchHistory.rx.itemSelected
        )
        
        // MARK: - Outputs
        let output = itemSearchViewModel.transform(input: input)
        
        // MARK: - 검색 결과값 CollectionView에 바인딩
        output.searchResult
            .do(onNext: { [weak self] _ in
                self?.setColletionView()
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
                
                let leftOverlay = UIView()
                leftOverlay.backgroundColor = .clear
                
                let rightOverlay = UIView()
                rightOverlay.backgroundColor = .clear
                
                let upOverlay = UIView()
                upOverlay.backgroundColor = .clear
                
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
        output.selectedCell
            .drive(onNext: { item in
                print("Tapped: \(item)")
                let detailVC = ItemDetailViewController(items: [item])
                detailVC.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(detailVC, animated: true)
                
//                if let viewController = self.next as? UIViewController {
//                    viewController.navigationController?.pushViewController(detailVC, animated: true)
//                }
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
                print(query)
                self.searchBar.searchTextField.text = query
                self.searchHistory.reloadData()
                self.searchBar.resignFirstResponder()
                self.searchHistory.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }
}

extension ItemSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let reusableView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: String(describing: ItemCollectionViewHeader.self),
                for: indexPath
            )
            
            guard let header = reusableView as? ItemCollectionViewHeader else {
                assertionFailure("UICollectionReusableView를 ItemCollectionViewHeader로 캐스팅하는 데 실패함")
                return UICollectionReusableView()
            }
            
            return header
        }
        
        return UICollectionReusableView()
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
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
