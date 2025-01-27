//
//  LoginViewController.swift
//  zzimtory
//
//  Created by 이명지 on 1/27/25.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    private var loginView: LoginView?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView = LoginView(frame: view.frame)
        bind()
        view = loginView
    }
    
    private func bind() {
        loginView?.appleLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.signInWithApple()
            })
            .disposed(by: disposeBag)
        
        loginView?.googleLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.signInWithGoogle()
            })
            .disposed(by: disposeBag)
    }
    
    private func signInWithApple() {
        
    }
    
    private func signInWithGoogle() {
        GoogleAuthManager.shared.login(presenting: self) { [weak self] result in
            switch result {
            case .success(let user):
                print(user)
                // 로그인 성공 후 로그인 뷰컨 pop
            case .failure(let error):
                print(error)
                // 사용자 예외 처리 필요
            }
        }
    }
}
