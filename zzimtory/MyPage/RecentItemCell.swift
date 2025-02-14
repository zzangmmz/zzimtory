//
//  RecentItemCell.swift
//  zzimtory
//
//  Created by 이명지 on 2/14/25.
//

import UIKit
import SnapKit
import Kingfisher

final class RecentItemCell: UICollectionViewCell {
    private let itemImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(itemImage)
        
        itemImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with item: Item) {
        guard let url = URL(string: item.image) else { return }
        self.itemImage.kf.setImage(with: url)
    }
}
