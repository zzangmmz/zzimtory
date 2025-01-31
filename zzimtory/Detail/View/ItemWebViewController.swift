//
//  ItemWebViewController.swift
//  zzimtory
//
//  Created by seohuibaek on 1/28/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ItemWebViewController: UIViewController {
    private let itemWebView = ItemWebView()
    private let urlString: String
    private let disposeBag = DisposeBag()
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = itemWebView
        
        setupNavigationBar()
        loadURL()
        bind()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: configureNavigationButton(
            imageName: "chevron.left",
            action: #selector(backButtonTapped)
        ))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: configureNavigationButton(
            imageName: "safari",
            action: #selector(safariButtonTapped)
        ))
    }
    
    private func configureNavigationButton(imageName: String, action: Selector) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setAsIconButton()
        button.setButtonDefaultImage(imageName: imageName)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func loadURL() {
        guard let url = URL(string: urlString) else { return }
        itemWebView.itemWebView.load(URLRequest(url: url))
    }
    
    private func bind() {
        itemWebView.saveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.saveToPocket()
            })
            .disposed(by: disposeBag)
    }
    
    private func saveToPocket() {
        print("주머니에 저장됨")
    }
    
    @objc private func backButtonTapped() {
        // 모달 닫기
        // dismiss(animated: true)
        
        // 화면 전환
        guard let navigationController = self.navigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    @objc private func safariButtonTapped() {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
