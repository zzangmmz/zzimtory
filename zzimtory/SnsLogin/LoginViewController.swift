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
        GoogleAuthManager.shared.login(presenting: self) { [weak self] result in    // 나중에 뷰컨 pop하기 위해서 weak self 선언해둠
            switch result {
            case .success(let user):
                print(user)
                // 로그인 성공 후 로그인 뷰컨 pop
                guard let idToken = user.idToken?.tokenString else { return }
                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: user.accessToken.tokenString
                )
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error as NSError? {
                        print("파이어베이스 인증 오류: \(error.localizedDescription)")
                        print("에러 코드: \(error.code)")
                        return
                    }
                    print("파이어베이스 인증 성공")
                }
            case .failure(let error):
                print(error)
                // 사용자 예외 처리 필요
            }
        }
    }
}
