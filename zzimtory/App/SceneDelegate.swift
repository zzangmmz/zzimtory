//
//  SceneDelegate.swift
//  zzimtory
//
//  Created by 이명지 on 1/20/25.
//

import UIKit
import RxKakaoSDKAuth
import KakaoSDKAuth
import NaverThirdPartyLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // 로그인 상태에 따라 초기 화면 결정
        if DatabaseManager.shared.hasUserLoggedIn() {
            window.rootViewController = TabbarViewController()
        } else {
            window.rootViewController = UINavigationController(rootViewController: LoginViewController())
        }
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            } else {
                NaverThirdPartyLoginConnection
                    .getSharedInstance()
                    .receiveAccessToken(url)
            }
        }
    }
}
