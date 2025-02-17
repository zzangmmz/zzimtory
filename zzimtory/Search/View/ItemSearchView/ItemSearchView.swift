//
//  ItemSearchView.swift
//  zzimtory
//
//  Created by 김하민 on 1/24/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemSearchView: ZTView {
    
    private let searchBar = UISearchBar()
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
        
        layer.frame = self.bounds
        layer.backgroundColor = CGColor(gray: 0.1, alpha: 0.7)
        
        return layer
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSearchBar()
        setColletionView()
        setConstraints()
        
        bind()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    private func setSearchBar() {
        searchBar.placeholder = "검색"

        searchBar.searchTextField.backgroundColor = .white100Zt
        searchBar.searchBarStyle = .minimal
        
        addSubview(searchBar)
        
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [unowned self] in
            searchBar.resignFirstResponder() // 키보드 내리기
            
            // TabBar 숨기기
            if let viewController = self.next as? UIViewController {
                viewController.tabBarController?.tabBar.isHidden = true
            }
        }).disposed(by: disposeBag)
    }
    
    private func setColletionView() {
        itemCollectionView.register(ItemCollectionViewCell.self,
                                    forCellWithReuseIdentifier: String(describing: ItemCollectionViewCell.self))
        itemCollectionView.delegate = self
        itemCollectionView.isScrollEnabled = true
        itemCollectionView.register(ItemCollectionViewHeader.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: String(describing: ItemCollectionViewHeader.self))
        
        addSubview(itemCollectionView)
    }
    
    private func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        itemCollectionView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(12)
            make.top.equalTo(searchBar.snp.bottom).offset(12)
        }
    }
    
    private func setCardStack() {
        cardStack.backgroundColor = .clear
        
        layer.addSublayer(dimLayer)
        addSubview(cardStack)
        
        cardStack.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.9)
            make.height.equalTo(UIScreen.main.bounds.height * 0.7)
            make.center.equalToSuperview()
        }
        
        addGestureRecognizer(dimLayerTapRecognizer)
        
    }
    
    @objc private func onTap() {
        print("ItemCardsView Tapped")
        cardStack.removeFromSuperview()
        dimLayer.removeFromSuperlayer()
        
        // TabBar 다시 보이기
        if let viewController = self.next as? UIViewController {
            viewController.tabBarController?.tabBar.isHidden = false
        }
        
        removeGestureRecognizer(dimLayerTapRecognizer)
    }
    
}

// MARK: - View/ViewModel 바인딩
extension ItemSearchView {
    func bind() {
        // MARK: - Inputs
        let input = ItemSearchViewModel.Input(
            query: searchBar.rx.searchButtonClicked
                .withLatestFrom(searchBar.rx.text.orEmpty),
            didSelectCard: cardStack.rx.didSelectCardAt,
            didSwipeCard: cardStack.rx.didSwipeCardAt,
            didSwipeAllCards: cardStack.rx.didSwipeAllCards,
            didSelectItemAt: itemCollectionView.rx.itemSelected
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
                
                let detailVC = DetailViewController(item: cardItem)
                detailVC.hidesBottomBarWhenPushed = true
                
                if let viewController = self.next as? UIViewController {
                    viewController.navigationController?.pushViewController(detailVC, animated: true)
                }
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
                        self?.window?.rootViewController?.present(LoginViewController(),
                                                                 animated: true)
                        return
                    }
                    
                    let pocketSelectionVC = PocketSelectionViewController(selectedItems: [swipedCard.item])
                    
                    self?.window?.rootViewController?.present(pocketSelectionVC, animated: true)
                    
                default: print("Undefined swipe direction")
                }
            })
            .disposed(by: disposeBag)
        
        // MARK: - 모든 카드 스와이프 완료
        output.swipedAllCards
            .drive(onNext: { [unowned self] in
                cardStack.removeFromSuperview()
                dimLayer.removeFromSuperlayer()
                removeGestureRecognizer(dimLayerTapRecognizer)
            })
            .disposed(by: disposeBag)
        
        // MARK: - CollectionView에서 셀 선택 시 동작
        output.selectedCell
            .drive(onNext: { item in
                let detailVC = DetailViewController(item: item)
                detailVC.hidesBottomBarWhenPushed = true
                
                if let viewController = self.next as? UIViewController {
                    viewController.navigationController?.pushViewController(detailVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension ItemSearchView: UICollectionViewDelegate {
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

extension ItemSearchView: UICollectionViewDelegateFlowLayout {
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

extension ItemSearchView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 터치된 뷰가 컬렉션뷰나 버튼이면 제스처를 무시
        if touch.view?.isDescendant(of: itemCollectionView) == true {
            return false
        }
        return true
    }
}
