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
            return SnsStyle(name: "Apple", color: UIColor(named: "appleColor"), icon: UIImage(named: "appleIcon"))
        case .google:
            return SnsStyle(name: "Google", color: UIColor(named: "googleColor"), icon: UIImage(named: "googleIcon"))
        case .kakao:
            return SnsStyle(name: "Kakao", color: UIColor(named: "kakaoColor"), icon: UIImage(named: "kakaoIcon"))
        case .naver:
            return SnsStyle(name: "Naver", color: UIColor(named: "naverColor"), icon: UIImage(named: "naverIcon"))
        }
    }
}

final class LoginButton: UIButton {
    init(type: SnsType) {
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
        
        config.attributedTitle = AttributedString("\(type.style.name)로 로그인",
                                                  attributes: AttributeContainer([
                                                    .font: UIFont.systemFont(ofSize: 19, weight: .semibold)
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
