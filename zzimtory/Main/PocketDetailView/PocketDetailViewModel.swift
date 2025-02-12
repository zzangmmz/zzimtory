//
//  PocketDetailViewModel.swift
//  zzimtory
//
//  Created by t2023-m0072 on 2/2/25.
//

import Foundation

class PocketDetailViewModel {
    private(set) var pocket: Pocket
    var displayItems: [Item] = []
    var filteredItems: [Item] = []
    
    var itemCount: String {
        return "아이템 개수: \(pocket.items.count)"
    }
    
    init(pocket: Pocket) {
        self.pocket = pocket
        self.filteredItems = pocket.items
        self.displayItems = pocket.items
    }
    
    func fetchData(completion: @escaping (Pocket) -> Void) {
        DatabaseManager.shared.readPocket { [weak self] pockets in
            if let updatedPocket = pockets.first(where: { $0.title == self?.pocket.title }) {
                self?.pocket = updatedPocket
                self?.displayItems = updatedPocket.items
                completion(updatedPocket)
            } else {
                completion(self?.pocket ?? Pocket(title: "", items: []))
            }
        }
    }
    
    func sortItems(by order: SortOrder, completion: @escaping () -> Void) {
        switch order {
        case .dictionary:
            displayItems.sort { $0.title < $1.title } // 사전순 정렬
        case .newest:
            displayItems.sort { $0.saveDate > $1.saveDate }
        case .oldest:
            displayItems.sort { $0.saveDate < $1.saveDate }
        }
        completion()
    }
}
