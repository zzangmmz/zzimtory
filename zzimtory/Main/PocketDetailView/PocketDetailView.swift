//
//  PocketDetailView.swift
//  zzimtory
//
//  Created by t2023-m0072 on 2/2/25.
//

import UIKit
import SnapKit

class PocketDetailView: ZTView {
    
    var titleLabel: UILabel!
    var countLabel: UILabel!
    var itemCollectionView: ItemCollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black900Zt
        addSubview(titleLabel)
        
        countLabel = UILabel()
        countLabel.font = .systemFont(ofSize: 16)
        countLabel.textColor = .black900Zt
        addSubview(countLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
        }
        
        itemCollectionView = ItemCollectionView()
        addSubview(itemCollectionView)
        
        itemCollectionView.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 64) / 2, height: 200) // 두 개씩 배치

        itemCollectionView.collectionViewLayout = layout
    }
    
    func configure(with title: String, itemCount: Int) {
        titleLabel.text = title
        countLabel.text = "\(itemCount)개"
    }
    
    func configureCollectionView(items: [Item]) {
        itemCollectionView.reloadData() // ItemCollectionView 데이터 업데이트
    }
}
