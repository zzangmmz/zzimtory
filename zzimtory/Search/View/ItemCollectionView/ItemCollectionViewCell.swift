//
//  ItemCollectionViewCell.swift
//  zzimtory
//
//  Created by 김하민 on 1/24/25.
//

import UIKit
import SnapKit
import Kingfisher

final class ItemCollectionViewCell: UICollectionViewCell {
    
    static let id = "ItemCollectionViewCell"
    
    // MARK: - Cell components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black900Zt
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .black900Zt
        
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI functions
    func setCell(with item: Item) {
        priceLabel.text = item.price
        titleLabel.text = item.title
        imageView.kf.setImage(with: URL(string: item.image))
    }
    
    private func setUI() {
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = .white100Zt
        
        [imageView,
         priceLabel,
         titleLabel].forEach {
            contentView.addSubview($0)
        }
        
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(imageView.snp.width)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(imageView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(imageView)
            make.bottom.equalToSuperview().inset(12)
        }
        
    }
    
}
