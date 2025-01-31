//
//  NaverAuthManager.swift
//  zzimtory
//
//  Created by 이명지 on 1/30/25.
//

import NaverThirdPartyLogin
import RxSwift
import FirebaseAuth

protocol NaverAuthManagerDelegate: AnyObject {
    func didFinishLogin(id: String, email: String)
    func didFailLogin(with error: Error)
}

final class NaverAuthManager: NSObject {
    private let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    private let repository: NaverLoginRepositoryProtocol
    private let disposeBag = DisposeBag()
    
    weak var delegate: NaverAuthManagerDelegate?
    
    init(repository: NaverLoginRepositoryProtocol = NaverLoginRepository()) {
        self.repository = repository
        super.init()
        instance?.delegate = self
    }
    
    func login() {
        instance?.requestThirdPartyLogin()
    }
    
    func logout() {
        instance?.resetToken()
    }
    
    private func getUserInfo() {
        guard let isValidToken = instance?.isValidAccessTokenExpireTimeNow(),
              isValidToken else {
            print("토큰이 유효하지 않습니다. 로그인이 필요합니다.")
            return
        }
        guard let tokenType = instance?.tokenType,
              let accessToken = instance?.accessToken else {
            print("토큰 정보가 없습니다.")
            return
        }
        
        repository.getUserInfo(tokenType: tokenType, accessToken: accessToken)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] response in
                self?.delegate?.didFinishLogin(
                    id: response.value.id,
                    email: response.value.email
                )
                self?.firebaseLogin(email: response.value.email, id: response.value.id)
            }, onFailure: { [weak self] error in
                self?.delegate?.didFailLogin(with: error)
            })
            .disposed(by: disposeBag)
    }
    
    private func firebaseLogin(email: String, id: String) {
        let password = "NAVER_\(id)"
        
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let _ = error {
                // 계정이 없는 경우 새로 생성
                Auth.auth().createUser(withEmail: email, password: password) { _, createError in
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

extension NaverAuthManager: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공")
        self.getUserInfo()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 토큰 갱신 성공")
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그인 연동 해제 성공")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: (any Error)!) {
        print("에러 : \(error.localizedDescription)")
        delegate?.didFailLogin(with: error)
    }
}
