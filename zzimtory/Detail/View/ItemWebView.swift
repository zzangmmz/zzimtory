//
//  ItemWebView.swift
//  zzimtory
//
//  Created by seohuibaek on 1/28/25.
//

import UIKit
import WebKit
import SnapKit

final class ItemWebView: UIView {
    
    // 아이템 웹뷰
    let itemWebView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        webView.allowsBackForwardNavigationGestures = true // 스와이프로 앞,뒤 페이지 이동 가능
        webView.backgroundColor = .white100Zt
        
        return webView
    }()
    
    // 페이지 뒤로가기 버튼
    private let websiteBackButton: UIButton = {
        let button = UIButton()
        
        button.setButtonWithSystemImage(imageName: ButtonImageConstants.backButtonImage)
        
        return button
    }()
    
    // 페이지 앞으로 가기 버튼
    private let websiteForwardButton: UIButton = {
        let button = UIButton()
        
        button.setButtonWithSystemImage(imageName: ButtonImageConstants.frontButtonImage)
        
        return button
    }()
    
    // 공유 버튼
    let shareButton: UIButton = {
        let button = UIButton()
        
        button.setButtonWithSystemImage(imageName: ButtonImageConstants.shareButtonImage)
        
        return button
    }()
    
    // 저장 버튼
    let saveButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("주머니에 넣기", for: .normal)
        button.backgroundColor = .blue400ZtPrimary
        button.layer.cornerRadius = 10
        
        button.setTitleColor(.black900Zt, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        
        button.setButtonWithCustomImage(imageName: ButtonImageConstants.PocketButtonImage)
        button.setImageWithSpacing()
        button.setButtonDefaultShadow()
        
        return button
    }()
    
    // [웹뷰 하단 버튼 스택뷰] 페이지 뒤로가기, 앞으로가기, 주머니에 넣기, 공유하기
    private lazy var bottomButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [websiteBackButton,
                                                       websiteForwardButton,
                                                       saveButton,
                                                       shareButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    // 인디케이터
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // 프로그레스 바
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .clear
        progressView.progressTintColor = .blue400ZtPrimary
        return progressView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white100Zt
        
        setupWebView()
        configureUI()
        configurePageButtonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupWebView() {
        itemWebView.navigationDelegate = self
    }
    
    private func configureUI() {
        [progressBar,
         itemWebView,
         bottomButtonStackView,
         activityIndicator]
            .forEach { addSubview($0) }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        progressBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }
        
        itemWebView.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomButtonStackView.snp.top).offset(-16)
        }
        
        [websiteBackButton, websiteForwardButton, shareButton].forEach { button in
            button.snp.makeConstraints { make in
                make.height.width.equalTo(30)
            }
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        bottomButtonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension ItemWebView {
    private func configurePageButtonActions() {
        websiteBackButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        websiteForwardButton.addTarget(self, action: #selector(handleForwardButton), for: .touchUpInside)
    }
    
    // 뒤로 돌아가기
    @objc private func handleBackButton() {
        itemWebView.goBack()
    }
    
    // 앞으로 돌아가기
    @objc private func handleForwardButton() {
        itemWebView.goForward()
    }
}

extension ItemWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // 원형 인디케이터
        activityIndicator.startAnimating()
        
        // 프로그레스바
        progressBar.isHidden = false
        progressBar.progress = 0.1
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 원형 인디케이터
        activityIndicator.stopAnimating()
        
        // 프로그레스바
        progressBar.progress = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.progressBar.isHidden = true
        }
    }
}
