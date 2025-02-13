//
//  ZTViewController.swift
//  zzimtory
//
//  Created by seohuibaek on 2/13/25.
//

import UIKit

class ZTViewController: UIViewController {

    private let topColor = UIColor.backgroundGradientTop
    private let bottomColor = UIColor.backgroundGradientBottom

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        
        layer.startPoint = CGPoint(x: 1.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        return layer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        changeGradient()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    private func changeGradient() {
        // Assets의 컬러는 UIColor이므로, .cgColor 프로퍼티로 CGColor를 반환.
        let colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.colors = colors
        
        view.layer.insertSublayer(gradientLayer, at: 0) // 가장 아래에 배경 추가
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
            changeGradient()
        }
    }
}
