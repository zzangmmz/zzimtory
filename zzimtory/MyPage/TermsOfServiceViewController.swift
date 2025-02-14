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
    private let url = URL(string: "https://velog.io/@myungjilee/%EA%B0%9C%EC%9D%B8%EC%A0%95%EB%B3%B4%EC%B2%98%EB%A6%AC%EB%B0%A9%EC%B9%A8")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupWebView()
        loadURL()
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
            $0.edges.equalToSuperview()
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
