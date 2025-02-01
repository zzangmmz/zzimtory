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
        
        // 에셋에 추가한 아이콘들 리사이징 필요
        var finalImage = type.style.icon
        if type != .apple { // 애플은 SF Symbol 사용하므로 제외
            let size = CGSize(width: 30, height: 30)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            type.style.icon?.draw(in: CGRect(origin: .zero, size: size))
            finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        config.attributedTitle = AttributedString("\(type.style.name)로 시작하기",
                                                  attributes: AttributeContainer([
                                                    .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
                                                  ]))
        config.image = finalImage
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.baseBackgroundColor = type.style.color
        config.baseForegroundColor = (type == .apple || type == .naver) ? .white : .black
        config.cornerStyle = .medium
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
