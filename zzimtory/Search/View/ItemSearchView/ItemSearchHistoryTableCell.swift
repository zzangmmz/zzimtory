//
//  ItemSearchHistoryTableCell.swift
//  zzimtory
//
//  Created by 김하민 on 2/14/25.
//

import UIKit
import SnapKit

final class ItemSearchHistoryTableCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black900Zt
        
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        [titleLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.verticalEdges.equalToSuperview().inset(4)
        }
    }
    
    func setCell(with text: String) {
        titleLabel.text = text
    }
}
