//
//  ItemCardContents.swift
//  zzimtory
//
//  Created by 김하민 on 1/27/25.
//

import UIKit
import SnapKit
import Kingfisher

final class ItemCardContents: UIView {
    
    let item: Item
    
    // MARK: - UI components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.kf.setImage(with: URL(string: item.image))
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        
        label.text = Int(item.price)?.formattedWithSeparator
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black900Zt
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = item.title.removingHTMLTags
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black900Zt
        
        return label
    }()
    
    // MARK: - Initializers
    init(item: Item) {
        self.item = item
        super.init(frame: .zero)
        
        backgroundColor = .white100Zt
        
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    private func setSubviews() {
        [imageView, priceLabel, titleLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(imageView.snp.horizontalEdges).inset(12)
            make.bottom.equalTo(titleLabel.snp.top).offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(imageView.snp.horizontalEdges).inset(12)
            make.bottom.equalTo(imageView.snp.bottom).inset(12)
        }
    }
}
