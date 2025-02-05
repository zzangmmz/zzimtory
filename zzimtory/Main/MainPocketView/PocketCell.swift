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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black900Zt
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        return label
    }()
    
    private let countLabelOnTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray500Zt
        label.textAlignment = .left
        label.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, countLabelOnTitle])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let countLabelOnImage: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black900Zt
        label.backgroundColor = .white100Zt
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        return label
    }()
    
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
        
        let titleImageStackView = UIStackView(arrangedSubviews: [imageStackView, titleStackView])
        titleImageStackView.axis = .vertical
        titleImageStackView.spacing = 10
        titleImageStackView.alignment = .fill
        titleImageStackView.distribution = .fillProportionally
        
        contentView.addSubview(titleImageStackView)
        contentView.addSubview(countLabelOnImage)
        
        titleImageStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(6)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.height.equalTo(contentView).multipliedBy(0.8)
        }
  
        countLabelOnImage.snp.makeConstraints { make in
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
    }
    
    func configure(with title: String, images: [String]) {
        titleLabel.text = title
        countLabelOnImage.text = "\(images.count)개" // 추후 주머니 속 개수로 수정 예정!!
        countLabelOnImage.isHidden = images.isEmpty
        countLabelOnTitle.text = "\(images.count)개"
        
        let previews = [previewImageView1, previewImageView2, previewImageView3, previewImageView4]
        
        for (index, imageView) in previews.enumerated() {
            if index < images.count {
                imageView.image = UIImage(named: images[index])
                imageView.isHidden = false
            } else {
                imageView.isHidden = true
            }
        }
    }
}
