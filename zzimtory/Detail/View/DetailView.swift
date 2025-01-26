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
    //    private let backButton: UIButton = {
    //        let button = UIButton()
    //        button.backgroundColor = .systemBackground.withAlphaComponent(0.8)
    //        button.layer.cornerRadius = 20
    //
    //        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium)
    //        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
    //        button.tintColor = .black
    //
    //        button.layer.shadowColor = UIColor.black.cgColor
    //        button.layer.shadowOffset = CGSize(width: 0, height: 2)
    //        button.layer.shadowRadius = 4
    //        button.layer.shadowOpacity = 0.2
    //
    //        return button
    //    }()
    
    // 상품 이미지
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "DummyImage")
        return imageView
    }()
    
    // 브랜드버튼
    private let brandButton: UIButton = {
        let button = UIButton()
        button.setTitle("브랜드명 >", for: .normal)
        button.setTitleColor(.black900Zt, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.contentHorizontalAlignment = .left
        
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
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
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
        
        // 이미지 설정
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "safari", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .black900Zt
        
        // 이미지와 텍스트 간격 설정
        button.imageEdgeInsets = .init(top: 0, left: -8, bottom: 0, right: 0)
        button.titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        
        return button
    }()
    
    // 저장 버튼
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("주머니에 넣기", for: .normal)
        button.backgroundColor = UIColor(named: "blue400ztPrimary") // 왜 얘만 적용이 안되는 것인지..
        button.layer.cornerRadius = 10
        button.setTitleColor(.black900Zt, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        
        // 이미지 설정
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "tray.fill", withConfiguration: config)
        //let image = UIImage(named: "PocketBlack", in: Bundle.main, with: config)
        button.setImage(image, for: .normal)
        button.tintColor = .black900Zt
        
        // 이미지와 텍스트 간격 설정
        button.imageEdgeInsets = .init(top: 0, left: -8, bottom: 0, right: 0)
        button.titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        
        return button
    }()
    
    // 구분선
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200Zt
        return view
    }()
    
    // 유사 상품 Label
    private let similarItemLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "유사한 상품"
        return label
    }()
    
    // 유사한 제품
    private let similarItemCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 190)
        layout.minimumLineSpacing = 10
        // layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
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
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var topStackView = {
        let stackView = UIStackView(arrangedSubviews: [/*backButton,*/ itemImageView, brandStackView, itemNameLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var bottomStackView = {
        let stackView = UIStackView(arrangedSubviews: [buttonStackView, lineView, similarItemLabel, similarItemCollectionView])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    // 스크롤뷰 추가
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        similarItemCollectionView.delegate = self
        similarItemCollectionView.dataSource = self
        similarItemCollectionView.register(TempItemCell.self, forCellWithReuseIdentifier: "tempItemCell")
    }
    
    private func configureUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topStackView)
        contentView.addSubview(bottomStackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        topStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        //        backButton.snp.makeConstraints { make in
        //            make.width.height.equalTo(40)
        //            make.leading.equalToSuperview().offset(16)
        //        }
        
        itemImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        
        shareButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        brandStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        itemNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        websiteButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        similarItemLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        similarItemCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(190)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tempItemCell", for: indexPath) as? TempItemCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}
