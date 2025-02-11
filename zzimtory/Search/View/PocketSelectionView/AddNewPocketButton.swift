//
//  AddNewPocketButton.swift
//  zzimtory
//
//  Created by 김하민 on 2/2/25.
//

import UIKit
import SnapKit

final class AddNewPocketButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage(systemName: "folder.badge.plus")?.withTintColor(.black900Zt)
        config.imagePadding = 8
        config.imagePlacement = .top
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        
        config.title = "새 주머니 추가"
        config.titleAlignment = .center
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var newAttributes = attributes
            
            newAttributes.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            newAttributes.foregroundColor = UIColor.black900Zt
            
            return newAttributes
        }
        
        configuration = config
        
        tintColor = .black900Zt
        contentHorizontalAlignment = .fill
        titleLabel?.numberOfLines = 1
    }
    
}
