//
//  MainViewController.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/24/25.
//

import UIKit

class MainViewController: UIViewController {
    
    private let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        mainView.addPocketButton.addTarget(self, action: #selector(addPocketButtonDidTap), for: .touchUpInside)
    }
    
    @objc private func addPocketButtonDidTap() {
        let alert = UIAlertController(title: "주머니 만들기", message: "새 주머니를 입력하세요.", preferredStyle: .alert)
        alert.addTextField {textField in textField.placeholder = "새 주머니 이름"}
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
}
