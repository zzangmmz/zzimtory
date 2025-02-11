//
//  MyPageViewController.swift
//  zzimtory
//
//  Created by 김하민 on 2/5/25.
//

import UIKit
import SnapKit

enum MyPageContents: String {
    case terms = "이용약관"
    case logOut = "로그아웃"
    case deleteAccount = "탈퇴하기"
}

final class MyPageViewController: UIViewController {
    
    private let tableViewContents: [(name: MyPageContents, color: UIColor)] = [
        (.terms, .black900Zt),
        (.logOut, .black900Zt),
        (.deleteAccount, .systemRed)
    ]
    
    // MARK: - UI Components
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black900Zt
        return imageView
    }()
    
    private let userProfileView = UserProfileView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        DatabaseManager.shared.readUserProfile { [weak self] response in
            guard let nickname = response?.nickname,
                  let email = response?.email else { return }
            self?.userProfileView.setGreeting(for: nickname)
            self?.userProfileView.setEmailAddress(to: email)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = ZTView(frame: view.frame)
        
        addComponents()
        setTableView()
        setConstraints()
    }
    
    private func addComponents() {
        [
            logoImageView,
            userProfileView,
            tableView
        ].forEach { view.addSubview($0) }
    }
    
    private func setTableView() {
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false

        tableView.layer.cornerRadius = 15
    }
    
    private func setConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(40)
        }
        
        userProfileView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(74)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(userProfileView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(userProfileView.snp.bottom).offset(158)
        }
        
    }
    
}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: String(describing: UITableViewCell.self))
        
        let content = tableViewContents[indexPath.item]
        
        cell.textLabel?.text = content.name.rawValue
        cell.textLabel?.textColor = content.color
        cell.backgroundColor = .white100Zt
        
        return cell
    }
    
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedContent = tableViewContents[indexPath.item]
        
        switch selectedContent.name {
        case .terms: navigationController?.pushViewController(TermsOfService(), animated: true)
        case .logOut:
            GoogleAuthManager().logout()
            KakaoAuthManager().logout()
            NaverAuthManager().logout()
            AppleAuthManager().logout()
            DatabaseManager.shared.logout()
        case .deleteAccount:
            GoogleAuthManager().logout()
            KakaoAuthManager().logout()
            NaverAuthManager().logout()
            AppleAuthManager().logout()
            DatabaseManager.shared.deleteUser()
            DatabaseManager.shared.logout()
        }
        
    }
}
