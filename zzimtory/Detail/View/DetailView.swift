//
//  DetailView.swift
//  zzimtory
//
//  Created by seohuibaek on 1/24/25.
//

import UIKit
import SnapKit

final class DetailView: ZTView {
    
    // 뒤로가기 버튼
    private let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        button.layer.cornerRadius = 20
        
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = .black
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        
        return button
    }()
    
    // 상품 이미지
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DummyImage")
        return imageView
    }()
    
    // 브랜드
    private let brandButton: UIButton = {
        let button = UIButton()
        button.setTitle("브랜드명 >", for: .normal)
        button.setTitleColor(.black900Zt, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        return button
    }()
    
    // 상품명
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "상품명"
        return label
    }()
    
    // 가격
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "가격"
        return label
    }()
    
    // 공유 버튼
    private let shareButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        button.layer.cornerRadius = 20
        
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
        button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: config), for: .normal)
        button.tintColor = .black
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        
        return button
    }()
    
    // 웹사이트 이동 버튼
    private let websiteButton: UIButton = {
        let button = UIButton()
        button.setTitle("웹사이트 이동", for: .normal)
        button.backgroundColor = .white100Zt
        button.layer.cornerRadius = 10
        button.setTitleColor(.black900Zt, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    // 저장 버튼
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("주머니에 넣기", for: .normal)
        button.backgroundColor = .white100Zt
        button.layer.cornerRadius = 10
        button.setTitleColor(.black900Zt, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    // 구분선
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    // 유사한 제품
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private lazy var brandStackView = {
        let stackView = UIStackView(arrangedSubviews: [brandButton, shareButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var buttonStackView = {
        let stackView = UIStackView(arrangedSubviews: [websiteButton, saveButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var topStackView = {
        let stackView = UIStackView(arrangedSubviews: [backButton, itemImageView, brandStackView, itemNameLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var bottomStackView = {
        let stackView = UIStackView(arrangedSubviews: [buttonStackView, lineView, collectionView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(topStackView)
        addSubview(bottomStackView)
        
        topStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview().offset(16)
        }
        
        itemImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
