//
//  ItemDetailWebViewController.swift
//  zzimtory
//
//  Created by seohuibaek on 2/13/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FirebaseAuth

final class ItemDetailWebViewController: UIViewController {
    private let itemDetailWebView = ItemDetailWebView()
    private let urlString: String
    private let viewModel: ItemDetailViewModel  // DetailViewModel 사용
    private let disposeBag = DisposeBag()
    
    init(urlString: String, viewModel: ItemDetailViewModel) {  // 생성자 변경
        self.urlString = urlString
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = itemDetailWebView
        
        setupNavigationBar()
        loadURL()
        bind()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: configureNavigationButton(
            imageName: "chevron.left",
            action: #selector(backButtonTapped)
        ))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: configureNavigationButton(
            imageName: "safari",
            action: #selector(safariButtonTapped)
        ))
    }
    
    private func configureNavigationButton(imageName: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.setAsIconButton()
        button.setButtonWithSystemImage(imageName: imageName)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func loadURL() {
        guard let url = URL(string: urlString) else { return }
        itemDetailWebView.itemWebView.load(URLRequest(url: url))
    }
    
    private func bind() {
        
        itemDetailWebView.shareButton.rx.tap
            .withLatestFrom(viewModel.itemUrl) // tap 이벤트가 나타날 때마다 viewModel.itemUrl의 가장 최근 값을 방출
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
            .disposed(by: disposeBag)
        
        // 주머니 상태에 따른 버튼 UI 업데이트
        viewModel.isInPocket
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isInPocket in
                self?.itemDetailWebView.setSaveButton(isInPocket)
            })
            .disposed(by: disposeBag)
        
        itemDetailWebView.saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                // 로그인 상태 확인
                guard DatabaseManager.shared.hasUserLoggedIn() else {
                    self.presentLoginView()
                    return
                }
                
                // 주머니에 이미 존재하는 경우 → handlePocketButton() 호출
                if self.viewModel.isInPocketStatus {
                    showDeleteItemAlert {
                        self.viewModel.handlePocketButton()
                    }
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
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
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
    
    @objc private func backButtonTapped() {
        // 화면 전환
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    @objc private func safariButtonTapped() {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
