//
//  PocketDetailViewController.swift
//  zzimtory
//
//  Created by t2023-m0072 on 2/1/25.
//

import UIKit
class PocketDetailViewController: UIViewController,
                                    UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    private var pocketDetailView: PocketDetailView!
    private var viewModel: PocketDetailViewModel!
    
    // viewModel을 전달받는 생성자
    init(viewModel: PocketDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pocketDetailView = PocketDetailView(frame: view.frame)
        view = pocketDetailView
        
        setupCollectionView()
        setupActions()
        
        pocketDetailView.configure(with: viewModel.pocketTitle, itemCount: viewModel.items.count)
    }
    
    private func setupActions() {
        // 정렬 버튼
        pocketDetailView.sortButton.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        pocketDetailView.itemCollectionView.delegate = self
        pocketDetailView.itemCollectionView.dataSource = self
        pocketDetailView.itemCollectionView.register(ItemCollectionViewCell.self,
                                                     forCellWithReuseIdentifier: ItemCollectionViewCell.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.id,
                                                            for: indexPath) as? ItemCollectionViewCell else {
            fatalError("Unable to dequeue ItemCollectionViewCell")
        }
        
        let item = viewModel.filteredItems[indexPath.item]
        cell.setCell(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("아이템 클릭됨: \(viewModel.filteredItems[indexPath.item].title)")
    }
    
    // 서치바 텍스트 변경 시 필터링된 결과를 업데이트
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.filteredItems = viewModel.items // 텍스트가 없으면 모든 아이템을 표시
        } else {
            viewModel.filteredItems = viewModel.items.filter { item in
                item.title.lowercased().contains(searchText.lowercased()) // 제목에 검색어가 포함되면 필터링
            }
        }
        pocketDetailView.itemCollectionView.reloadData() // 필터링된 데이터로 CollectionView 업데이트
    }
    
    @objc private func sortButtonDidTap() {
        print("정렬 버튼 클릭됨")
        // 정렬 로직 추가 예정
    }

}
