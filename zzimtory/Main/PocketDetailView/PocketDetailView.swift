//
//  PocketDetailView.swift
//  zzimtory
//
//  Created by t2023-m0072 on 2/2/25.
//

import UIKit
import SnapKit

class PocketDetailView: ZTView {
    
    var titleLabel: UILabel!
    var countLabel: UILabel!
    var itemCollectionView: ItemCollectionView!
    
    // 버튼들
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 20
        button.backgroundColor = .white100Zt
        return button
    }()
    
    let sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = .black900Zt
        button.layer.cornerRadius = 20
        button.backgroundColor = .white100Zt
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .black900Zt
        button.layer.cornerRadius = 20
        button.backgroundColor = .white100Zt
        return button
    }()
    
    // 버튼들을 묶은 stackView
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchButton, sortButton, deleteButton])
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // countLabel과 buttonStackView를 묶은 stackView
    private lazy var countAndButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countLabel, buttonStackView])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    // titleLabel과 countAndButtonStackView를 묶은 수직 StackView
    private lazy var titleAndCountStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, countAndButtonStackView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black900Zt
        
        countLabel = UILabel()
        countLabel.font = .systemFont(ofSize: 16)
        countLabel.textColor = .black900Zt
        
        // titleAndCountStackView 추가
        addSubview(titleAndCountStackView)
        
        titleAndCountStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        itemCollectionView = ItemCollectionView()
        addSubview(itemCollectionView)
        
        itemCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleAndCountStackView.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 64) / 2, height: 200) // 두 개씩 배치
        
        itemCollectionView.collectionViewLayout = layout
        
        // 버튼 사이즈 조정
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(40) // 크기 조정
        }
        
        sortButton.snp.makeConstraints { make in
            make.width.height.equalTo(40) // 크기 조정
        }
        
        deleteButton.snp.makeConstraints { make in
            make.width.height.equalTo(40) // 크기 조정
        }
    }
    
    func configure(with title: String, itemCount: Int) {
        titleLabel.text = title
        countLabel.text = "씨앗 \(itemCount)개"
    }
    
    func configureCollectionView(items: [Item]) {
        itemCollectionView.reloadData() // ItemCollectionView 데이터 업데이트
    }
}
