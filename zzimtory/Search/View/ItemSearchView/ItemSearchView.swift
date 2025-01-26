//
//  ItemSearchView.swift
//  zzimtory
//
//  Created by 김하민 on 1/24/25.
//

import UIKit

final class ItemSearchView: ZTView {
    
    private let itemCollectionView: ItemCollectionView = .init()
    let items = DummyModel.items
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setColletionView()
        setConstraints()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions for binding/datasource
    private func setColletionView() {
        itemCollectionView.register(ItemCollectionViewCell.self,
                                    forCellWithReuseIdentifier: ItemCollectionViewCell.id)
        itemCollectionView.dataSource = self
        itemCollectionView.delegate = self
        itemCollectionView.isScrollEnabled = true
        
        addSubview(itemCollectionView)
    }
    
    private func setConstraints() {
        itemCollectionView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(300)
        }
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
