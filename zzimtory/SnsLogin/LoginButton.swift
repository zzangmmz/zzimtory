//
//  LoginButton.swift
//  zzimtory
//
//  Created by 이명지 on 1/27/25.
//

import UIKit

struct SnsStyle {
    let name: String
    let color: UIColor?
    let icon: UIImage?
}

enum SnsType {
    case apple
    case google
    case kakao
    case naver
    
    var style: SnsStyle {
        switch self {
        case .apple:
            return SnsStyle(name: "애플", color: UIColor(named: "appleColor"), icon: UIImage(systemName: "apple.logo"))
        case .google:
            return SnsStyle(name: "구글", color: UIColor(named: "googleColor"), icon: UIImage(named: "googleIcon"))
        case .kakao:
            return SnsStyle(name: "카카오", color: UIColor(named: "kakaoColor"), icon: UIImage(named: "kakaoIcon"))
        case .naver:
            return SnsStyle(name: "네이버", color: UIColor(named: "naverColor"), icon: UIImage(named: "naverIcon"))
        }
    }
}

final class LoginButton: UIButton {
    init(type: SnsType) {
        super.init(frame: .zero)
        var config = UIButton.Configuration.filled()
        config.title = "\(type.style.name)(으)로 시작하기"
        config.image = type.style.icon
        config.imagePlacement = .leading
        config.baseBackgroundColor = type.style.color
        config.baseForegroundColor = (type == .apple || type == .naver) ? .white : .black
        config.cornerStyle = .medium
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
