//
//  TermsOfServiceViewController.swift
//  zzimtory
//
//  Created by 이명지 on 2/14/25.
//

import UIKit
import WebKit
import SnapKit

final class TermsOfServiceViewController: UIViewController {
    private let webView = WKWebView()
    private let url = URL(string: "https://soywork.notion.site/195ee0798c97805fa881c12f177da8f8?pvs=4")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white100Zt
        
        setupNavigationBar()
        setupWebView()
        loadURL()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(back)
        )
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints {
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    private func loadURL() {
        guard let url = url else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc
    private func back() {
        navigationController?.popViewController(animated: true)
    }
}
