//
//  PocketDetailViewModel.swift
//  zzimtory
//
//  Created by t2023-m0072 on 2/2/25.
//

import Foundation

class PocketDetailViewModel {
    var pocket: Pocket
    var filteredItems: [Item] = []
    
    var itemCount: String {
        return "아이템 개수: \(pocket.items.count)"
    }
    
    init(pocket: Pocket) {
        self.pocket = pocket
        self.filteredItems = pocket.items
        print(self.pocket)
    }
        
    func fetchData(completion: @escaping (Pocket) -> Void) {
        DatabaseManager.shared.readPocket { [weak self] pockets in
            if let updatedPocket = pockets.first(where: { $0.title == self?.pocket.title }) {
                self?.pocket = updatedPocket
                completion(updatedPocket)
            } else {
                completion(self?.pocket ?? Pocket(title: "", items: []))
            }
        }
    }
    
    func sortPockets(by order: SortOrder, completion: @escaping () -> Void) {
        let fixedPocket = pocket.items.first { $0.title == "전체보기"}
        var otherPockets = pocket.items.filter { $0.title != "전체보기" }
        
        switch order {
        case .newest:
            otherPockets.sort { $0.title > $1.title } // 최신순 정렬
        case .oldest:
            otherPockets.sort { $0.title < $1.title } // 오래된 순 정렬
        }
        if let fixedPocket = fixedPocket {
            pocket.items = [fixedPocket] + otherPockets
            completion()
        } else {
            pocket.items = otherPockets
            completion()
        }
    }
}
