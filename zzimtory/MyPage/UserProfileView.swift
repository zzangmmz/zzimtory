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
        
        backgroundColor = .white100Zt
        layer.cornerRadius = 15
        
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI functions
    func setGreeting(for userName: String) {
        guard userName != "" else {
            greetingLabel.text = "찜토리 사용자님 안녕하세요!"
            return
        }
        
        greetingLabel.text = "\(userName)님 안녕하세요!"
    }
    
    func setEmailAddress(to address: String) {
        emailAdressLabel.text = "\(address)"
    }
    
    private func addComponents() {
        addSubview(greetingLabel)
        addSubview(emailAdressLabel)
    }
    
    private func setConstraints() {
        greetingLabel.snp.makeConstraints { make in
            make.bottom.equalTo(snp.centerY)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        emailAdressLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.centerY)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
    }
}
