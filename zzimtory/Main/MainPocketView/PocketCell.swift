//
//  PocketCell.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/27/25.
//
//

import Foundation
import UIKit
import SnapKit

class PocketCell: UICollectionViewCell {
    
    private let previewImageView1 = UIImageView()
    private let previewImageView2 = UIImageView()
    private let previewImageView3 = UIImageView()
    private let previewImageView4 = UIImageView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        
        let leftImageStackView = UIStackView(arrangedSubviews: [previewImageView1, previewImageView3])
        leftImageStackView.axis = .horizontal
        leftImageStackView.spacing = 0
        leftImageStackView.alignment = .fill
        leftImageStackView.distribution = .fillEqually
        
        let rightImageStackView = UIStackView(arrangedSubviews: [previewImageView2, previewImageView4])
        rightImageStackView.axis = .horizontal
        rightImageStackView.spacing = 0
        rightImageStackView.alignment = .fill
        rightImageStackView.distribution = .fillEqually
        
        let imageStackView = UIStackView(arrangedSubviews: [leftImageStackView, rightImageStackView])
        imageStackView.axis = .vertical
        imageStackView.spacing = 0
        imageStackView.alignment = .fill
        imageStackView.distribution = .fillEqually
        imageStackView.layer.cornerRadius = 15
        imageStackView.layer.masksToBounds = true
        
        let titleImageStackView = UIStackView(arrangedSubviews: [imageStackView, titleLabel])
        titleImageStackView.axis = .vertical
        titleImageStackView.spacing = 8
        titleImageStackView.alignment = .fill
        titleImageStackView.distribution = .fill
        
        
        contentView.addSubview(titleImageStackView)
        contentView.addSubview(countLabel)
        
        titleImageStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().inset(-5)
            make.leading.equalToSuperview().inset(5)
            make.height.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(-40)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(contentView).multipliedBy(0.9) // 이걸 추가해야만 전체보기가 안짤림
        }
  
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.trailing.equalTo(contentView).inset(12)
        }
        
        setupImageViews()
    }
    
    private func setupImageViews() {
        [previewImageView1, previewImageView2, previewImageView3, previewImageView4].forEach {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.isHidden = true
        }
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black900Zt
        
        countLabel.font = .systemFont(ofSize: 15, weight: .medium)
        countLabel.textColor = .black900Zt
        countLabel.backgroundColor = .white100Zt
        countLabel.textAlignment = .center
        countLabel.layer.cornerRadius = 6
        countLabel.layer.masksToBounds = true
    }
    
    func configure(with title: String, images: [UIImage]) {
        titleLabel.text = title
        countLabel.text = "\(images.count)개" // 추후 주머니 속 개수로 수정 예정!!
        countLabel.isHidden = images.isEmpty
        
        let previews = [previewImageView1, previewImageView2, previewImageView3, previewImageView4]
        
        for (index, imageView) in previews.enumerated() {
            if index < images.count {
                imageView.image = images[index]
                imageView.isHidden = false
            } else {
                imageView.isHidden = true
            }
        }
    }
}
@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
