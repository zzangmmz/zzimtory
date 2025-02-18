//
//  PocketDetailViewController.swift
//  zzimtory
//
//  Created by t2023-m0072 on 2/1/25.
//

import UIKit
class PocketDetailViewController: UIViewController,
                                  UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    private var pocketDetailView: PocketDetailView?
    private var viewModel: PocketDetailViewModel
    
    private var editMode: Bool = false {
        didSet {
            pocketDetailView?.itemCollectionView.visibleCells.forEach { cell in
                if let itemCell = cell as? ItemCollectionViewCell {
                    itemCell.setEditModeCell(with: editMode)
                }
            }
            
        }
    }
    
    // viewModel을 전달받는 생성자
    init(viewModel: PocketDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pocketDetailView = PocketDetailView(frame: view.frame)
        view = pocketDetailView
        
        setupNavigationBar()
        setupCollectionView()
        setupActions()
        pocketDetailView?.configure(with: viewModel.pocket)
        bind()
    }
    
    private func bind() {
        
        self.viewModel.fetchData { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.pocketDetailView?.configure(with: self.viewModel.pocket)
                self.pocketDetailView?.itemCollectionView.reloadData()
            }
        }
    }
    
    private func setupActions() {
        // 정렬 버튼
        pocketDetailView?.sortButton.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)
        pocketDetailView?.searchBar.delegate = self
        pocketDetailView?.cancelButton.addTarget(self, action: #selector(cancelSearch), for: .touchUpInside)
        pocketDetailView?.editButton.addTarget(self, action: #selector (editButtonDidTap), for: .touchUpInside)
        pocketDetailView?.moveCancelButton.addTarget(self
                                                     , action: #selector(moveCancelButtonDidTap), for: .touchUpInside)
        pocketDetailView?.seedDeleteButton.addTarget(self
                                                     , action: #selector(seedDeleteButtonDidTap), for: .touchUpInside)
        pocketDetailView?.seedMoveButton.addTarget(self
                                                   , action: #selector(seedMoveButtonDidTap), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        pocketDetailView?.itemCollectionView.delegate = self
        pocketDetailView?.itemCollectionView.dataSource = self
        pocketDetailView?.itemCollectionView.allowsMultipleSelection = true
        pocketDetailView?.itemCollectionView.register(ItemCollectionViewCell.self,
                                                      forCellWithReuseIdentifier: ItemCollectionViewCell.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.displayItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.id,
                                                            for: indexPath) as? ItemCollectionViewCell else {
            fatalError("Unable to dequeue ItemCollectionViewCell")
        }
        
        let item = viewModel.displayItems[indexPath.item]
        cell.setCell(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard editMode else {
            let selectedItem = viewModel.displayItems[indexPath.item]
            let detailVC = DetailViewController(item: selectedItem)
            detailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailVC, animated: true)
            return
        }
        
        // 편집모드인 경우
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell {
            selectedCell.cellOverlayView.isHidden = true
            selectedCell.isSelected = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard editMode else { return }
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? ItemCollectionViewCell {
            selectedCell.cellOverlayView.isHidden = false
            selectedCell.isSelected = false
        }
    }
    
    // 서치바 텍스트 변경 시 필터링된 결과를 업데이트
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.displayItems = viewModel.filteredItems // 원본 데이터로 복원
        } else {
            viewModel.displayItems = viewModel.filteredItems.filter { item in
                item.title.lowercased().contains(searchText.lowercased())
            }
        }
        pocketDetailView?.itemCollectionView.reloadData()
    }
    
    // 취소 버튼 클릭 시 서치바를 숨기고, 카운트앤버튼스택뷰 다시 보이게
    @objc func editButtonDidTap() {
        editMode.toggle()
        pocketDetailView?.toggleButtonHidden()
    }
    
    @objc func moveCancelButtonDidTap() {
        editMode.toggle()
        pocketDetailView?.toggleButtonHidden()
        pocketDetailView?.itemCollectionView.reloadData()
    }
    
    @objc func seedDeleteButtonDidTap() {
        guard let selectedIndexPaths = pocketDetailView?.itemCollectionView.indexPathsForSelectedItems else { return }
        
        let selectedItems = selectedIndexPaths.map { viewModel.displayItems[$0.item] }
        
        let alert = UIAlertController(title: "씨앗 삭제", message: "씨앗을 삭제하시겠습니까?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "네", style: .destructive) { _ in
            selectedItems.forEach { item in
                if self.viewModel.pocket.title == "전체보기" {
                    DatabaseManager.shared.deleteItem(productID: item.productID, from: self.viewModel.pocket.title)
                }else{
                    
                    DatabaseManager.shared.deleteItem(productID: item.productID, from: self.viewModel.pocket.title)
                    DatabaseManager.shared.deleteItem(productID: item.productID, from: "전체보기")
                }
            }
            
            self.bind()
            
            self.editMode = false
            self.pocketDetailView?.toggleButtonHidden()
        }
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func seedMoveButtonDidTap() {
        
        guard let selectedIndexPaths = pocketDetailView?.itemCollectionView.indexPathsForSelectedItems else { return }
        let selectedItems = selectedIndexPaths.map { viewModel.displayItems[$0.item] }
        
        // 주머니에 없으면 모달 띄우기
        let pocketVC = PocketSelectionViewController(selectedItems: selectedItems)
        self.present(pocketVC, animated: true)
        
        // 모달에서 주머니 추가 완료 시 ViewModel 업데이트
        pocketVC.onComplete = { [weak self] in
            guard let self = self else { return }
            selectedItems.forEach { item in
                if self.viewModel.pocket.title != "전체보기" {
                    DatabaseManager.shared.deleteItem(productID: item.productID, from: "전체보기")
                }
                DatabaseManager.shared.deleteItem(productID: item.productID, from: self.viewModel.pocket.title)
                
            }
            self.bind()
            editMode = false
            pocketDetailView?.toggleButtonHidden()
        }
    }
    
    @objc private func cancelSearch() {
        self.pocketDetailView?.searchBar.searchTextField.text = ""  // 서치바 초기화
        self.pocketDetailView?.setHidden()
        viewModel.displayItems = viewModel.pocket.items
        self.pocketDetailView?.itemCollectionView.reloadData()
    }
    
    @objc private func sortButtonDidTap() {
        let alert = UIAlertController(title: "상품명", message: "정렬 기준을 선택하세요.", preferredStyle: .actionSheet)
        
        let sortByDictionary = UIAlertAction(title: "가나다순", style: .default) { [weak self] _ in
            self?.viewModel.sortItems(by: .dictionary) { [weak self] in
                self?.pocketDetailView?.itemCollectionView.reloadData()
            }
        }
        
        let sortByNewest = UIAlertAction(title: "최신순", style: .default) { [weak self] _ in
            self?.viewModel.sortItems(by: .newest)  { [weak self] in
                self?.pocketDetailView?.itemCollectionView.reloadData()
            }
        }
        
        let sortByOldest = UIAlertAction(title: "오래된순", style: .default) { [weak self] _ in
            self?.viewModel.sortItems(by: .oldest)  { [weak self] in
                self?.pocketDetailView?.itemCollectionView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(sortByDictionary)
        alert.addAction(sortByNewest)
        alert.addAction(sortByOldest)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // 검색어 입력 중 Return 키를 눌렀을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // 키보드 내리기
    }
}
extension PocketDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsInRow: CGFloat = 2
        let spacing: CGFloat = 12
        let totalSpacing = spacing * (numberOfCellsInRow - 1)
        
        let availableWidth = collectionView.bounds.width - totalSpacing
        let cellWidth = availableWidth / numberOfCellsInRow
        
        return CGSize(width: cellWidth, height: cellWidth * 1.25)
    }
    
}

extension PocketDetailViewController {
    private func setupNavigationBar() {
        // 네비게이션 바를 투명하게 설정 (시도 중)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        
        // 커스텀 백 버튼 생성
        let button = UIButton()
        button.setButtonWithSystemImage(imageName: "chevron.left")
        
        button.setTitle(viewModel.pocket.title, for: .normal) // 주머니 이름으로 가져옴
        button.setTitleColor(.black900Zt, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        
        button.titleLabel?.lineBreakMode = .byTruncatingTail  // 텍스트가 너무 길면 끝에 "..."이 표시됨
        button.titleLabel?.numberOfLines = 1  // 한 줄로만 표시
        
        button.titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        
        button.frame.size.width = UIScreen.main.bounds.width - 50 // 화면의 가로 길이 - 50
        button.contentHorizontalAlignment = .left  // 이미지와 텍스트 왼쪽 정렬
        
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
