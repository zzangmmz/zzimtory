//
//  DetailView.swift
//  zzimtory
//
//  Created by seohuibaek on 1/24/25.
//

import UIKit
import SnapKit
// import RxSwift
// import RxCocoa

final class DetailView: ZTView {
    // private let disposeBag = DisposeBag()
    // let item = DetailDummyItems.dummyItems[3] // 임시 데이터
    
    // 유사 상품 데이터 저장 배열
    var similarItems: [Item] = []
    
    // 상품 이미지
    let itemImageView = UIImageView()
    
    // 브랜드 버튼
    let brandButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(.black900Zt, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .medium)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    // 상품명 레이블
    let itemNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.textAlignment = .left
        
        return label
    }()
    
    // 가격 레이블
    let priceLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        
        return label
    }()
    
    // 공유 버튼
    let shareButton: UIButton = {
        let button = UIButton()

        button.setAsIconButton()
        button.setButtonDefaultImage(imageName: "square.and.arrow.up")
        
        return button
    }()
    
    // 웹사이트 이동 버튼
    let websiteButton: UIButton = {
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
    let saveButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("주머니에 넣기", for: .normal)
        button.backgroundColor = .blue400ZtPrimary
        button.layer.cornerRadius = 10
        
        button.setTitleColor(.black900Zt, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        
        // 추후 적용을 위해 주석처리
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
    
    // 유사 상품 레이블
    private let similarItemLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "유사한 상품"
        
        return label
    }()
    
    // 유사한 제품 컬렉션 뷰
    let similarItemCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 190)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.id)
        
        return collectionView
    }()
    
    // 브랜드 버튼과 공유 버튼
    private lazy var brandStackView = {
        let stackView = UIStackView(arrangedSubviews: [brandButton, shareButton])
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    // 웹사이트 버튼과 주머니 넣기 버튼
    private lazy var buttonStackView = {
        let stackView = UIStackView(arrangedSubviews: [websiteButton, saveButton])
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    // [상단 스택: 상품 정보] 아이템 이미지, 브랜드 버튼 및 공유 버튼 스택, 상품 이름 레이블, 가격 레이블
    private lazy var topStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemImageView,
                                                       brandStackView,
                                                       itemNameLabel,
                                                       priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    // [하단 스택] 웹사이트 버튼 및 주머니 넣기 버튼 스택, 구분선, 유사상품 레이블, 유사 상품 컬렌션 뷰
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
    
    // 메인 스택 = [상단 스택] + [하단 스택]
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
        // configureWithDummyData()
        // bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        setupScrollView()
        setupTopStackView()
        setupBottomStackView()
        // setupCollectionView()
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
    
    // [상단 스택: 상품 정보] 아이템 이미지, 브랜드 버튼 및 공유 버튼 스택, 상품 이름 레이블, 가격 레이블
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
    
    // [하단 스택] 웹사이트 버튼 및 주머니 넣기 버튼 스택, 구분선, 유사상품 레이블, 유사 상품 컬렌션 뷰
    private func setupBottomStackView() {
        bottomStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        // 화면 내의 비율로 버튼 설정
        [websiteButton, saveButton].forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
        }
        
        // 양옆 오프셋 20 , 중간 12 --> 이래도 안되는지 확인
        websiteButton.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.4)
        }
        
        saveButton.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.6)
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
    
//    private func setupCollectionView() {
//        similarItemCollectionView.delegate = self
//        similarItemCollectionView.dataSource = self
//        similarItemCollectionView.register(TempItemCell.self, forCellWithReuseIdentifier: TempItemCell.id)
//    }
}

//extension DetailView {
//    func updateSimilarItems(_ items: [Item]) {
//        self.similarItems = items
//        similarItemCollectionView.reloadData()
//    }
//}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
//extension DetailView: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return similarItems.count
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        cellForItemAt indexPath: IndexPath
//    ) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: TempItemCell.id,
//            for: indexPath) as? TempItemCell else {
//            return UICollectionViewCell()
//        }
//        
//        let item = similarItems[indexPath.item]
//        cell.configureData(with: item)
//        return cell
//    }
//}

// 추후 삭제 예정
//extension DetailView {
//    private func configureWithDummyData() {
//        let item = DetailDummyItems.dummyItems[3]
//        
//        // 상품 이름
//        let cleanTitle = item.title.removingHTMLTags
//        itemNameLabel.text = cleanTitle
//        
//        // 브랜드/쇼핑몰 이름 설정
//        let brandText = item.brand.isEmpty ? item.mallName : item.brand
//        brandButton.setTitle("\(brandText) >", for: .normal)
//        
//        // 가격 설정
//        if let price = Int(item.price) {
//            priceLabel.text = "\(price.withSeparator)원"
//        }
//        
//        // 이미지 URL로 이미지 로드
//        if let imageUrl = URL(string: item.image) {
//            itemImageView.loadImage(from: imageUrl)
//        }
//    }
//}

// bind view에서 제거 추후 삭제 예정
//extension DetailView {
//    //bind 임시 구현
//    private func bind() {
//        websiteButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                guard let self = self, let url = URL(string: self.item.link) else { return }
//                let webVC = ItemWebViewController(urlString: url.absoluteString)
//                
//                // 모달 전환
////                let navController = UINavigationController(rootViewController: webVC)
////                self.window?.rootViewController?.present(navController, animated: true)
//                
//                // 페이지 전환
//                if let navigationController = self.window?.rootViewController as? UINavigationController {
//                    navigationController.pushViewController(webVC, animated: true)
//                }
//            }).disposed(by: disposeBag)
//    }
//}
