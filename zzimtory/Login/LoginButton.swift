//
//  LoginButton.swift
//  zzimtory
//
//  Created by 이명지 on 1/27/25.
//

import UIKit
import RxSwift
import RxCocoa

enum SNS: String {
    case apple
    case google
    case kakao
    case naver
    
    var title: String {
        "\(rawValue.capitalized)로 로그인"
    }
    
    var backgroundColor: UIColor? {
        guard let color = UIColor(named: "\(rawValue)Color") else { return nil }
        return color
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .apple, .naver:
            return .white
        default:
            return .black
        }
    }
    
    var icon: UIImage? {
        guard let icon = UIImage(named: "\(rawValue)Icon") else { return nil }
        return icon
    }
}

final class LoginButton: UIButton {
    private var disposeBag = DisposeBag()
    let loginTapped = PublishRelay<SNS>()
    private let sns: SNS
    
    init(sns: SNS) {
        self.sns = sns
        super.init(frame: .zero)
        self.configuration = createConfiguration(sns: sns)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createConfiguration(sns: SNS) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(
            sns.title,
            attributes: AttributeContainer([
                .font: UIFont.systemFont(
                    ofSize: 19,
                    weight: .semibold
                )
            ]))
        config.image = resizeIcon(for: sns)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.baseBackgroundColor = sns.backgroundColor
        config.baseForegroundColor = sns.foregroundColor
        config.cornerStyle = .medium
        return config
    }
    
    private func resizeIcon(for sns: SNS) -> UIImage? {
        guard let originalIcon = sns.icon else { return nil }
        
        let size = sns == .apple ?
        CGSize(
            width: 28.0,
            height: 28.0 * (originalIcon.size.height / originalIcon.size.width)
        ) :
        CGSize(
            width: 28,
            height: 28
        )
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        originalIcon.draw(in: CGRect(origin: .zero, size: size))
        let resizedIcon = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedIcon
    }
}
