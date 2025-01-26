//
//  TempItemCell.swift
//  zzimtory
//
//  Created by seohuibaek on 1/25/25.
//

import UIKit
import SnapKit

final class TempItemCell: UICollectionViewCell {
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DummyImage")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black900Zt
        label.text = "200000원"
        return label
    }()
    
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .black900Zt
        label.numberOfLines = 2
        label.text = "초기염리락리락이신발"
        return label
    }()
    
    private lazy var itemStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemImageView, priceLabel, itemNameLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white100Zt
        layer.cornerRadius = 15

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(itemStackView)
        
        itemStackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        
        itemImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(130)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(14)
        }
        
        itemNameLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(14)
        }
    }
    
//    func configure(with item: Item) {
//        titleLabel.text = item.title
//        priceLabel.text = item.price
//    }
}
