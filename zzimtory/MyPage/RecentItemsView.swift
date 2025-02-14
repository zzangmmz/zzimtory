//
//  RecentItemsView.swift
//  zzimtory
//
//  Created by 이명지 on 2/14/25.
//

import UIKit
import SnapKit

final class RecentItemsView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 본 상품"
        label.textColor = .black900Zt
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white100Zt
        
        collectionView.register(RecentItemCell.self, forCellWithReuseIdentifier: String(describing: RecentItemCell.self))
        return collectionView
    }()
    
    private let placeHolder: UILabel = {
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
            $0.top.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        placeHolder.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func togglePlaceHolder(with noItems: Bool) {
        self.placeHolder.isHidden = !noItems
        self.collectionView.isHidden = noItems
    }
}
