//
//  SearchHistoryHeader.swift
//  zzimtory
//
//  Created by 김하민 on 2/18/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchHistoryHeader: UIView {

    // MARK: - UI Components
    private let recentSearchLabel: UILabel = {
        let label = UILabel()
        
        label.text = "최근 검색어"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black900Zt
        label.textAlignment = .left
        
        return label
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.gray700Zt, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        button.contentVerticalAlignment = .bottom

        
        return button
    }()
    
//    let headerLabel: UILabel = {
//        let label = UILabel()
//        
//        label.text = "최근 검색어"
//        label.font = .systemFont(ofSize: 16, weight: .bold)
//        label.textColor = .black900Zt
//        label.textAlignment = .left
//        
//        return label
//    }()
//    
//    view.addSubview(headerLabel)
//    
//    headerLabel.snp.makeConstraints { make in
//        make.horizontalEdges.equalToSuperview()
//        make.height.equalTo(50)
//    }
//    
//    headerLabel.setNeedsLayout()
//    headerLabel.layoutIfNeeded()
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    private func addComponents() {
        addSubview(recentSearchLabel)
        addSubview(clearButton)
    }
    
    private func setConstraints() {
        recentSearchLabel.snp.makeConstraints { make in
            make.left.height.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        clearButton.snp.makeConstraints { make in
            make.right.bottom.height.equalToSuperview()
        }
    }
    
    func tappedClearHistory() -> ControlEvent<Void> {
        clearButton.rx.tap
    }
}
