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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pocketDetailView = PocketDetailView(frame: view.frame)
        view = pocketDetailView
        navigationController?.navigationBar.isHidden = false

        setupNavigationBar()
        setupCollectionView()
        setupActions()
        
        pocketDetailView.configure(with: viewModel.pocket)
        bind()
    }
    
    private func bind() {
//        self.viewModel.fetchData { [weak self] pockets in
//            self?.pocketDetailView?.itemCollectionView.reloadData()
//        }
        
        self.viewModel.fetchData { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.pocketDetailView.configure(with: self.viewModel.pocket)
                self.pocketDetailView.itemCollectionView.reloadData()
            }
        }
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
        return viewModel.pocket.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.id,
                                                            for: indexPath) as? ItemCollectionViewCell else {
            fatalError("Unable to dequeue ItemCollectionViewCell")
        }
        
        let item = viewModel.pocket.items[indexPath.item]
        cell.setCell(with: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = viewModel.pocket.items[indexPath.item]
        let detailVC = DetailViewController(item: selectedItem)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // 서치바 텍스트 변경 시 필터링된 결과를 업데이트
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            viewModel.pocket.items = viewModel.pocket.items.filter { item in
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
