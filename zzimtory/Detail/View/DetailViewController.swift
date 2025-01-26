//
//  DetailViewController.swift
//  zzimtory
//
//  Created by seohuibaek on 1/24/25.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    private lazy var detailView = DetailView(frame: view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = detailView
        
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        // 네비게이션 바를 투명하게 설정
//        let barAppearance = UINavigationBarAppearance()
//        barAppearance.configureWithTransparentBackground()
//        barAppearance.backgroundColor = .clear
//
//        navigationItem.scrollEdgeAppearance = barAppearance
//        navigationItem.compactScrollEdgeAppearance = barAppearance
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        
        // 커스텀 백버튼 생성
        let customBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        customBackButton.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        customBackButton.layer.cornerRadius = 20
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        customBackButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        customBackButton.tintColor = .black
        
        customBackButton.layer.shadowColor = UIColor.black.cgColor
        customBackButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        customBackButton.layer.shadowRadius = 4
        customBackButton.layer.shadowOpacity = 0.2
        
        customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // 네비게이션 아이템으로 설정
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customBackButton)
    }

    @objc private func backButtonTapped() {
       navigationController?.popViewController(animated: true)
    }
}
