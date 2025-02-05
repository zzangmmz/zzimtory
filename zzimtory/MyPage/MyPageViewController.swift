//
//  MyPageViewController.swift
//  zzimtory
//
//  Created by 김하민 on 2/5/25.
//

import UIKit
import SnapKit

final class MyPageViewController: UIViewController {
    
    let tableViewContents: [(name: String, color: UIColor)] = [
        ("이용약관", .black900Zt),
        ("로그아웃", .black900Zt),
        ("탈퇴하기", .systemRed)
    ]
    
    // MARK: - UI Components
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "app.gift")
        
        return imageView
    }()
    
    private let userProfileView = UserProfileView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        DatabaseManager.shared.readUserProfile { [weak self] response in
            guard let nickname = response?.nickname,
                  let email = response?.email else { return }
            self?.userProfileView.setGreeting(for: nickname)
            self?.userProfileView.setEmailAddress(to: email)
        }
        
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().inset(24)
            make.width.height.equalTo(40)
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
        
        cell.textLabel?.text = content.name
        cell.textLabel?.textColor = content.color
        cell.backgroundColor = .white100Zt
        
        
        return cell
    }
    
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = tableViewContents[indexPath.item]
        
        print(content.name)
    }
}
