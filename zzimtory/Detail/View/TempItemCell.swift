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
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black900Zt
        return label
    }()
    
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .black900Zt
        label.numberOfLines = 2
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
    
    func configureWithDummyData(with item: Item) {
        // HTML 태그 제거
        let cleanTitle = item.title.removingHTMLTags
        itemNameLabel.text = cleanTitle
        
        // 가격 포맷팅
        if let price = Int(item.price) {
            priceLabel.text = "\(price.withSeparator)원"
        }
        
        // 이미지 URL로 이미지 로드
        if let imageUrl = URL(string: item.image) {
            itemImageView.loadImage(from: imageUrl)
        }
    }
}
