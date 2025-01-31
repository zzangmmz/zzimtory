//
//  GoogleAuthManager.swift
//  zzimtory
//
//  Created by 이명지 on 1/27/25.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

final class GoogleAuthManager: NativeAuthProtocol {
    private let instance = GIDSignIn.sharedInstance
    
    /// 구글 로그인 초기 설정 메서드
    func configure() {
        instance.configuration = GIDConfiguration(clientID: AuthClientID.google)
    }
    
    /// 로그인 메서드
    func login(from viewController: UIViewController) {
        instance.signIn(withPresenting: viewController) { signInResult, error in
            if let error = error {
                print(error)
                return
            }
            guard let user = signInResult?.user else {
                print("잘못된 사용자 정보입니다.")
                return
            }
            guard let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error as NSError? {
                    print("파이어베이스 인증 오류: \(error.localizedDescription)")
                    return
                }
                print("파이어베이스 인증 성공")
            }
        }
    }
    
    /// 로그아웃 메서드
    func logout() {
        instance.signOut()
    }
    
    /// 계정의 구글 로그인 연동 끊는 메서드
    func disconnect() {
        instance.disconnect { error in
            print("error: \(String(describing: error))")
        }
    }
}
