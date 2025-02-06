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
    
    func sortItems(by order: SortOrder, completion: @escaping () -> Void) {
        switch order {
        case .descending:
            displayItems.sort { $0.title > $1.title } // 사전 역순 정렬
        case .ascending:
            displayItems.sort { $0.title < $1.title } // 사전순 정렬
        }
        completion()
    }
}
