//
//  MainPocketViewModel.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/24/25.
//

import UIKit


class MainPocketViewModel {
    // 주머니 이름과 이미지 배열을 함께 관리
    private(set) var pockets: [Pocket] = []
    private(set) var filterPockets: [Pocket] = []
    
    func fetchData(completion: @escaping ([Pocket]?) -> Void) {
        DatabaseManager.shared.readPocket { [weak self] pockets in
            self?.pockets = pockets
            self?.filterPockets = pockets
            completion(self?.filterPockets)
        }
    }
    
    func addPocket(title: String, completion: @escaping () -> Void) {
        
        let newPocket = Pocket(title: title, items: [Item]())
        self.filterPockets.append(newPocket)
        DatabaseManager.shared.createPocket(title: newPocket.title) {
            completion()
        }
    }
    
    func sortPockets(by order: SortOrder, completion: @escaping () -> Void) {
        switch order {
        case .dictionary:
            filterPockets.sort { $0.title < $1.title }
            
        case .newest:
            filterPockets.sort { pocket1, pocket2 in
                switch (pocket1.saveDate, pocket2.saveDate) {
                case (nil, nil): return false
                case (nil, _): return false
                case (_, nil): return true
                case (let date1?, let date2?): return date1 > date2
                }
            }
            
        case .oldest:
            filterPockets.sort { pocket1, pocket2 in
                switch (pocket1.saveDate, pocket2.saveDate) {
                case (nil, nil): return false
                case (nil, _): return false
                case (_, nil): return true
                case (let date1?, let date2?): return date1 < date2
                }
            }
        }
        completion()
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
