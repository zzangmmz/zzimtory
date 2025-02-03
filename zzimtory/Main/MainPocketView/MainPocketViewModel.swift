//
//  MainPocketViewModel.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/24/25.
//

import UIKit

class MainPocketViewModel {
    // 주머니 이름과 이미지 배열을 함께 관리
    private(set) var pockets: [(name: String, images: [UIImage])] = [
        (name: "전체보기", images: [
            UIImage(named: "exampleImage") ?? UIImage(systemName: "photo")!,
            UIImage(named: "exampleImage") ?? UIImage(systemName: "photo")!,
            UIImage(named: "exampleImage") ?? UIImage(systemName: "photo")!,
            UIImage(named: "exampleImage") ?? UIImage(systemName: "photo")!
        ])
    ]
    
    var onDataChanged: (() -> Void)?
    
    func addPocket(named name: String) {
        // 새 주머니 추가
        let newPocket: (name: String, images: [UIImage]) = (name: name, images: [])
        pockets.append(newPocket)
        onDataChanged?()
    }
    
    func pocketCount() -> Int {
        return pockets.count
    }
}
