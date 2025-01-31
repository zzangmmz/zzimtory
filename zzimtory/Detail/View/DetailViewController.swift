//
//  DetailViewController.swift
//  zzimtory
//
//  Created by seohuibaek on 1/24/25.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    private var detailView: DetailView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView = DetailView(frame: view.frame)
        self.view = detailView
        
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        // 네비게이션 바를 투명하게 설정 (시도 중)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = nil
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        
        // 커스텀 백버튼 생성
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        button.setAsIconButton()
        button.setButtonDefaultImage(imageName: "chevron.left")
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // 네비게이션 아이템으로 설정
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }

    @objc private func backButtonTapped() {
       navigationController?.popViewController(animated: true)
    }
}
