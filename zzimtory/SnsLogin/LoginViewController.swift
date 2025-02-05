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
    }
    
    private func bind() {
        loginView?.appleLoginButton.rx.tap
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
    }
    
}

extension LoginViewController {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
