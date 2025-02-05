//
//  UserProfileView.swift
//  zzimtory
//
//  Created by 김하민 on 2/5/25.
//

import UIKit
import SnapKit

final class UserProfileView: UIView {
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black900Zt
        
        return label
    }()
    
    private let emailAdressLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .gray600Zt
        
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        DatabaseManager.shared.readUserProfile { response in
            guard let nickname = response?.nickname,
                  let email = response?.email else { return }
            
            self.greetingLabel.text = "\(nickname)님 안녕하세요!"
            self.emailAdressLabel.text = "\(email)"
        }
        
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI functions
    private func addComponents() {
        addSubview(greetingLabel)
        addSubview(emailAdressLabel)
    }
    
    private func setConstraints() {
        greetingLabel.snp.makeConstraints { make in
            make.snp.bottom.
        }
    }
}
