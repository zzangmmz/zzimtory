//
//  DetailViewController.swift
//  zzimtory
//
//  Created by seohuibaek on 1/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FirebaseAuth

final class DetailViewController: UIViewController {
    private var detailView = DetailView()
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    init(item: Item) {
        self.viewModel = DetailViewModel(item: item)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView = DetailView(frame: view.frame)
        self.view = detailView
        navigationController?.navigationBar.isHidden = false        
        setupNavigationBar()
        bind()
    }
    
    private func bind() {
        // 타이틀 바인딩
        viewModel.itemTitle
            .bind(to: detailView.itemNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 브랜드명 바인딩
        viewModel.itemBrand
            .subscribe(onNext: { [weak self] text in
                self?.detailView.brandButton.setTitle(text, for: .normal)
            })
            .disposed(by: disposeBag)
        
        // 가격 바인딩
        viewModel.itemPrice
            .bind(to: detailView.priceLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 이미지 바인딩
        viewModel.itemImageUrl
            .subscribe(onNext: { [weak self] urlString in
                if let url = URL(string: urlString) {
                    self?.detailView.itemImageView.loadImage(from: url)
                }
            })
            .disposed(by: disposeBag)
        
        // 유사 상품 바인딩
        viewModel.similarItems
            .bind(to: detailView.similarItemCollectionView.rx.items(
                cellIdentifier: ItemCollectionViewCell.id,
                cellType: ItemCollectionViewCell.self
            )) { _, item, cell in
                cell.setCell(with: item)
            }
            .disposed(by: disposeBag)
        
        // 유사 상품 선택 시 처리
        // 보통은 뷰모델을 거침
        detailView.similarItemCollectionView.rx.modelSelected(Item.self)
            .subscribe(onNext: { [weak self] item in
                let detailVC = DetailViewController(item: item)
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 웹사이트 버튼 탭 처리
        detailView.websiteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let url = URL(string: self.viewModel.currentItem.link) else { return }
                
                // let webVC = ItemWebViewController(urlString: url.absoluteString, item: self.viewModel.currentItem)
                let webVC = ItemWebViewController(urlString: url.absoluteString, viewModel: self.viewModel)
                self.navigationController?.pushViewController(webVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // 공유 버튼 탭 처리
        detailView.shareButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let url = URL(string: self.viewModel.currentItem.link) else { return }
                
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
            .disposed(by: disposeBag)
        
        // 주머니 상태에 따른 버튼 UI 업데이트
        viewModel.isInPocket
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isInPocket in
                let title = isInPocket ? "주머니에서 빼기" : "주머니에 넣기"
                let imageName = isInPocket ? "EmptyPocketIcon" : "PocketBlack"
                
                self?.detailView.saveButton.setTitle(title, for: .normal)
                self?.detailView.saveButton.setButtonWithCustomImage(imageName: imageName)
            })
            .disposed(by: disposeBag)

        detailView.saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                // 로그인 상태 확인
                guard Auth.auth().currentUser != nil else {
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
            .disposed(by: disposeBag)
    }
    
    private func presentLoginView() {
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

extension DetailViewController {
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
