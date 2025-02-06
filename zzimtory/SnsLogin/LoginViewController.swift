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
//
// fileprivate var currentNonce: String?
//
//final class LoginViewController: UIViewController {
//    private var loginView: LoginView?
//    private let disposeBag = DisposeBag()
//    private let viewModel = LoginViewModel()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loginView = LoginView(frame: view.frame)
//        bind()
//        view = loginView
//    }
//    
//    private func bind() {
//        loginView?.appleLoginButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.viewModel.signInWithApple(on: self!)
//            })
//            .disposed(by: disposeBag)
//        
//        loginView?.googleLoginButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.viewModel.signInWithGoogle(on: self!)
//            })
//            .disposed(by: disposeBag)
//        loginView?.kakaoLoginButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.viewModel.signInWithKakao()
//            })
//            .disposed(by: disposeBag)
//        loginView?.naverLoginButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.viewModel.signInWithNaver()
//            })
//            .disposed(by: disposeBag)
//    }
//}

final class LoginViewController: UIViewController {
    private var loginView: LoginView?
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView = LoginView(frame: view.frame)
        bind()
        view = loginView
    }
    
    private func bind() {
        loginView?.appleLoginButton.addTarget(self,
                                              action: #selector(appleLoginButtonTapped),
                                              for: .touchUpInside)
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
    }
    
    @objc private func appleLoginButtonTapped() {
        viewModel.signInWithApple(on: self)
    }
}
