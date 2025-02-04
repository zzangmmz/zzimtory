//
//  MainPocketViewModel.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/24/25.
//

import UIKit

enum SortOrder {
    case newest
    case oldest
}

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
        DatabaseManager.shared.createPocket(title: newPocket.name)
        onDataChanged?()
    }
    
    func pocketCount() -> Int {
        return pockets.count
    }
    func sortPockets(by order: SortOrder) {
        
        let fixedPocket = pockets.first { $0.name == "전체보기"}
        var otherPockets = pockets.filter { $0.name != "전체보기" }
        
           switch order {
           case .newest:
               otherPockets.sort { $0.name > $1.name } // 최신순 정렬
           case .oldest:
               otherPockets.sort { $0.name < $1.name } // 오래된 순 정렬
           }
        if let fixedPocket = fixedPocket {
            pockets = [fixedPocket] + otherPockets
        } else {
            pockets = otherPockets
        }
           onDataChanged?()  // 정렬 후 UI 갱신
       }
}
