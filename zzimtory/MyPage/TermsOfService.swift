//
//  TermsOfService.swift
//  zzimtory
//
//  Created by 김하민 on 2/5/25.
//

import UIKit
import SnapKit

final class TermsOfService: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "이용 약관"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    private let termsTextView: UITextView = {
        let textView = UITextView()
        
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent vitae neque sed odio dignissim egestas sed in odio. Etiam tincidunt lorem a nisl vestibulum, faucibus rhoncus ante scelerisque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Suspendisse nec augue massa. Ut malesuada ipsum non enim feugiat rutrum. Sed ac diam in erat gravida cursus. Sed semper augue non pharetra sagittis. Vestibulum sit amet bibendum libero. Ut mattis facilisis orci eu dignissim. Aenean condimentum pharetra odio vitae fringilla. Nunc congue libero ut viverra dictum. Morbi semper tortor ut urna tincidunt consequat. Ut et diam sed diam sollicitudin congue. Ut ornare turpis vel porta sodales. Morbi condimentum quam sed congue eleifend. Etiam non nibh velit."
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.backgroundColor = .white100Zt
        textView.layer.cornerRadius = 15
        
        textView.isEditable = false
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = ZTView(frame: view.frame)
        
        addComponents()
        setConstraints()
    }
    
    private func addComponents() {
        view.addSubview(titleLabel)
        view.addSubview(termsTextView)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges).inset(24)
            make.height.equalTo(40)
        }
        
        termsTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide.snp.horizontalEdges).inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
        }
        
    }
    
}
