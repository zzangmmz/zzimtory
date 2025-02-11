//
//  ZTView.swift
//  zzimtory
//
//  Created by 김하민 on 1/24/25.
//

import UIKit

class ZTView: UIView {

    private let topColor = UIColor.backgroundGradientTop
    private let bottomColor = UIColor.backgroundGradientBottom
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        
        layer.frame = self.bounds
        layer.startPoint = CGPoint(x: 1.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        return layer
    }()
    
    private func changeGradient() {
        // Assets의 컬러는 UIColor이므로, .cgColor 프로퍼티로 CGColor를 반환.
        let colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.colors = colors
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        changeGradient()
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
            changeGradient()
        }
    }
}
