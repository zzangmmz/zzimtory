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
//        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        
        addSubview(searchBar)
    }
    
    private func setColletionView() {
        itemCollectionView.register(ItemCollectionViewCell.self,
                                    forCellWithReuseIdentifier: ItemCollectionViewCell.id)
        itemCollectionView.dataSource = self
        itemCollectionView.delegate = self
        itemCollectionView.isScrollEnabled = true
        
        addSubview(itemCollectionView)
    }
    
    private func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        itemCollectionView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(searchBar.snp.bottom).offset(48)
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
                    self?.items.append(contentsOf: result)
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
        // 웹뷰로 넘겨주기?
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        switch direction {
        case .right: DummyModel.shared.defaultPocket.items.append(items[index])
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
        itemCardsView.bind(to: itemSearchViewModel)
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
    
}
