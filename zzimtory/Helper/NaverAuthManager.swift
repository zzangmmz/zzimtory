//
//  NaverAuthManager.swift
//  zzimtory
//
//  Created by 이명지 on 1/30/25.
//

import NaverThirdPartyLogin
import Alamofire

final class NaverAuthManager: NSObject {
    
    let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override init() {
        super.init()
        instance?.delegate = self
    }
    
    func login() {
        instance?.requestThirdPartyLogin()
    }
    
    func logout() {
        instance?.resetToken()
    }
    
    func getNaverUserInfo() {
    }
}

extension NaverAuthManager: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공")
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
