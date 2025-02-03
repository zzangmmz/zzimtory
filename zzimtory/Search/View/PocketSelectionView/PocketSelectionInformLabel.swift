//
//  PocketSelectionInformLabel.swift
//  zzimtory
//
//  Created by 김하민 on 2/2/25.
//

import UIKit
import SnapKit

final class PocketSelectionInformLabel: UIView {
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "arrow.down.circle.fill")
        imageView.tintColor = .blue700Zt
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        
        label.text = "주머니를 선택해주세요!"
        
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(label)
        
        icon.snp.makeConstraints { make in
            make.leading.verticalEdges.centerY.equalToSuperview()
            make.width.equalTo(icon.snp.height)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(8)
            make.verticalEdges.equalToSuperview()
            make.centerY.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TO-DO: 좀 더 세련된 애니메이션으로 구성하기...
    func userDidPutItem(in pocket: Pocket, onComplete: @escaping () -> Void) {
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 1.0
        scaleDown.toValue = 0.1
        scaleDown.duration = 0.1
        scaleDown.fillMode = .both
        scaleDown.isRemovedOnCompletion = false
        
        // 함수가 클래스에 종속되어 있기에 weak 대신 unowned로 클로저 캡쳐 진행.
        CATransaction.setCompletionBlock { [unowned self] in
            self.icon.image = UIImage(systemName: "checkmark.circle.fill")
            self.label.text = "\(pocket.title)에 넣기 완료!"
            
            let scaleUp = CABasicAnimation(keyPath: "transform.scale")
            scaleUp.fromValue = 0.1
            scaleUp.toValue = 1.0
            scaleUp.duration = 0.1
            scaleUp.fillMode = .both
            scaleUp.isRemovedOnCompletion = false
            
            self.icon.layer.add(scaleUp, forKey: "scaleUp")
            self.label.layer.add(scaleUp, forKey: "scaleUp")
        }
        
        icon.layer.add(scaleDown, forKey: "scaleDown")
        label.layer.add(scaleDown, forKey: "scaleDown")
        
        // 0.5초 뒤에 onComplete로 전달받은 클로저를 실행하게 해줍니다.
        // PocketSelectionViewController에서 self.dismiss를 사용해서 모달을 내려줍니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            onComplete()
        }
    }
}
