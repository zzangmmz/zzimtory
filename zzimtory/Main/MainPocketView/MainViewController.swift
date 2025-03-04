//
//  MainViewController.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/24/25.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    private var mainView: MainView?
    private let viewModel = MainPocketViewModel()
    
    private var editMode: Bool = false {
        didSet {
            mainView?.collectionView.visibleCells.forEach { cell in
                if let itemCell = cell as? PocketCell {
                    itemCell.setEditModePocket(with: editMode)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

        if !DatabaseManager.shared.hasUserLoggedIn() {
            self.mainView?.sortButton.isEnabled = false
        }
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView = MainView(frame: view.frame)
        self.view = self.mainView
        setupActions()
        setupCollectionView()
    }
    
    private func setupActions() {
        mainView?.addPocketButton.addTarget(self, action: #selector(addPocketButtonDidTap), for: .touchUpInside)
        mainView?.sortButton.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)
        mainView?.editButton.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
        mainView?.searchBar.delegate = self
        mainView?.moveCancelButton.addTarget(self, action: #selector(moveCancelButtonDidTap), for: .touchUpInside)
        mainView?.pocketDeleteButton.addTarget(self, action: #selector(pocketDeleteButtonDidTap), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        mainView?.collectionView.dataSource = self
        mainView?.collectionView.delegate = self
        mainView?.collectionView.allowsMultipleSelection = true
        mainView?.collectionView.register(
            PocketCell.self,
            forCellWithReuseIdentifier: "PocketCell"
        )
    }
    
    private func bind() {
        self.viewModel.fetchData { [weak self] pockets in
            guard let pockets = pockets else { return }
            self?.mainView?.pocketCountLabel.text = "주머니 \(pockets.count)개"
            self?.mainView?.collectionView.reloadData()
        }
    }
    
    @objc private func addPocketButtonDidTap() {
        guard DatabaseManager.shared.hasUserLoggedIn() else {
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
            return
        }
        
        let alert = UIAlertController(title: "주머니 만들기", message: "새 주머니를 입력하세요.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "새 주머니 이름"
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(
            title: "확인",
            style: .default
        ) { [weak self] _ in
            guard let self = self,
                  let textField = alert.textFields?.first,
                  let name = textField.text,
                  !name.isEmpty else { return }
            self.viewModel.addPocket(title: name) { [weak self] in
                self?.bind()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func sortButtonDidTap() {
        let alert = UIAlertController(title: "상품명", message: "정렬 기준을 선택하세요.", preferredStyle: .actionSheet)
        
        let sortByDictionary = UIAlertAction(title: "가나다순", style: .default) { [weak self] _ in
            self?.viewModel.sortPockets(by: .dictionary) { [weak self] in
                self?.mainView?.collectionView.reloadData()
            }
        }
        
        let sortByNewestAction = UIAlertAction(title: "최신순", style: .default) { [weak self] _ in
            self?.viewModel.sortPockets(by: .newest) { [weak self] in
                self?.mainView?.collectionView.reloadData()
            }
        }
        
        let sortByOldestAction = UIAlertAction(title: "오래된순", style: .default) { [weak self] _ in
            self?.viewModel.sortPockets(by: .oldest) { [weak self] in
                self?.mainView?.collectionView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(sortByDictionary)
        alert.addAction(sortByOldestAction)
        alert.addAction(sortByNewestAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.displayPockets.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PocketCell",
                                                            for: indexPath) as? PocketCell else {
            fatalError("Unable to dequeue PocketCell")
        }
        
        let pocket = viewModel.displayPockets[indexPath.item]
        cell.configure(with: pocket)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pocket = viewModel.displayPockets[indexPath.item]
        
        guard editMode else {
            let detailViewModel = PocketDetailViewModel(pocket: pocket)
            let detailVC = PocketDetailViewController(viewModel: detailViewModel)
            navigationController?.pushViewController(detailVC, animated: true)
            
            return
        }
        
        // 편집모드에서 "전체보기" 주머니는 선택 불가
        if pocket.title == "전체보기" {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        
        // 편집모드인 경우
        if let selectedCell = collectionView.cellForItem(at: indexPath) as?
            PocketCell {
            selectedCell.pocketOverlayView.isHidden = true
            selectedCell.isSelected = true
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard editMode else { return }
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? PocketCell {
            selectedCell.pocketOverlayView.isHidden = false
            selectedCell.isSelected = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterPockets(with: searchText)
        mainView?.collectionView.reloadData()
    }
    
    // 검색어 입력 중 Return 키를 눌렀을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // 키보드 내리기
    }
    
    @objc func editButtonDidTap() {
        editMode.toggle()
        mainView?.toggleButtonHidden()
    }
    
    @objc func moveCancelButtonDidTap() {
        editMode.toggle()
        mainView?.toggleButtonHidden()
        mainView?.collectionView.reloadData()
    }
    
    @objc func pocketDeleteButtonDidTap() {
        guard let selectedIndexPaths = mainView?.collectionView.indexPathsForSelectedItems else { return }

        let indexPathsToDelete = selectedIndexPaths.filter { $0.item != 0 }
        let selectedPockets = indexPathsToDelete.map { viewModel.displayPockets[$0.item] }
        
        showAlert(title: "주머니를 삭제하시겠습니까?") { [weak self] in
            selectedPockets.forEach { pocket in
                DatabaseManager.shared.deletePocket(title: pocket.title) {
                    self?.bind()  // 각 삭제 완료 후 데이터 새로고침 / 대신 주머니 3번 삭제하면 3번 호출됨
                }
                print()
                print("삭제 성공 주머니 \(pocket.title)")
                print()
            }
            
            self?.bind()
            self?.editMode = false
            self?.mainView?.toggleButtonHidden()
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsInRow: CGFloat = 2
        let spacing: CGFloat = 20
        let totalSpacing = spacing * (numberOfCellsInRow - 1)
        
        let availableWidth = collectionView.bounds.width - totalSpacing
        let cellWidth = availableWidth / numberOfCellsInRow
        
        return CGSize(width: cellWidth, height: cellWidth * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

// MARK: - Alert
extension MainViewController {
    private func showAlert(title: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { _ in
            completion()
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
