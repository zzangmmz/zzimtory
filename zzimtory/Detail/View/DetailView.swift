//
//  DetailView.swift
//  zzimtory
//
//  Created by seohuibaek on 1/24/25.
//

import UIKit
import SnapKit

final class DetailView: ZTView {
    
    // 상품 이미지
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "DummyImage")
        
        return imageView
    }()
    
    // 브랜드 버튼
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
        
        button.setButtonDefaultImage(imageName: "square.and.arrow.up")
        button.setButtonDefaultShadow()
        
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
        
        button.setButtonDefaultImage(imageName: "safari")
        button.setImageWithSpacing()
        button.setButtonDefaultShadow()
        
        return button
    }()
    
    // 저장 버튼
    private let saveButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("주머니에 넣기", for: .normal)
        button.backgroundColor = .blue400ZtPrimary
        button.layer.cornerRadius = 10
        
        button.setTitleColor(.black900Zt, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        
        // let image = UIImage(named: "PocketBlack", in: Bundle.main, with: config)
        
        button.setButtonDefaultImage(imageName: "tray.fill")
        button.setImageWithSpacing()
        button.setButtonDefaultShadow()
        
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
        let stackView = UIStackView(arrangedSubviews: [/*backButton,*/ itemImageView,
                                                                       brandStackView,
                                                                       itemNameLabel,
                                                                       priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var bottomStackView = {
        let stackView = UIStackView(arrangedSubviews: [buttonStackView,
                                                       lineView,
                                                       similarItemLabel,
                                                       similarItemCollectionView])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView,
                                                       bottomStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    // 스크롤뷰
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        setupScrollView()
        setupTopStackView()
        setupBottomStackView()
        setupCollectionView()
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
    }
    
    private func setupTopStackView() {
        topStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        itemImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        
        shareButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        [brandStackView, itemNameLabel, priceLabel].forEach { view in
            view.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
            }
        }
    }
    
    private func setupBottomStackView() {
        bottomStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        [websiteButton, saveButton].forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
        }
        
        [buttonStackView, lineView, similarItemLabel, similarItemCollectionView].forEach { view in
            view.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
            }
        }

        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }

        similarItemCollectionView.snp.makeConstraints { make in
            make.height.equalTo(190)
        }
    }
    
    private func setupCollectionView() {
        similarItemCollectionView.delegate = self
        similarItemCollectionView.dataSource = self
        similarItemCollectionView.register(TempItemCell.self, forCellWithReuseIdentifier: "tempItemCell")
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "tempItemCell",
            for: indexPath) as? TempItemCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}
