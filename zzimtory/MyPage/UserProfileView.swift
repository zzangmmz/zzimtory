//
//  UserProfileView.swift
//  zzimtory
//
//  Created by 김하민 on 2/5/25.
//

import UIKit
import SnapKit

protocol UserProfileViewDelegate: AnyObject {
    func didTapUserProfile()
}

final class UserProfileView: UIView {
    
    weak var delegate: UserProfileViewDelegate?
    
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
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray600Zt
        imageView.isHidden = true
        
        return imageView
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white100Zt
        layer.cornerRadius = 15
        
        addComponents()
        setConstraints()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI functions
    func setGreeting(for userName: String) {
        arrowImageView.isHidden = true  // 회원일 때는 화살표 숨기기
        guard userName != "" else {
            greetingLabel.text = "찜토리 사용자님 안녕하세요!"
            return
        }
        greetingLabel.text = "\(userName)님 안녕하세요!"
    }
    
    func setEmailAddress(to address: String) {
        emailAdressLabel.text = "\(address)"
    }
    
    // 비회원 상태일 때
    func setForGuest() {
        // 비회원일 때는 greetingLabel가 Y축 중앙에 오도록
        greetingLabel.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-10)
            make.height.equalTo(20)
        }
        
        greetingLabel.text = "로그인이 필요합니다."
        emailAdressLabel.text = ""
        arrowImageView.isHidden = false  // 비회원일 때는 화살표 보이기
    }
    
    private func addComponents() {
        addSubview(greetingLabel)
        addSubview(emailAdressLabel)
        addSubview(arrowImageView)
    }
    
    private func setConstraints() {
        greetingLabel.snp.makeConstraints { make in
            make.bottom.equalTo(snp.centerY)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-10)
            make.height.equalTo(20)
        }
        
        emailAdressLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.centerY)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-10)
            make.height.equalTo(20)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(20)
        }
    }
}

// 비회원 상태에서 눌렀을 때 로그인 화면으로 이동
extension UserProfileView {
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        delegate?.didTapUserProfile()
    }
}
