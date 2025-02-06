//
//  MainViewController.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/24/25.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{
    private var mainView: MainView?
    private let viewModel = MainPocketViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
    }
    
    private func setupCollectionView() {
        mainView?.collectionView.dataSource = self
        mainView?.collectionView.delegate = self
        mainView?.collectionView.register(
            PocketCell.self,
            forCellWithReuseIdentifier: "PocketCell"
        )
    }
    
    private func bind() {
        self.viewModel.fetchData { [weak self] pockets in
            self?.mainView?.pocketCountLabel.text = "주머니 \(pockets.count)개"
            self?.mainView?.collectionView.reloadData()
        }
    }
    
    @objc private func addPocketButtonDidTap() {
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
        
        let sortByOldestAction = UIAlertAction(title: "내림차순", style: .default) { [weak self] _ in
            self?.viewModel.sortPockets(by: .descending) { [weak self] in
                self?.mainView?.collectionView.reloadData()
            }
        }
        
        let sortByNewestAction = UIAlertAction(title: "오름차순", style: .default) { [weak self] _ in
            self?.viewModel.sortPockets(by: .ascending) { [weak self] in
                self?.mainView?.collectionView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(sortByOldestAction)
        alert.addAction(sortByNewestAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pockets.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PocketCell",
                                                            for: indexPath) as? PocketCell else {
            fatalError("Unable to dequeue PocketCell")
        }
        
        let pocket = viewModel.pockets[indexPath.item]
        cell.configure(with: pocket)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pocket = viewModel.filterPockets[indexPath.item]
        print("\(pocket.title) 이 클릭됨")
        
        let detailViewModel = PocketDetailViewModel(pocket: pocket)
        let detailVC = PocketDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterPockets(with: searchText)
        mainView?.collectionView.reloadData()
    }
    
    @objc private func editButtonDidTap() {
        print("수정/삭제 버튼 눌림") // 수정/삭제 기능 추가 예정
        DatabaseManager.shared.deletePocket(title: "12")
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
