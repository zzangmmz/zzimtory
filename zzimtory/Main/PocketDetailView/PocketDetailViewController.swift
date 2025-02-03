//
//  PocketDetailViewController.swift
//  zzimtory
//
//  Created by t2023-m0072 on 2/1/25.
//

import UIKit

class PocketDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        
        // PocketDetailView에 viewModel 데이터 전달
        pocketDetailView.configure(with: viewModel.pocketTitle, itemCount: viewModel.items.count)
    }
    
    // CollectionView 설정
    private func setupCollectionView() {
        pocketDetailView.itemCollectionView.delegate = self
        pocketDetailView.itemCollectionView.dataSource = self
        pocketDetailView.itemCollectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.id)
    }
    
    // CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.id, for: indexPath) as? ItemCollectionViewCell else {
            fatalError("Unable to dequeue ItemCollectionViewCell")
        }
        
        let item = viewModel.items[indexPath.item]
        cell.setCell(with: item)
        return cell
    }
    
    // CollectionView Delegate (아이템 클릭 시)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("아이템 클릭됨: \(viewModel.items[indexPath.item].title)")
    }
}
