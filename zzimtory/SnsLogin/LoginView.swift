//
//  LoginView.swift
//  zzimtory
//
//  Created by 이명지 on 1/27/25.
//

import UIKit
import SnapKit
import AuthenticationServices

final class LoginView: ZTView {
    private(set) var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        return button
    }()
    
    private(set) var appleCustumLoginButton = LoginButton(type: .apple)
    private(set) var googleLoginButton = LoginButton(type: .google)
    private(set) var kakaoLoginButton = LoginButton(type: .kakao)
    private(set) var naverLoginButton = LoginButton(type: .naver)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [// appleLoginButton,
            appleCustumLoginButton,
            googleLoginButton,
            kakaoLoginButton,
            naverLoginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(stackView)
        
        stackView.arrangedSubviews.forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(52)
            }
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
    }
}
