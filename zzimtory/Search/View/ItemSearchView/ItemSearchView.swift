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
    
    private let itemCardsView = ItemCardsView()
    
    private let itemSearchViewModel = ItemSearchViewModel()
    private let disposeBag = DisposeBag()
    
    var items: [Item] = []
    
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
        
        bind(to: itemSearchViewModel)
        itemCardsView.setDelegate(to: self)
        itemCardsView.bind(to: itemSearchViewModel)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    private func setSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "검색"

        searchBar.searchTextField.backgroundColor = .white100Zt
        searchBar.searchBarStyle = .minimal
        
        addSubview(searchBar)
    }
    
    private func setColletionView() {
        itemCollectionView.register(ItemCollectionViewCell.self,
                                    forCellWithReuseIdentifier: ItemCollectionViewCell.id)
        itemCollectionView.dataSource = self
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
    
}

// ItemSearchView를 ViewModel에 바인딩해주기 위한 프로토콜 적용입니다.
// 자세한 설명은 SearchViewModel+Bindable 참고 바랍니다.
extension ItemSearchView: SearchViewModelBindable {
    func bind(to viewModel: some SearchViewModel) {
        viewModel.searchResult.observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] result in
                    self?.items = result
                    self?.itemCollectionView.reloadData()
                },
                onError: { error in
                    print("error: \(error)")
                }
            ).disposed(by: disposeBag)
    }
}

extension ItemSearchView: SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        let selectedItem = items[index]
        let detailVC = DetailViewController(item: selectedItem)
        detailVC.hidesBottomBarWhenPushed = true

        if let viewController = self.next as? UIViewController {
            viewController.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        switch direction {
        case .right: break
        case .left: break
        case .up:
            self.window?.rootViewController?.present(PocketSelectionViewController(selectedItems: [items[index]]),
                                                     animated: true)
  
        default: print("Undefined swipe action")
        }
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
        
    }
    
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        itemCardsView.removeFromSuperview()
        dimLayer.removeFromSuperlayer()
    }
    
}

extension ItemSearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        itemSearchViewModel.setQuery(to: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemSearchViewModel.search()
        layer.addSublayer(dimLayer)
        addSubview(itemCardsView)
        itemCardsView.frame = self.frame
        itemCardsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }
    
    @objc func onTap() {
        print("ItemCardsView Tapped")
        itemCardsView.removeFromSuperview()
        dimLayer.removeFromSuperlayer()
    }
}

extension ItemSearchView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.id,
                                                            for: indexPath)
                as? ItemCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setCell(with: items[indexPath.item])
        
        return cell
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.item]
        let detailVC = DetailViewController(item: selectedItem)
        detailVC.hidesBottomBarWhenPushed = true

        if let viewController = self.next as? UIViewController {
            viewController.navigationController?.pushViewController(detailVC, animated: true)
        }
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
