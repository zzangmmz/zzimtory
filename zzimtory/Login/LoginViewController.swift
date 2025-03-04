//
//  LoginViewController.swift
//  zzimtory
//
//  Created by 이명지 on 1/27/25.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    private var loginView: LoginView?
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView = LoginView(frame: view.frame)
        bind()
        view = loginView
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    private func bind() {
        loginView?.appleCustomLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.signInWithApple(on: self!)
                self?.loginView?.startLoading()
            })
            .disposed(by: disposeBag)
        
        loginView?.googleLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.signInWithGoogle(on: self!)
                self?.loginView?.startLoading()
            })
            .disposed(by: disposeBag)
        
        loginView?.kakaoLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.signInWithKakao()
                self?.loginView?.startLoading()
            })
            .disposed(by: disposeBag)
        
        loginView?.naverLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.signInWithNaver()
                self?.loginView?.startLoading()
            })
            .disposed(by: disposeBag)
        
        DatabaseManager.shared.completedLogin
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] bool in
                self?.loginView?.stopLoading()
                if bool {
                    let tabbarVC = TabbarViewController()
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = tabbarVC
                        window.makeKeyAndVisible()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func appleLoginButtonTapped() {
        viewModel.signInWithApple(on: self)
    }
}
