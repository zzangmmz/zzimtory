//
//  LoginView.swift
//  zzimtory
//
//  Created by 이명지 on 1/27/25.
//

import UIKit
import SnapKit

final class LoginView: ZTView {
        
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black900Zt
        return imageView
    }()
    
    private(set) var appleCustomLoginButton = LoginButton(sns: .apple)
    private(set) var googleLoginButton = LoginButton(sns: .google)
    private(set) var kakaoLoginButton = LoginButton(sns: .kakao)
    private(set) var naverLoginButton = LoginButton(sns: .naver)
    
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
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(1.0)
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
