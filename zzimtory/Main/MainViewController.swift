//
//  MainViewController.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/24/25.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource {
    private var mainView: MainView? {
        return self.view as? MainView
    }
    
    private let viewModel = MainPoketViewModel() // ViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = MainView(frame: view.frame)
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
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self, let textField = alert.textFields?.first, let name = textField.text, !name.isEmpty else { return }
            self.viewModel.addPocket(named: name)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func sortButtonDidTap() {
        print("정렬 버튼 눌림") // 정렬 기능 추가 예정
    }
    
    @objc private func editButtonDidTap() {
        print("수정/삭제 버튼 눌림") // 수정/삭제 기능 추가 예정
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pocketCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PocketCell", for: indexPath) as? PocketCell else {
            fatalError("Unable to dequeue PocketCell")
        }
        
        let pocket = viewModel.pockets[indexPath.item]
        cell.configure(with: pocket.name, images: pocket.images)
        return cell
    }
}
