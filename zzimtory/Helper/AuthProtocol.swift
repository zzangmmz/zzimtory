//
//  AuthProtocol.swift
//  zzimtory
//
//  Created by 이명지 on 1/31/25.
//

import UIKit
import GoogleSignIn

/// 파이어베이스에서 제공하는 로그인 과정 추상화
protocol NativeAuthProtocol: AnyObject {
    func login(
        from viewController: UIViewController,
        comletion: @escaping (Result<UserCredential, Error>) -> Void
    )
    func logout()
    func disconnect()
}

/// 파이어베이스에서 제공하지 않는 로그인 과정 추상화
protocol ThirdPartyAuthProtocol: AnyObject {
    func login()
    func firbaseLogin()
    func logout()
    func disconnect()
}

/// 로그인 결과 표준화하는 구조체
struct UserCredential {
    let uid: String?
    let email: String?
    let nickname: String?
    let token: String
    
    /// 구글 사용자 정보로부터 UserCredential 생성하는 생성자
    init(from googleUser: GIDGoogleUser) {
        self.uid = googleUser.userID
        self.email = googleUser.profile?.email
        self.nickname = googleUser.profile?.name
        self.token = googleUser.accessToken.tokenString
    }
    
    // 추후에 애플 유저 로그인도 추가
}
