//
//  MainView.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/24/25.
//

import Foundation
import UIKit
import SnapKit

class MainView: UIView {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "figure.child") // 추후 변경 예정
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "zzimtory"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let addPocketButton: UIButton = {
        let button = UIButton()
        let zzimtoryimage = UIImage(systemName: "figure.child")!
        button.setImage(zzimtoryimage, for: .normal)
        button.backgroundColor = .white100Zt
        button.setTitle(" 주머니 추가", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        return button
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search.."
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.backgroundColor = .white
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(addPocketButton)
        addSubview(searchBar)
        addSubview(logoImageView)
        addSubview(logoLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(50)
            make.height.equalTo(44)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.leading.equalTo(logoImageView.snp.trailing).offset(8)
        }
        
        addPocketButton.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView)
            make.trailing.equalToSuperview().offset(-16)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
