//
//  ItemDetailViewController.swift
//  zzimtory
//
//  Created by seohuibaek on 2/12/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemDetailViewController: UIViewController {
    
    private var itemDetailCollectionView: UICollectionView!
    private let viewModel: ItemDetailViewModel
    private let disposeBag = DisposeBag()
    private let items: [Item]    // 전체 아이템 배열
    private let currentIndex: Int // 현재 아이템의 인덱스
    
    // ZTView를 배경으로 추가
    private let backgroundView = ZTView()
    
    init(items: [Item], currentIndex: Int) {
        self.items = items
        self.currentIndex = currentIndex
        self.viewModel = ItemDetailViewModel(items: items, currentIndex: currentIndex)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        setupUI()
        setupNavigationBar()
        setupCollectionView()
        bind()
    }
    
    private func setupUI() {
        // 기존의 view를 backgroundZTView로 변경
        // view = backgroundView
        //        backgroundView.frame = view.bounds
        //
        //        view.addSubview(backgroundView)
        //        backgroundView.snp.makeConstraints { make in
        //            make.edges.equalToSuperview()
        //        }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        layout.minimumLineSpacing = 0
        
        itemDetailCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // itemDetailCollectionView.contentInsetAdjustmentBehavior = .always
        itemDetailCollectionView.isPagingEnabled = true
        itemDetailCollectionView.register(ItemDetailCollectionViewCell.self, forCellWithReuseIdentifier: "ItemDetailCollectionViewCell")
        
        // ZTView를 컬렉션 뷰의 배경으로 설정
        // let backgroundView = ZTView()
        
        view.addSubview(itemDetailCollectionView)
        itemDetailCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            //            make.horizontalEdges.bottom.equalToSuperview()
            //            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        // 메인 아이템 목록 바인딩
        viewModel.items
            .drive(itemDetailCollectionView.rx.items(
                cellIdentifier: "ItemDetailCollectionViewCell",
                cellType: ItemDetailCollectionViewCell.self
            )) { [weak self] _, item, cell in
                cell.setCell(with: item)
                
                // 유사 상품 바인딩
                self?.viewModel.similarItems
                    .bind(to: cell.similarItemCollectionView.rx.items(
                        cellIdentifier: ItemCollectionViewCell.id,
                        cellType: ItemCollectionViewCell.self
                    )) { _, similarItem, similarCell in
                        similarCell.setCell(with: similarItem)
                    }
                    .disposed(by: cell.disposeBag)
                
                // 유사 상품 선택
                cell.similarItemCollectionView.rx.modelSelected(Item.self)
                    .subscribe(onNext: { [weak self] selectedItem in
                        let detailVC = DetailViewController(item: selectedItem)
                        self?.navigationController?.pushViewController(detailVC, animated: true)
                    })
                    .disposed(by: cell.disposeBag)
                
                // 웹사이트 이동
                cell.websiteButton.rx.tap
                    .map { item.link }
                    .subscribe(onNext: { [weak self] urlString in
                        guard let self = self else { return }
                        let webVC = ItemDetailWebViewController(urlString: urlString, viewModel: self.viewModel)
                        self.navigationController?.pushViewController(webVC, animated: true)
                    })
                    .disposed(by: cell.disposeBag)
                
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
                
                self?.viewModel.isInPocket
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] isInPocket in
                        cell.setSaveButton(isInPocket)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.saveButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        
                        // 로그인 상태 확인
                        guard DatabaseManager.shared.hasUserLoggedIn() else {
                            self.presentLoginView()
                            return
                        }
                        
                        // 주머니에 이미 존재하는 경우 → handlePocketButton() 호출
                        if self.viewModel.isInPocketStatus {
                            self.viewModel.handlePocketButton()
                            return
                        }
                        
                        // 주머니에 없으면 모달 띄우기
                        let pocketVC = PocketSelectionViewController(selectedItems: [self.viewModel.currentItem])
                        self.present(pocketVC, animated: true)
                        
                        // 모달에서 주머니 추가 완료 시 ViewModel 업데이트
                        pocketVC.onComplete = { [weak self] in
                            self?.viewModel.addToPocket()
                        }
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func presentLoginView() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}

extension ItemDetailViewController {
    private func setupNavigationBar() {
        // 네비게이션 바를 투명하게 설정 (시도 중)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = nil
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        
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
