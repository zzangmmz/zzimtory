//
//  PocketDetailView.swift
//  zzimtory
//
//  Created by t2023-m0072 on 2/2/25.
//

import UIKit
import SnapKit

// PocketDetailView.swift
class PocketDetailView: ZTView {
  var titleLabel = UILabel()
  var countLabel = UILabel()
  var itemCollectionView = ItemCollectionView()
  
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
  
  // 서치바
  var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "상품명을 입력하세요"
    searchBar.isHidden = true
    searchBar.backgroundColor = .clear
    searchBar.searchBarStyle = .minimal
    return searchBar
  }()
  
  // 취소 버튼
  var cancelButton: UIButton = {
    let button = UIButton()
    button.setTitle("취소", for: .normal)
    button.setTitleColor(.blue, for: .normal)
    button.layer.cornerRadius = 8
    button.isHidden = true
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
    titleLabel.textColor = .black900Zt
    
    countLabel.font = .systemFont(ofSize: 16)
    countLabel.textColor = .black900Zt
    
    // titleLabel 추가
    addSubview(titleLabel)
    
    // countLabel과 버튼들을 묶은 stackView 추가
    addSubview(countAndButtonStackView)
  
    addSubview(searchBar)
    addSubview(cancelButton)
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide).offset(20)
      make.leading.equalToSuperview().inset(16)
    }
    
    countAndButtonStackView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().inset(16)
    }
    
    searchBar.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(8)
      make.top.bottom.equalTo(countAndButtonStackView)
      make.trailing.equalTo(cancelButton.snp.leading).inset(8)
      
    }
    
    cancelButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(8)
      make.top.bottom.equalTo(searchBar)
      make.width.equalTo(50)
    }
    
    addSubview(itemCollectionView)
    
    itemCollectionView.snp.makeConstraints { make in
      make.top.equalTo(countAndButtonStackView.snp.bottom).offset(20)
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
      make.size.equalTo(40) // 크기 조정
    }
    
    sortButton.snp.makeConstraints { make in
      make.size.equalTo(40) // 크기 조정
    }
    
    deleteButton.snp.makeConstraints { make in
      make.size.equalTo(40) // 크기 조정
    }
    
    cancelButton.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
    searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
  }
  
  func configure(with title: String, itemCount: Int) {
    titleLabel.text = title
    countLabel.text = "씨앗 \(itemCount)개"
  }
  
  func configureCollectionView(items: [Item]) {
    itemCollectionView.reloadData() // ItemCollectionView 데이터 업데이트
  }
  
  // 서치버튼 클릭 시 서치바가 보이고, 카운트앤버튼스택뷰 숨기기
  @objc private func searchButtonDidTap() {
    setHidden()
  }
  
  // 취소 버튼 클릭 시 서치바를 숨기고, 카운트앤버튼스택뷰 다시 보이게
  @objc private func cancelSearch() {
    searchBar.text = nil  // 서치바 초기화
    setHidden()
  }
  
  private func setHidden() {
    [searchBar, cancelButton, countAndButtonStackView]
      .forEach {
        $0.isHidden.toggle()
      }
  }
}
