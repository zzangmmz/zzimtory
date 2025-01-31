//
//  LoginViewModel.swift
//  zzimtory
//
//  Created by 이명지 on 1/30/25.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

final class LoginViewModel {
    private let googleAuthManager: GoogleAuthManager
    private let naverAuthManager: NaverAuthManager
    
    init() {
        self.googleAuthManager = GoogleAuthManager()
        self.naverAuthManager = NaverAuthManager()
        self.naverAuthManager.delegate = self
    }
    
    func signInWithApple() {
        
    }
    
    func signInWithGoogle(on viewContorller: UIViewController) {
        googleAuthManager.login(from: viewContorller)
    }
    
    func signInWithKakao() {
        let kakaoAuthManager = KakaoAuthManager()
        kakaoAuthManager.login()
    }
    
    func signInWithNaver() {
        naverAuthManager.login()
    }
}

extension LoginViewModel: NaverAuthManagerDelegate {
    func didFinishLogin(id: String, email: String) {
        print("로그인 성공!")
        print("이메일: \(email)")
    }
    
    func didFailLogin(with error: Error) {
        print("로그인 실패: \(error.localizedDescription)")
    }
}
