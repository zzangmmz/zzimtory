//
//  ItemDetailViewController.swift
//  zzimtory
//
//  Created by seohuibaek on 2/12/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView!
    private var items: [Item] = []
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    //ZTView를 배경으로 추가
    private let backgroundView = ZTView()

    init(item: Item) {
        self.viewModel = DetailViewModel(item: item)
        super.init(nibName: nil, bundle: nil)
        self.items.append(item)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupCollectionView()
        bind()
    }
    
    private func setupUI() {
        // 기존의 view를 backgroundZTView로 변경
        view = backgroundView
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(ItemDetailCollectionViewCell.self, forCellWithReuseIdentifier: "ItemDetailCollectionViewCell")

        backgroundView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bind() {
        viewModel.similarItems
            .subscribe(onNext: { [weak self] newItems in
                guard let self = self else { return }
                self.items.append(contentsOf: newItems)
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemDetailCollectionViewCell", for: indexPath) as! ItemDetailCollectionViewCell
        // cell.configure(with: items[indexPath.item])
        return cell
    }
}
