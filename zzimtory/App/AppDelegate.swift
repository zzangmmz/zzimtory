//
//  AppDelegate.swift
//  zzimtory
//
//  Created by 이명지 on 1/20/25.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import GoogleSignIn
import KakaoSDKCommon
import RxKakaoSDKAuth
import KakaoSDKAuth
import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        GoogleAuthManager.shared.configure()
        
        // 파이어베이스 참조 설정
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        KakaoSDK.initSDK(appKey: AuthClientID.nativeAppKey)
        
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        instance?.isNaverAppOauthEnable = true  // 네이버 앱으로 인증
        instance?.isInAppOauthEnable = true     // 사파리로 인증
        instance?.setOnlyPortraitSupportInIphone(true)  // 세로모드에서만 활성화
        
        // 로그인 설정
        instance?.serviceUrlScheme = "Wlaxhfldbdkfdpftmzla52" // 콜백을 받을 URL Scheme
        instance?.consumerKey = APIKey.clientID  // 애플리케이션에서 사용하는 클라이언트 아이디
        instance?.consumerSecret = APIKey.clientSecret  // 애플리케이션에서 사용하는 클라이언트 시크릿
        instance?.appName = "zzimtory"  // 애플리케이션 이름
        
        return true
    }
    
    func application(_ app: UIApplication,
                    open url: URL,
                    options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.rx.handleOpenUrl(url: url)
        }
        else if (url.scheme?.contains("Wlaxhfldbdkfdpftmzla52") ?? false) {
            NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
            return true
        }
        else {
            return GIDSignIn.sharedInstance.handle(url)
        }
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
