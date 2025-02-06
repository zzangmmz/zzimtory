//
//  ItemWebViewController.swift
//  zzimtory
//
//  Created by seohuibaek on 1/28/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FirebaseAuth

final class ItemWebViewController: UIViewController {
    private let itemWebView = ItemWebView()
    private let urlString: String
    private let viewModel: DetailViewModel  // DetailViewModel 사용
    private let disposeBag = DisposeBag()
    
    init(urlString: String, viewModel: DetailViewModel) {  // 생성자 변경
        self.urlString = urlString
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = itemWebView
        
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
        itemWebView.itemWebView.load(URLRequest(url: url))
    }
    
    private func bind() {
        
        itemWebView.shareButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let url = URL(string: self.urlString) else { return }
                
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
                let imageName = isInPocket ? "EmptyPocketIcon" : "PocketIcon"
                
                self?.itemWebView.saveButton.setTitle(title, for: .normal)
                self?.itemWebView.saveButton.setButtonWithCustomImage(imageName: imageName)
            })
            .disposed(by: disposeBag)
        
        itemWebView.saveButton.rx.tap
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
    
    @objc private func backButtonTapped() {
        // 모달 닫기
        // dismiss(animated: true)
        
        // 화면 전환
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    @objc private func safariButtonTapped() {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
