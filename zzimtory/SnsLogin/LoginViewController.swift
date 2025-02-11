//
//  LoginViewController.swift
//  zzimtory
//
//  Created by 이명지 on 1/27/25.
//

import UIKit
import RxSwift
import RxCocoa
import CryptoKit
import AuthenticationServices

final class LoginViewController: UIViewController {
    private var loginView: LoginView?
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView = LoginView(frame: view.frame)
        bind()
        view = loginView
        navigationController?.isNavigationBarHidden = true
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
            })
            .disposed(by: disposeBag)
        
        loginView?.googleLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.signInWithGoogle(on: self!)
            })
            .disposed(by: disposeBag)
        
        loginView?.kakaoLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.signInWithKakao()
            })
            .disposed(by: disposeBag)
        
        loginView?.naverLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.signInWithNaver()
            })
            .disposed(by: disposeBag)
        
        DatabaseManager.shared.completedLogin
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func appleLoginButtonTapped() {
        viewModel.signInWithApple(on: self)
    }
}
