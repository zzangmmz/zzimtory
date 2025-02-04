//
//  MainViewController.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/24/25.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    private var mainView: MainView?
    private let viewModel = MainPocketViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView = MainView(frame: view.frame)
        self.view = self.mainView
        
        setupActions()
        setupCollectionView()
        bindViewModel()
    }
    
    private func setupActions() {
        mainView?.addPocketButton.addTarget(self, action: #selector(addPocketButtonDidTap), for: .touchUpInside)
        mainView?.sortButton.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)
        mainView?.editButton.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        mainView?.collectionView.dataSource = self
        mainView?.collectionView.delegate = self
        mainView?.collectionView.register(
            PocketCell.self,
            forCellWithReuseIdentifier: "PocketCell"
        ) // Register PocketCell
    }
    
    private func bindViewModel() {
        viewModel.onDataChanged = { [weak self] in
            guard let self = self else { return }
            self.mainView?.pocketCountLabel.text = "주머니 \(self.viewModel.pocketCount())개"
            self.mainView?.collectionView.reloadData()
        }
        
        // 주머니 개수 초기 표시하는 초기값 설정!
        mainView?.pocketCountLabel.text = "주머니 \(viewModel.pocketCount())개"
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
            guard let self = self, let textField = alert.textFields?.first,
                  let name = textField.text, !name.isEmpty else { return }
            self.viewModel.addPocket(named: name)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func sortButtonDidTap() {
        let alert = UIAlertController(title: "정렬", message: "정렬 기준을 선택하세요.", preferredStyle: .actionSheet)
        
        let sortByOldestAction = UIAlertAction(title: "오래된 순", style: .default) { [weak self] _ in
            self?.viewModel.sortPockets(by: .oldest)
        }
        
        let sortByNewestAction = UIAlertAction(title: "최신 순", style: .default) { [weak self] _ in
            self?.viewModel.sortPockets(by: .newest)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(sortByOldestAction)
        alert.addAction(sortByNewestAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pocketCount()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PocketCell",
                                                            for: indexPath) as? PocketCell else {
            fatalError("Unable to dequeue PocketCell")
        }
        
        let pocket = viewModel.pockets[indexPath.item]
        cell.configure(with: pocket.title, images: [])
        return cell
    }
    
    // UICollectionViewDelegate 메서드 구현
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pocket = viewModel.pockets[indexPath.item]
        print("\(pocket.title) 이 클릭됨")
        
        // "전체보기" 클릭 시 PocketDetailViewController로 이동
        let detailViewModel = PocketDetailViewModel(pocketTitle: pocket.title,
                                                    items: DummyModel.items)  // 새로운 viewModel 생성
        let detailVC = PocketDetailViewController(viewModel: detailViewModel) // 생성자 호출
        navigationController?.pushViewController(detailVC, animated: true)
    }
    @objc private func editButtonDidTap() {
        print("수정/삭제 버튼 눌림") // 수정/삭제 기능 추가 예정
        DatabaseManager.shared.deletePocket(title: "12")
    }
}
