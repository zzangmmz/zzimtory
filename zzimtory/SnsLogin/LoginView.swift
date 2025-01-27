//
//  LoginView.swift
//  zzimtory
//
//  Created by 이명지 on 1/27/25.
//

import UIKit

final class LoginView: ZTView {
    private let appleLoginButton = LoginButton(type: .apple)
    private let googleLoginButton = LoginButton(type: .google)
    private let kakaoLoginButton = LoginButton(type: .kakao)
    private let naverLoginButton = LoginButton(type: .naver)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [appleLoginButton,
                                                       googleLoginButton,
                                                       kakaoLoginButton,
                                                       naverLoginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
}
