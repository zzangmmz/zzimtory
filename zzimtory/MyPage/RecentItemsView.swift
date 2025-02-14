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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, collectionView])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
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
        
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
}
