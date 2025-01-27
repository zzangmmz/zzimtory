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
    
    private let searchBar: UISearchBar = .init()
    private let itemCollectionView: ItemCollectionView = .init()
    private let itemSearchViewModel: ItemSearchViewModel = .init()
    private let disposeBag: DisposeBag = .init()
    
    var items: [Item] = []
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSearchBar()
        setColletionView()
        setConstraints()
        
        bind(to: itemSearchViewModel)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions for binding/datasource
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

extension ItemSearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        itemSearchViewModel.setQuery(to: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemSearchViewModel.search()
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

        return CGSize(width: cellWidth, height: 200)
    }
}
