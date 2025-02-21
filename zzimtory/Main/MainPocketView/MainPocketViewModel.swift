//
//  MainPocketViewModel.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/24/25.
//

import UIKit

class MainPocketViewModel {
    // 주머니(일반 주머니와 전체보기 주머니)를 관리합니다.
    private(set) var pockets: [Pocket] = []
    private(set) var filterPockets: [Pocket] = []
    private(set) var displayPockets: [Pocket] = []
    
    func fetchData(completion: @escaping ([Pocket]?) -> Void) {
        DatabaseManager.shared.readPocket { [weak self] pockets in
            guard let self = self else { return }
            self.pockets = pockets
            self.filterPockets = pockets
            self.displayPockets = pockets
            completion(displayPockets)
        }
    }
    
    func addPocket(title: String, completion: @escaping () -> Void) {
        let newPocket = Pocket(title: title, items: [Item]())
        
        // 전체보기 주머니와 나머지 주머니 분리
        let defaultPocket = self.displayPockets.first { $0.title == "전체보기" }
        var otherPockets = self.displayPockets.filter { $0.title != "전체보기" }
        
        // 새 주머니를 다른 주머니 배열에 추가
        otherPockets.append(newPocket)
        
        // 전체보기 + 나머지 주머니들
        self.displayPockets = []
        if let defaultPocket = defaultPocket {
            self.displayPockets.append(defaultPocket)
        }
        self.displayPockets.append(contentsOf: otherPockets)
        
        DatabaseManager.shared.createPocket(title: newPocket.title) {
            completion()
        }
    }
    
    func sortPockets(by order: SortOrder, completion: @escaping () -> Void) {
        let defaultPocket = displayPockets.first { $0.title == "전체보기" }
        var otherPockets = displayPockets.filter { $0.title != "전체보기" }
        
        switch order {
        case .dictionary:
            otherPockets.sort { $0.title < $1.title }
        case .newest:
            otherPockets.sort { pocket1, pocket2 in
                switch (pocket1.saveDate, pocket2.saveDate) {
                case (nil, nil): return false
                case (nil, _): return false
                case (_, nil): return true
                case (let date1?, let date2?): return date1 > date2
                }
            }
        case .oldest:
            otherPockets.sort { pocket1, pocket2 in
                switch (pocket1.saveDate, pocket2.saveDate) {
                case (nil, nil): return false
                case (nil, _): return false
                case (_, nil): return true
                case (let date1?, let date2?): return date1 < date2
                }
            }
        }
        
        displayPockets = []
        if let defaultPocket = defaultPocket {
            displayPockets.append(defaultPocket)
        }
        displayPockets.append(contentsOf: otherPockets)
        completion()
    }
    
    func filterPockets(with searchText: String) {
        let defaultPocket = self.pockets.first { $0.title == "전체보기" }
        
        if searchText.isEmpty {
            displayPockets = self.pockets
        } else {
            let filteredPockets = self.pockets.filter { pocket in
                pocket.title != "전체보기" && (
                    pocket.title.lowercased().contains(searchText.lowercased()) ||
                    pocket.items.contains { item in
                        item.title.lowercased().contains(searchText.lowercased())
                    }
                )
            }
            
            displayPockets = []
            if let defaultPocket = defaultPocket {
                displayPockets.append(defaultPocket)
            }
            displayPockets.append(contentsOf: filteredPockets)
        }
    }
}
