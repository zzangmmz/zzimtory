//
//  ZTView.swift
//  zzimtory
//
//  Created by 김하민 on 1/24/25.
//

import UIKit

class ZTView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgroundGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
                return
            }
            setBackgroundGradient()
        }
    }
}

extension ZTView {
    // MARK: - 배경 그라데이션 설정
    private func setBackgroundGradient() {
        
        let topColor = UIColor.backgroundGradientTop
        let bottomColor = UIColor.backgroundGradientBottom
        
        // Assets의 컬러는 UIColor이므로, .cgColor 프로퍼티로 CGColor를 반환.
        let colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        
        layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradientLayer: CAGradientLayer = {
            let layer = CAGradientLayer()
            
            layer.frame = self.bounds
            layer.colors = colors
            layer.startPoint = CGPoint(x: 1.0, y: 0.0)
            layer.endPoint = CGPoint(x: 1.0, y: 1.0)
            
            return layer
        }()

        print(self.frame)
        layer.addSublayer(gradientLayer)
    }
}
