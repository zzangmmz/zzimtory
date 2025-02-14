//
//  MyPageViewController.swift
//  zzimtory
//
//  Created by 김하민 on 2/5/25.
//

import UIKit
import SnapKit

enum MyPageContents: String {
    case faq = "자주 묻는 질문"
    case support = "1:1 문의하기"
    case terms = "이용약관"
    case versionInfo = "버전 정보"
    case login = "로그인"
    case logOut = "로그아웃"
    case deleteAccount = "탈퇴하기"
}

final class MyPageViewController: UIViewController {
    
    private let viewModel = MyPageViewModel()
    
    private var isLoggedIn: Bool {
        return DatabaseManager.shared.hasUserLoggedIn()
    }
    
    private var tableViewContents: [(name: MyPageContents, color: UIColor)] {
        if isLoggedIn {
            return [
                (.faq, .black900Zt),
                (.support, .black900Zt),
                (.terms, .black900Zt),
                (.versionInfo, .black900Zt),
                (.logOut, .black900Zt),
                (.deleteAccount, .systemRed)
            ]
        } else {
            return [
                (.faq, .black900Zt),
                (.support, .black900Zt),
                (.terms, .black900Zt),
                (.versionInfo, .black900Zt),
                (.login, .black900Zt)
            ]
        }
    }
    
    // MARK: - UI Components
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black900Zt
        return imageView
    }()
    
    private let userProfileView = UserProfileView()
    private var recentItemsView = RecentItemsView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        checkUserState()
        loadRecentItems()
        tableView.reloadData()
    }
    
    private func loadRecentItems() {
        // 뷰모델에서 유저디폴트로 아이템 받아오기
        viewModel.loadItems()
        recentItemsView.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileView.delegate = self
        
        view = ZTView(frame: view.frame)
        
        addComponents()
        setCollectionView()
        setTableView()
        setConstraints()
    }
    
    private func addComponents() {
        [
            logoImageView,
            recentItemsView,
            userProfileView,
            tableView
        ].forEach { view.addSubview($0) }
    }
    
    private func setCollectionView() {
        recentItemsView.collectionView.delegate = self
        recentItemsView.collectionView.dataSource = self
        recentItemsView.collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setTableView() {
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorInset = .zero
        
        tableView.layoutIfNeeded()
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
        
        recentItemsView.snp.makeConstraints { make in
            make.top.equalTo(userProfileView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(140)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(recentItemsView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(tableView.contentSize.height).priority(.low)
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
        
        // 마지막 셀만 separator 없애기
        if indexPath.row == tableViewContents.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        // 셀 윗부분 & 아랫부분 radius 처리
        if indexPath.row == 0 || indexPath.row == tableViewContents.count - 1 {
            cell.layer.cornerRadius = 15
            cell.layer.maskedCorners = indexPath.row == 0
            ? [.layerMinXMinYCorner, .layerMaxXMinYCorner]  // 첫 번째 셀 (왼쪽 위 / 오른쪽 위)
            : [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]  // 마지막 셀
            cell.layer.masksToBounds = true
        }
        
        return cell
    }
    
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedContent = tableViewContents[indexPath.item]
        
        switch selectedContent.name {
        case .faq:
            break
        case .support:
            break
        case .terms: navigationController?.pushViewController(TermsOfService(), animated: true)
        case .versionInfo:
            break
        case .login:
            pushToLoginView()
        case .logOut:
            GoogleAuthManager().logout()
            KakaoAuthManager().logout()
            NaverAuthManager().logout()
            AppleAuthManager().logout()
            DatabaseManager.shared.logout()
            
            pushToLoginView()
        case .deleteAccount:
            GoogleAuthManager().logout()
            KakaoAuthManager().logout()
            NaverAuthManager().logout()
            AppleAuthManager().logout()
            DatabaseManager.shared.deleteUser()
            DatabaseManager.shared.logout()
            
            pushToLoginView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}

extension MyPageViewController {
    // 유저 상태에 따른 UserProfileView 설정
    private func checkUserState() {
        if isLoggedIn {
            DatabaseManager.shared.readUserProfile { [weak self] response in
                guard let nickname = response?.nickname,
                      let email = response?.email else { return }
                self?.userProfileView.setGreeting(for: nickname)
                self?.userProfileView.setEmailAddress(to: email)
            }
        } else {
            userProfileView.setForGuest()
        }
        recentItemsView.togglePlaceHolder(with: viewModel.recentItems.isEmpty)
    }
    
    // 로그인뷰로 이동
    private func pushToLoginView() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}

// MARK: - UserProfileViewDelegate
extension MyPageViewController: UserProfileViewDelegate {
    func didTapUserProfile() {
        guard !isLoggedIn else { return } // 로그인 상태라면 실행 안 함
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}

extension MyPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recentItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: RecentItemCell.self),
            for: indexPath
        ) as? RecentItemCell else {
            return UICollectionViewCell()
        }
        
        let item = viewModel.recentItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}
