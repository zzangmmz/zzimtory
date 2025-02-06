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
    private(set) var pockets: [Pocket] = []
    private(set) var filterPockets: [Pocket] = []

    func fetchData(completion: @escaping ([Pocket]) -> Void) {
        DatabaseManager.shared.readPocket { pockets in
            self.pockets = pockets
            self.filterPockets = pockets
            completion(pockets)
        }
    }
    
    func addPocket(title: String, completion: @escaping () -> Void) {
        
        let newPocket = Pocket(title: title, items: [Item]())
        self.pockets.append(newPocket)
        DatabaseManager.shared.createPocket(title: newPocket.title) {
            completion()
        }
    }
    
    func sortPockets(by order: SortOrder, completion: @escaping () -> Void) {
        let fixedPocket = pockets.first { $0.title == "전체보기"}
        var otherPockets = pockets.filter { $0.title != "전체보기" }
        
        switch order {
        case .newest:
            otherPockets.sort { $0.title > $1.title } 
        case .oldest:
            otherPockets.sort { $0.title < $1.title }
        }
        if let fixedPocket = fixedPocket {
            pockets = [fixedPocket] + otherPockets
            completion()
        } else {
            pockets = otherPockets
            completion()
        }
    }
    func filterPockets(with searchText: String) {
            if searchText.isEmpty {
                filterPockets = pockets
            } else {
                filterPockets = pockets.filter { pocket in
                    pocket.title.lowercased().contains(searchText.lowercased()) ||
                    pocket.items.contains { item in
                        item.title.lowercased().contains(searchText.lowercased())
                    }
                }
            }
        }
    }
