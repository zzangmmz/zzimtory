//
//  MainView.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/24/25.
//

import UIKit
import SnapKit

class MainView: ZTView {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")!
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "찜토리"
        label.textColor = .black900Zt
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let addPocketButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(named: "PocketBlack")!
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
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = .systemBackground
        return searchBar
    }()
    
    let pocketCountLabel: UILabel = {
        let label = UILabel()
        label.text = "주머니 0개"
        label.textColor = .black900Zt
        label.font = .systemFont(ofSize: 16, weight: .bold)
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
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .black900Zt
        button.layer.cornerRadius = 20
        button.backgroundColor = .white100Zt
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 160, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(PocketCell.self, forCellWithReuseIdentifier: "PocketCell")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        let logoStackView = UIStackView(arrangedSubviews: [logoImageView, logoLabel])
        logoStackView.axis = .horizontal
        logoStackView.spacing = 8
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
                                                           searchBar, pocKetCountStackView, collectionView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        
        addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(10)
        }
      
        sortButton.snp.makeConstraints { make in
            make.width.height.equalTo(40) // 크기 조정
        }
        
        editButton.snp.makeConstraints { make in
            make.width.height.equalTo(40) // 크기 조정
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    MainViewController()
}
