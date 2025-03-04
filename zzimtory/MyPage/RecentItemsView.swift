//
//  RecentItemsView.swift
//  zzimtory
//
//  Created by 이명지 on 2/14/25.
//

import UIKit
import SnapKit

final class RecentItemsView: UIView {
    private(set) var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 본 상품"
        label.textColor = .black900Zt
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(RecentItemCell.self, forCellWithReuseIdentifier: String(describing: RecentItemCell.self))
        return collectionView
    }()
    
    private(set) var placeHolder: UILabel = {
        let label = UILabel()
        label.text = "최근 본 상품이 없습니다."
        label.textColor = .gray300Zt
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 15
        self.backgroundColor = .white100Zt
        
        [
            titleLabel,
            collectionView,
            placeHolder
        ].forEach { self.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        placeHolder.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func showPlaceHolderLabel() {
        self.placeHolder.isHidden = false
        self.collectionView.isHidden = true
    }
    
    func hidePlaceHolderLabel() {
        self.placeHolder.isHidden = true
        self.collectionView.isHidden = false
    }
}
