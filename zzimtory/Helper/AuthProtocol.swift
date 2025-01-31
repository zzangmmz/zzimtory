//
//  AuthProtocol.swift
//  zzimtory
//
//  Created by 이명지 on 1/31/25.
//

/// 파이어베이스에서 제공하는 로그인 과정 추상화
protocol NativeAuthProtocol: AnyObject {
    func login()
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
