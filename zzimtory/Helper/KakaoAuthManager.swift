//
//  KakaoAuthManager.swift
//  zzimtory
//
//  Created by 이명지 on 1/30/25.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import FirebaseAuth

final class KakaoAuthManager: ThirdPartyAuthProtocol {
    /// 카카오 로그인.  토큰 존재 여부로 기존 로그인 여부 확인.
    func login() {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { userInfo, error in
                if let _ = error {
                    // 만료된 토큰 or 기타 에러.
                    self.kakaoLogin()
                } else {
                    print("유효한 토큰 존재")
                }
            }
        } else {
            // 토큰 없음. 로그인 필요.
            self.kakaoLogin()
        }
    }
    
    /// 웹 혹은 앱으로 카카오 로그인
    private func kakaoLogin() {
        // 카톡 앱으로 로그인이 가능한 경우
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oAuthToken, error ) in
                if let error = error {
                    print("카카오톡으로 로그인 실패: \(error)")
                } else {
                    if let _ = oAuthToken {
                        print("카카오톡으로 로그인 성공")
                        self.firebaseLogin()
                    }
                }
            }
        }
        // 카톡 앱이 없는 경우 카톡 계정으로 웹 로그인
        else {
            UserApi.shared.loginWithKakaoAccount { (oAuthToken, error) in
                if let error = error {
                    print("카카오 계정으로 로그인 실패: \(error)")
                } else {
                    if let _ = oAuthToken {
                        print("카카오 계정으로 로그인 성공")
                        self.firebaseLogin()
                    }
                }
            }
        }
    }
    
    /// 파이어베이스에 카카오 로그인 아이디, 비번(유저 아이디) 등록
    func firebaseLogin() {
        UserApi.shared.me { (user, error) in
            if let error = error {
                print(error)
            } else {
                if let user = user {
                    Auth.auth().createUser(withEmail: (user.kakaoAccount?.email)!, password: "\(String(describing: user.id))") { result, error in
                        if let error = error {
                            print(error)
                            Auth.auth().signIn(withEmail: (user.kakaoAccount?.email)!, password: "\(String(describing: user.id))")
                            print("파어에베이스에 로그인 성공")
                        } else {
                            print("파이어베이스에 회원 가입 성공")
                        }
                    }
                }
            }
        }
    }
    
    func logout() {
        UserApi.shared.logout { error in
            if let error = error {
                print("카카오 로그아웃 실패: \(error)")
            } else {
                print("카카오 로그아웃 성공")
            }
        }
    }
    
    func disconnect() {
        UserApi.shared.unlink { error in
            if let error = error {
                print("카카오 로그인 연결끊기 실패: \(error)")
            } else {
                print("카카오 로그인 연결끊기 성공")
            }
        }
    }
}
