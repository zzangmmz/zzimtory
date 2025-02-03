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
    private let kakaoAuthManager: KakaoAuthManager
    private let naverAuthManager: NaverAuthManager
    
    init() {
        self.googleAuthManager = GoogleAuthManager()
        self.kakaoAuthManager = KakaoAuthManager()
        self.naverAuthManager = NaverAuthManager()
    }
    
    func signInWithApple(on viewContorller: UIViewController) {
        
    }
    
    func signInWithGoogle(on viewContorller: UIViewController) {
        googleAuthManager.login(from: viewContorller)
    }
    
    func signInWithKakao() {
        kakaoAuthManager.login()
    }
    
    func signInWithNaver() {
        naverAuthManager.login()
    }
}
