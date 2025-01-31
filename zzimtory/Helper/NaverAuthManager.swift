//
//  NaverAuthManager.swift
//  zzimtory
//
//  Created by 이명지 on 1/30/25.
//

import NaverThirdPartyLogin
import RxSwift
import FirebaseAuth

final class NaverAuthManager: NSObject, ThirdPartyAuthProtocol {
    private let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    private let repository: NaverLoginRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    init(repository: NaverLoginRepositoryProtocol = NaverLoginRepository()) {
        self.repository = repository
        super.init()
        instance?.delegate = self
    }
    
    private func getUserInfo(completion: @escaping (NaverLoginResponse?) -> Void) {
        guard let tokenType = instance?.tokenType,
              let accessToken = instance?.accessToken else {
            print("토큰 정보가 없습니다.")
            completion(nil)
            return
        }
        
        repository.getUserInfo(tokenType: tokenType, accessToken: accessToken)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { response in
                completion(response)
            }, onFailure: { error in
                print("유저 정보 가져오기 실패: \(error)")
                completion(nil)
            })
            .disposed(by: disposeBag)
    }
    
    func login() {
        instance?.requestThirdPartyLogin()
    }
    
    func firebaseLogin() {
        getUserInfo { response in
            guard let response = response else { return }
            let email = response.value.email
            let id = response.value.id
            let nickname = response.value.nickname
            
            Auth.auth().signIn(withEmail: email, password: id) { _, error in
                if let _ = error {
                    // 계정이 없는 경우 새로 생성
                    Auth.auth().createUser(withEmail: email, password: id) { _, createError in
                        if let createError = createError {
                            print("Firebase 계정 생성 실패: \(createError.localizedDescription)")
                        } else {
                            print("Firebase 계정 생성 성공")
                        }
                    }
                } else {
                    print("Firebase 로그인 성공")
                }
            }
        }
    }
    
    func logout() {
        instance?.resetToken()
    }
    
    func disconnect() {
        instance?.requestDeleteToken()
    }
}

extension NaverAuthManager: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공")
        self.firebaseLogin()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 토큰 갱신 성공")
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그인 연동 해제 성공")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: (any Error)!) {
        print("에러 : \(error.localizedDescription)")
    }
}
