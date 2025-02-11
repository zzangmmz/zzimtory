//
//  +UIImageView.swift
//  zzimtory
//
//  Created by seohuibaek on 1/27/25.
//

import UIKit

// MARK: KingFisher로 대체 후 삭제하여야 하는 코드.
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
