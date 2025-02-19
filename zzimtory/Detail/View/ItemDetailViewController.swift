//
//  ItemDetailViewController.swift
//  zzimtory
//
//  Created by seohuibaek on 2/12/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemDetailViewController: ZTViewController {
    
    private let viewModel: ItemDetailViewModel
    private let disposeBag = DisposeBag()
    private let items: [Item]    // 전체 아이템 배열
    private var currentIndex: Int // 현재 아이템의 인덱스
    
    private var itemDetailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.isPagingEnabled = true
        
        collectionView.register(ItemDetailCollectionViewCell.self, forCellWithReuseIdentifier: "ItemDetailCollectionViewCell")
        
        return collectionView
    }()
    
    init(items: [Item], currentIndex: Int = 0) {
        self.items = items
        self.currentIndex = currentIndex
        self.viewModel = ItemDetailViewModel(items: items, currentIndex: currentIndex)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: self.currentIndex, section: 0)
            self.itemDetailCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
        }
        
        setupNavigationBar()
        setupCollectionView()
        bind()
        saveRecentItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layout = itemDetailCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = itemDetailCollectionView.bounds.size
        }
    }
    
    private func setupCollectionView() {
        view.addSubview(itemDetailCollectionView)
        
        itemDetailCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide) // 네비게이션바 아래부터
            make.horizontalEdges.bottom.equalToSuperview()
            // make.edges.equalToSuperview() // 네비게이션바를 덮도록
        }
    }
    
    private func bind() {
        // 메인 아이템 목록 바인딩
        viewModel.items
            .drive(itemDetailCollectionView.rx.items(
                cellIdentifier: "ItemDetailCollectionViewCell",
                cellType: ItemDetailCollectionViewCell.self
            )) { [weak self] index, item, cell in
                print("Current index: \(index), Item title: \(item.title)")
                cell.delegate = self
                cell.setCell(with: item)
                
                // 웹사이트 이동
                cell.websiteButton.rx.tap
                    .map { item.link }
                    .subscribe(onNext: { [weak self] urlString in
                        guard let self = self else { return }
                        let webVC = ItemDetailWebViewController(urlString: urlString, viewModel: self.viewModel)
                        self.navigationController?.pushViewController(webVC, animated: true)
                    })
                    .disposed(by: cell.disposeBag)
                
                // 공유 버튼
                cell.shareButton.rx.tap
                    .map { item.link }
                    .subscribe(onNext: { [weak self] urlString in
                        guard let self = self,
                              let url = URL(string: urlString) else { return }
                        
                        let shareText = "주머니에서 꺼내왔습니다!!"
                        var shareItems: [Any] = [shareText]
                        
                        shareItems.append(url)
                        
                        // 기본 공유시트 사용
                        let shareActivityViewController = UIActivityViewController(
                            activityItems: shareItems,
                            applicationActivities: nil
                        )
                        
                        self.present(shareActivityViewController, animated: true)
                    })
                    .disposed(by: cell.disposeBag)
                
                // 저장/삭제 버튼 동작
                cell.saveButton.rx.tap
                    .map { _ in item.productID }
                    .withLatestFrom(self?.viewModel.itemStatus(for: item.productID) ?? .just(false)) { ($0, $1) }
                    .subscribe(onNext: { [weak self] (productID, isInPocket) in
                        guard let self = self else { return }
                        
                        // 비회원일 경우 로그인 진행
                        guard DatabaseManager.shared.hasUserLoggedIn() else {
                            self.presentLoginView()
                            return
                        }
                        
                        if isInPocket {
                            // 아이템이 있을 경우 -> 삭제
                            showDeleteItemAlert {
                                self.viewModel.togglePocketStatus(for: productID)
                            }
                        } else {
                            // 아이템이 없을 경우 -> 저장: 주머니 선택 모달
                            let pocketVC = PocketSelectionViewController(selectedItems: [item])
                            self.present(pocketVC, animated: true)
                            
                            pocketVC.onComplete = { [weak self] in
                                self?.viewModel.togglePocketStatus(for: productID)
                            }
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                // 저장/삭제 버튼 상태 업데이트
                self?.viewModel.itemStatus(for: item.productID)
                    .drive(onNext: { isInPocket in
                        cell.setSaveButton(isInPocket)
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // 스크롤 시 현재 index 업데이트
        itemDetailCollectionView.rx.didEndDecelerating
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                let visibleIndexPaths = self.itemDetailCollectionView.indexPathsForVisibleItems
                let sortedIndexPaths = visibleIndexPaths.sorted(by: { $0.item < $1.item })
                
                if let firstIndexPath = sortedIndexPaths.first {
                    self.currentIndex = firstIndexPath.item
                    self.viewModel.updateCurrentIndex(firstIndexPath.item)
                    self.saveRecentItem()
                    // print("현재 선택된 index: \(self.currentIndex)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func presentLoginView() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}

extension ItemDetailViewController {
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        
        // 커스텀 백버튼 생성
        let button = UIButton()
        
        button.setAsIconButton()
        button.setButtonWithSystemImage(imageName: "chevron.left")
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // 네비게이션 아이템으로 설정
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension ItemDetailViewController {
    // 삭제 알러트 창
    private func showDeleteItemAlert(completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "주머니에서 삭제",
            message: "주머니에서 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
            completion()
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
    
    // 최근 본 아이템 저장 UserDefaults
    private func saveRecentItem() {
        let userDefaults = UserDefaults.standard
        let recentItemsKey = "recentItems"
        let maxRecentItems = 10
        
        // 현재 저장된 아이템들 로드
        var recentItems: [Item] = []
        if let data = userDefaults.data(forKey: recentItemsKey) {
            do {
                recentItems = try JSONDecoder().decode([Item].self, from: data)
            } catch {
                print("최근 본 아이템 - 유저 디폴트 디코딩 에러: \(error)")
            }
        }
        
        // 현재 아이템이 이미 있다면 제거
        recentItems.removeAll { $0.productID == viewModel.currentItem.productID }
        recentItems.insert(viewModel.currentItem, at: 0)
        
        // 최대 개수 넘어가면 이전 아이템 삭제
        if recentItems.count > maxRecentItems {
            recentItems.removeLast(recentItems.count - maxRecentItems)
        }
        
        // 순서 보장을 위해 배열로 저장
        do {
            let data = try JSONEncoder().encode(recentItems)
            userDefaults.set(data, forKey: recentItemsKey)
        } catch {
            print("최근 본 아이템 - 유저 디폴트 인코딩 에러: \(error)")
        }
    }
}

extension ItemDetailViewController: ItemDetailCollectionViewCellDelegate {
    func didSelectSimilarItem(_ item: Item) {
        let detailVC = ItemDetailViewController(items: [item], currentIndex: 0)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
