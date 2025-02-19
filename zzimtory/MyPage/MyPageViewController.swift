//
//  MyPageViewController.swift
//  zzimtory
//
//  Created by 김하민 on 2/5/25.
//

import UIKit
import SnapKit
import MessageUI

enum MyPageContents: String {
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
                (.support, .black900Zt),
                (.terms, .black900Zt),
                (.versionInfo, .black900Zt),
                (.logOut, .black900Zt),
                (.deleteAccount, .systemRed)
            ]
        } else {
            return [
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
        navigationController?.tabBarController?.tabBar.isHidden = false

        checkUserState()
        loadRecentItems()
        tableView.reloadData()
    }
    
    private func loadRecentItems() {
        viewModel.loadItems()
        
        if viewModel.recentItems.isEmpty {
            recentItemsView.showPlaceHolderLabel()
        } else {
            recentItemsView.hidePlaceHolderLabel()
        }
        
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
            make.height.equalTo(170)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(recentItemsView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(tableView.contentSize.height).priority(.low)
        }
        
    }
    
    private func showAlert(title: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { _ in
            completion()
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: String(describing: UITableViewCell.self))
        
        let content = tableViewContents[indexPath.item]
        
        cell.textLabel?.text = content.name.rawValue
        cell.textLabel?.textColor = content.color
        cell.backgroundColor = .white100Zt
        
        if content.name == .versionInfo {
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                cell.detailTextLabel?.text = version
                cell.detailTextLabel?.textColor = .gray500Zt
                cell.detailTextLabel?.textAlignment = .right
            }
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
        }
        
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
        case .support:
            showEmailComposer()
        case .terms: navigationController?.pushViewController(TermsOfServiceViewController(), animated: true)
        case .versionInfo:
            break
        case .login:
            pushToLoginView()
        case .logOut:
            showAlert(title: "로그아웃 하시겠습니까?") { [weak self] in
                GoogleAuthManager().logout()
                KakaoAuthManager().logout()
                NaverAuthManager().logout()
                AppleAuthManager().logout()
                DatabaseManager.shared.logout()
                
                self?.pushToLoginView()
            }
        case .deleteAccount:
            showAlert(title: "탈퇴 하시겠습니까?") { [weak self] in
                GoogleAuthManager().logout()
                KakaoAuthManager().logout()
                NaverAuthManager().logout()
                AppleAuthManager().logout()
                DatabaseManager.shared.deleteUser()
                DatabaseManager.shared.logout()
                
                self?.pushToLoginView()
            }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = viewModel.recentItems[indexPath.item]
        let detailVC = ItemDetailViewController(items: [selectedItem], currentIndex: 0)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MyPageViewController:  MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    private func showEmailComposer() {
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients(["zzimtory@gmail.com"])
            composer.setSubject("[찜토리] 1:1 문의")
            
            let messageBody = """
                앱 버전: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
                기기: \(UIDevice.current.model)
                iOS 버전: \(UIDevice.current.systemVersion)
                
                문의 내용:
                
                """
            composer.setMessageBody(messageBody, isHTML: false)
            
            present(composer, animated: true)
        } else {
            let alert = UIAlertController(title: "메일 전송 실패",
                                          message: "메일을 보낼 수 없습니다. 메일 계정이 등록되어 있는지 확인해 주세요.",
                                          preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }
}
