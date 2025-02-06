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
        
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black900Zt
        return imageView
    }()
    
    private(set) var appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        return button
    }()
    
    private(set) var appleCustomLoginButton = LoginButton(type: .apple)
    private(set) var googleLoginButton = LoginButton(type: .google)
    private(set) var kakaoLoginButton = LoginButton(type: .kakao)
    private(set) var naverLoginButton = LoginButton(type: .naver)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            appleCustomLoginButton,
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
        self.addSubview(logoImageView)
        self.addSubview(stackView)
        
        logoImageView.snp.makeConstraints {make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
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
