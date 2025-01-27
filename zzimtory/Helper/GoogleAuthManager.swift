//
//  GoogleAuthManager.swift
//  zzimtory
//
//  Created by 이명지 on 1/27/25.
//

import Foundation
import GoogleSignIn

final class GoogleAuthManager {
    static let shared = GoogleAuthManager()
    
    private init() {}
    
    /// 구글 로그인 초기 설정 메서드
    func configure() {
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: AuthClientID.google)
    }
    
    /// 로그인 메서드
    func login(presenting viewController: UIViewController, completion: @escaping (Result<GIDGoogleUser, Error>) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = signInResult?.user else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User information not found"])))
                return
            }
            completion(.success(user))
        }
    }
    
    /// 로그아웃 메서드
    func logout() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    /// 계정의 구글 로그인 연동 끊는 메서드
    func disconnect(completion: @escaping (Error?) -> Void) {
        GIDSignIn.sharedInstance.disconnect { error in
            completion(error)
        }
    }
}
