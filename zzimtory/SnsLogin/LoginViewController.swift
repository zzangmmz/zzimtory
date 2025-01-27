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
        
    }
}
