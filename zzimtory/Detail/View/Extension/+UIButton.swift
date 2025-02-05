//
//  +UIButton.swift
//  zzimtory
//
//  Created by seohuibaek on 1/27/25.
//

import UIKit

extension UIButton {
    func setButtonDefaultShadow() {
        layer.shadowColor = UIColor.black900Zt.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.2
    }
    
    // 시스템이미지 사용
    func setButtonWithSystemImage(imageName: String, imageSize: CGFloat = 20) {
        let config = UIImage.SymbolConfiguration(pointSize: imageSize, weight: .medium)
        if let image = UIImage(systemName: imageName, withConfiguration: config) {
            self.setImage(image, for: .normal)
            self.tintColor = .black900Zt
        }
    }
    
    // Asset에 추가한 커스텀 이미지 사용
    func setButtonWithCustomImage(imageName: String, imageSize: CGFloat = 20) {
        let config = UIImage.SymbolConfiguration(pointSize: imageSize, weight: .medium)
        if let image = UIImage(named: imageName, in: Bundle.main, with: config) {
            self.setImage(image, for: .normal)
            self.tintColor = .black900Zt
        }
    }
    
    func setImageWithSpacing() {
        self.imageEdgeInsets = .init(top: 0, left: -8, bottom: 0, right: 0)
        self.titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
    }
    
    func setAsIconButton(size: CGFloat = 40) {
        setButtonDefaultShadow()
        backgroundColor = .systemBackground.withAlphaComponent(0.8)
        layer.cornerRadius = size / 2
        frame.size = CGSize(width: size, height: size) // 버튼 크기 설정
        layer.masksToBounds = false
    }
}
