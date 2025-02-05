//
//  TabbarViewController.swift
//  zzimtory
//
//  Created by seohuibaek on 2/5/25.
//

import UIKit

final class TabbarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabBarItem()
    }
}

private extension TabbarViewController {
    func setupTabBar() {
        // iOS 13 이상부터 탭바 스타일 설정
        let appearanceTabbar = UITabBarAppearance()
        appearanceTabbar.configureWithOpaqueBackground()
        appearanceTabbar.backgroundColor = .white100Zt.withAlphaComponent(0.8)
        appearanceTabbar.shadowColor = UIColor.clear // 탭바 상단 line 안보이게 설정

        // 탭바 아이템 텍스트 색상 설정
        appearanceTabbar.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray300Zt
        ]
        appearanceTabbar.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.black900Zt
        ]
        
        // 탭바 아이콘 색상 설정
        appearanceTabbar.stackedLayoutAppearance.selected.iconColor = UIColor.black900Zt
        
        tabBar.standardAppearance = appearanceTabbar
        tabBar.scrollEdgeAppearance = appearanceTabbar
    }
    
    // 각각 네비게이션컨트롤러 지정
    func setupTabBarItem() {
        let mainVC = MainViewController()
        let mainNavVC = UINavigationController(rootViewController: mainVC)
        mainNavVC.tabBarItem = UITabBarItem(title: "주머니",
                                            image: UIImage(named: "PocketIcon"),
                                            selectedImage: UIImage(named: "PocketIcon"))
        
        let searchVC = ItemSearchViewController()
        let searchNavVC = UINavigationController(rootViewController: searchVC)
        searchNavVC.tabBarItem = UITabBarItem(title: "검색",
                                              image: UIImage(systemName: "magnifyingglass"),
                                              selectedImage: UIImage(systemName: "magnifyingglass"))
        
        let myPageVC = MyPageViewController()
        let myPageNavVC = UINavigationController(rootViewController: myPageVC)
        myPageNavVC.tabBarItem = UITabBarItem(title: "마이페이지",
                                              image: UIImage(systemName: "person.fill"),
                                              selectedImage: UIImage(systemName: "person.fill"))
        
        viewControllers = [mainNavVC, searchNavVC, myPageNavVC]
    }
}
