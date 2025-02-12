//
//  LoginButton.swift
//  zzimtory
//
//  Created by 이명지 on 1/27/25.
//

import UIKit

struct ButtonStyle {
    let title: String
    let backgroundColor: UIColor?
    let foregroundColor: UIColor?
    let icon: UIImage?
}

enum SNS {
    case apple
    case google
    case kakao
    case naver
    
    var style: ButtonStyle {
        switch self {
        case .apple:
            return ButtonStyle(title: "Apple", backgroundColor: UIColor(named: "appleColor"), icon: UIImage(named: "appleIcon"))
        case .google:
            return ButtonStyle(title: "Google", backgroundColor: UIColor(named: "googleColor"), icon: UIImage(named: "googleIcon"))
        case .kakao:
            return ButtonStyle(title: "Kakao", backgroundColor: UIColor(named: "kakaoColor"), icon: UIImage(named: "kakaoIcon"))
        case .naver:
            return ButtonStyle(title: "Naver", backgroundColor: UIColor(named: "naverColor"), icon: UIImage(named: "naverIcon"))
        }
    }
}

final class LoginButton: UIButton {
    init(type: SNS) {
        super.init(frame: .zero)
        var config = UIButton.Configuration.filled()
        
        var finalImage = type.style.icon
        if type != .apple { // 애플은 SF Symbol 사용하므로 제외
            let size = CGSize(width: 28, height: 28)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            type.style.icon?.draw(in: CGRect(origin: .zero, size: size))
        } else {
            let width = 28.0
            let image = UIImage(named: "appleIcon")
            let aspectRatio = (image?.size.height ?? 1.0) / (image?.size.width ?? 1.0)
            let height = width * aspectRatio
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0.0)
            image?.draw(in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        }
        
        finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        config.attributedTitle = AttributedString("\(type.style.title)로 로그인",
                                                  attributes: AttributeContainer([
                                                    .font: UIFont.systemFont(ofSize: 19, weight: .semibold)
                                                  ]))
        config.image = finalImage
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.baseBackgroundColor = type.style.backgroundColor
        config.baseForegroundColor = (type == .apple || type == .naver) ? .white : .black
        config.cornerStyle = .medium
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
