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

    var countLabel = UILabel()
    var itemCollectionView = ItemCollectionView()
    
    let overlayView: ZTView = {
        let view = ZTView()
        view.backgroundColor = UIColor.black900Zt.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()
    
    // 버튼들
    let seedDeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("씨앗 삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.tintColor = .red
        button.layer.cornerRadius = 16
        button.backgroundColor = .white100Zt
        button.isHidden = true
        return button
    }()
    
    let seedMoveButton: UIButton = {
        let button = UIButton()
        button.setTitle("주머니 이동", for: .normal)
        button.setTitleColor(.black900Zt, for: .normal)
        button.backgroundColor = .white100Zt
        button.layer.cornerRadius = 16
        button.isHidden = true
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
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black900Zt
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
        stackView.spacing = 8
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
    
    private lazy var moveStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [seedDeleteButton, seedMoveButton])
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // 서치바
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "상품명을 입력하세요"
        searchBar.searchBarStyle = .default
        searchBar.layer.cornerRadius = 14
        searchBar.isHidden = true
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .white100Zt
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white100Zt
            textField.tintColor = .black900Zt
        }
        return searchBar
    }()
    
    
    // 취소 버튼
    var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.black900Zt, for: .normal)
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    
    private let emptyPocketLabel: UILabel = {
        let label = UILabel()
        label.text = "주머니가 비어있습니다."
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .gray500Zt
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        countLabel.font = .systemFont(ofSize: 16)
        countLabel.textColor = .black900Zt

        // countLabel과 버튼들을 묶은 stackView 추가
        addSubview(countAndButtonStackView)
        addSubview(searchBar)
        addSubview(cancelButton)
       
        addSubview(overlayView)
        addSubview(itemCollectionView)
        addSubview(moveStackView)
        addSubview(moveCancelButton)
        
        // 주머니 비었을 때 플레이스 홀더 추가
        addSubview(emptyPocketLabel)

        countAndButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        moveStackView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(240)

        }
        
        moveCancelButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().inset(24)
        }
       
        searchBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(countAndButtonStackView)
            make.height.equalTo(44)
            make.trailing.equalTo(cancelButton.snp.leading).offset(-4)
            
        }
        
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalTo(searchBar)
            make.width.equalTo(50)
        }
        
        itemCollectionView.snp.makeConstraints { make in
            make.top.equalTo(countAndButtonStackView.snp.bottom).offset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        overlayView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()  // 배경을 화면 전체로 채움
        }
        
        // 버튼 사이즈 조정
        seedMoveButton.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        seedDeleteButton.snp.makeConstraints { make in
            make.size.equalTo(50)
        }
        
        moveCancelButton.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        
        searchButton.snp.makeConstraints { make in
            make.size.equalTo(40) // 크기 조정
        }
        
        sortButton.snp.makeConstraints { make in
            make.size.equalTo(40) // 크기 조정
        }
        
        deleteButton.snp.makeConstraints { make in
            make.size.equalTo(40) // 크기 조정
        }
        
        emptyPocketLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        cancelButton.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector (deleteButtonDidTap), for: .touchUpInside)
        moveCancelButton.addTarget(self, action: #selector(moveCancelButtonDidTap), for: .touchUpInside)
    }
    
    func configure(with pocket: Pocket) {
        countLabel.text = "씨앗 \(pocket.items.count)개"
        
        if pocket.items.isEmpty {
            itemCollectionView.isHidden = true
            emptyPocketLabel.isHidden = false
        } else {
            itemCollectionView.isHidden = false
            emptyPocketLabel.isHidden = true
        }
    }
    
    func configureCollectionView(items: [Item]) {
        itemCollectionView.reloadData() // ItemCollectionView 데이터 업데이트
    }
    
    private func toggleButtonHidden() {
        [seedDeleteButton,
         seedMoveButton,
         moveCancelButton,
         overlayView].forEach { $0.isHidden.toggle() }
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
    
    @objc private func deleteButtonDidTap() {
        toggleButtonHidden()
    }
    
    @objc private func moveCancelButtonDidTap() {
        toggleButtonHidden()
    }

    // 주머니 이동 버튼 클릭 시 추후 추가 예정!!
    @objc private func moveButtonDidTap() {
        print("주머니 이동이 클릭됨")
    }
    
    private func setHidden() {
        [searchBar, cancelButton, countAndButtonStackView]
            .forEach {
                $0.isHidden.toggle()
            }
    }
}
