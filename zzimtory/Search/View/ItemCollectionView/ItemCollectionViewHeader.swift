//
//  ItemCollectionViewHeader.swift
//  zzimtory
//
//  Created by 김하민 on 2/5/25.
//

import UIKit
import SnapKit

final class ItemCollectionViewHeader: UICollectionReusableView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 16)
        label.text = "검색 결과"
        label.textColor = .black900Zt
        
        return label
    }()
    
    private(set) var cardButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "square.stack.3d.down.right.fill")
        config.baseForegroundColor = .black900Zt
        config.baseBackgroundColor = .white100Zt
        config.cornerStyle = .large
        button.configuration = config
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubviews() {
        [
            titleLabel,
            cardButton
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
        }
    }
}
