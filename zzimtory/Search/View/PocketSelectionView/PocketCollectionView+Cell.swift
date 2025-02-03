//
//  PocketCollectionView+Cell.swift
//  zzimtory
//
//  Created by 김하민 on 2/3/25.
//

import UIKit
import SnapKit

final class PocketCollectionView: UICollectionView {
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        self.init(frame: .zero, collectionViewLayout: layout)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class PocketCollectionViewCell: UICollectionViewCell {
    
    static let id = "PocketCollectionViewCell"
    
    // MARK: - Cell components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "gift")
        imageView.tintColor = .black900Zt
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = false
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black900Zt
        label.numberOfLines = 2
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI functions
    func setCell(with pocket: Pocket) {
        titleLabel.text = pocket.title
    }
    
    private func setUI() {
        contentView.backgroundColor = .white100Zt
        
        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(1.6)
        }

    }

}
