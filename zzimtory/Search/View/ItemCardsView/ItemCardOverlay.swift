//
//  ItemCardOverlay.swift
//  zzimtory
//
//  Created by 김하민 on 2/5/25.
//

import UIKit
import SnapKit

final class ItemCardOverlay: UIView {
    
    private let direction: SwipeDirection
    
    private let gestureIcon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12, weight: .light)
        
        return label
    }()
    
    init(with direction: SwipeDirection) {
        self.direction = direction
        super.init(frame: .zero)
        
        backgroundColor = .backgroundGradientBottom
        layer.cornerRadius = 16
        
        setComponents()
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        addSubview(gestureIcon)
        addSubview(descriptionLabel)
    }
    
    private func setComponents() {
        switch direction {
        case .left: 
            descriptionLabel.text = "왼쪽으로 밀어 패스!"
            gestureIcon.image = .swipeLeft
        case .right:
            descriptionLabel.text = "오른쪽으로 밀어 전체보기 주머니에 넣기!"
            gestureIcon.image = .swipeRight
        case .up:
            descriptionLabel.text = "위로 밀어 원하는 주머니에 넣기!"
            gestureIcon.image = .swipeUp
        default: break
        }
    }
    
    private func setConstraints() {
        gestureIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(snp.centerY)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalTo(gestureIcon.snp.width)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(snp.centerY).offset(24)
        }
    }
}
