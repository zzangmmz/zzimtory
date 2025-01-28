//
//  ItemCardContents.swift
//  zzimtory
//
//  Created by 김하민 on 1/27/25.
//

import UIKit
import SnapKit

final class ItemCardContents: UIView {
    
    let item: Item
    
    // MARK: - UI components
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        guard let url = URL(string: item.image) else { return imageView }
        
        imageView.loadImage(from: url)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        
        label.text = item.price
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black900Zt
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = item.title
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black900Zt
        
        return label
    }()
    
    // MARK: - Initializers
    init(item: Item) {
        self.item = item
        super.init(frame: .zero)
        
        backgroundColor = .white100Zt
        
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    private func setSubviews() {
        [imageView, priceLabel, titleLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(imageView.snp.horizontalEdges).inset(12)
            make.bottom.equalTo(titleLabel.snp.top).offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalTo(imageView.snp.horizontalEdges).inset(12)
            make.bottom.equalTo(imageView.snp.bottom).inset(12)
        }
    }
}

// PR 올리기 전에 지울 것.
extension UIImageView {
    func loadImage(from url: URL) {
        // URLSession을 통해 URL에서 비동기적으로 데이터를 가져오는 방법
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
    }
}
