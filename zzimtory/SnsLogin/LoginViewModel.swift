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
    
    func signInWithApple() {
        
    }
    
    func signInWithGoogle(on viewContorller: UIViewController) {
        let googleAuthManager = GoogleAuthManager()
        googleAuthManager.login(presenting: viewContorller) { [weak self] result in    // 나중에 뷰컨 pop하기 위해서 weak self 선언해둠
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
    
    func signInWithKakao() {
        let kakaoAuthManager = KakaoAuthManager()
        kakaoAuthManager.login()
    }
}
