//
//  MainView.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/24/25.
//

import UIKit
import SnapKit

class MainView: ZTView {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black900Zt
        return imageView
    }()
    
    let pocketDeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("주머니 삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.tintColor = .red
        button.layer.cornerRadius = 16
        button.backgroundColor = .white100Zt
        button.isHidden = true
        return button
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "찜토리"
        label.textColor = .black900Zt
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let overlayView: ZTView = {
        let view = ZTView()
        view.backgroundColor = UIColor.black900Zt.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()
    
    let addPocketButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(named: "PocketIcon")!
        config.baseBackgroundColor = .white100Zt
        config.baseForegroundColor = .black900Zt
        config.imagePadding = 6
        config.cornerStyle = .large
        config.attributedTitle = AttributedString("주머니 추가",
                                                  attributes: AttributeContainer([
                                                    .font: UIFont.systemFont(ofSize: 14, weight: .regular)
                                                  ]))
        button.configuration = config
        return button
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search.."
        searchBar.searchBarStyle = .default
        searchBar.layer.cornerRadius = 14
        
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .white100Zt
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white100Zt
            textField.tintColor = .black900Zt
        }
        
        return searchBar
    }()
    
    let pocketCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black900Zt
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = .black900Zt
        button.layer.cornerRadius = 20
        button.backgroundColor = .white100Zt
        return button
    }()
    
    let moveCancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black900Zt, for: .normal)
        button.backgroundColor = .gray200Zt
        button.layer.cornerRadius = 20
        button.isHidden = true
        return button
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .black900Zt
        button.isHidden = false
        button.layer.cornerRadius = 20
        button.backgroundColor = .white100Zt
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 20
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(PocketCell.self, forCellWithReuseIdentifier: "PocketCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupSearchBarTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let logoStackView = UIStackView(arrangedSubviews: [logoImageView, logoLabel])
        logoStackView.axis = .horizontal
        logoStackView.spacing = 10
        logoStackView.alignment = .center
        
        let topStackView = UIStackView(arrangedSubviews: [logoStackView, addPocketButton])
        topStackView.axis = .horizontal
        topStackView.spacing = 16
        topStackView.alignment = .center
        topStackView.distribution = .equalSpacing
        
        let actionStackView = UIStackView(arrangedSubviews: [sortButton, editButton])
        actionStackView.axis = .horizontal
        actionStackView.spacing = 16
        actionStackView.alignment = .center
        
        let pocKetCountStackView = UIStackView(arrangedSubviews: [pocketCountLabel, actionStackView])
        pocKetCountStackView.axis = .horizontal
        pocKetCountStackView.spacing = 8
        pocKetCountStackView.alignment = .center
        pocKetCountStackView.distribution = .equalSpacing
        
        let mainStackView = UIStackView(arrangedSubviews: [topStackView,
                                                           searchBar, pocKetCountStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        
        addSubview(mainStackView)
        addSubview(overlayView)
        addSubview(collectionView)
        addSubview(moveCancelButton)
        addSubview(pocketDeleteButton)
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
           
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        moveCancelButton.snp.makeConstraints { make in
            make.top.equalTo(editButton)
                make.trailing.equalToSuperview().inset(24)
        }
        
        sortButton.snp.makeConstraints { make in
            make.width.height.equalTo(40) // 크기 조정
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(40) // 크기 조정
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(logoStackView.snp.bottom).inset(16)
            make.height.equalTo(44)
        }
        
        searchBar.searchTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(6)
        }
        
        collectionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        pocketDeleteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(32)
            make.height.equalTo(50)
            make.width.equalTo(120)
        }
        moveCancelButton.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
    }
    
    // 외부 탭 하면 키보드 사라지게 함
    private func setupSearchBarTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    func toggleButtonHidden() {
        [moveCancelButton, pocketDeleteButton,
         overlayView].forEach { $0.isHidden.toggle() }
    }
    
    @objc private func handleTap() {
        searchBar.resignFirstResponder()
    }
}

extension MainView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 터치된 뷰가 컬렉션뷰나 버튼이면 제스처를 무시
        if touch.view?.isDescendant(of: collectionView) == true {
            return false
        }
        return true
    }
}
