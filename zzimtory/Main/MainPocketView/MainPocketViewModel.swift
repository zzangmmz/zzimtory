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
    
    var displayPockets: [Pocket] {
        return [createAggregatePocket()] + filterPockets.filter { $0.title != "전체보기" }
    }
    
    func fetchData(completion: @escaping ([Pocket]?) -> Void) {
        DatabaseManager.shared.readPocket { [weak self] pockets in
            guard let self = self else { return }
            self.pockets = pockets
            self.filterPockets = pockets
            // 업데이트 후 전체보기 주머니도 DB에 최신 내용으로 저장
            self.updateAggregatePocketInDB {
                completion(self.filterPockets)
            }
        }
    }
    
    func addPocket(title: String, completion: @escaping () -> Void) {
        let newPocket = Pocket(title: title, items: [Item]())
        self.filterPockets.append(newPocket)
        DatabaseManager.shared.createPocket(title: newPocket.title) {
            // 주머니 추가 후 전체보기 주머니도 업데이트
            self.updateAggregatePocketInDB {
                completion()
            }
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
    
    /// 기존 주머니 중 "전체보기" 주머니는 제외하고, 나머지 주머니의 아이템을 합산하고
    /// DB에 저장된 직접 추가된 아이템도 함께 반영하여 새로운 "전체보기" 주머니를 생성합니다.
    private func createAggregatePocket() -> Pocket {
        var aggregatedItems: [Item] = []
        var manualItems: [Item] = []
        
        for pocket in pockets {
            if pocket.title == "전체보기" {
                // DB에 이미 저장된 전체보기 주머니에 직접 추가된 아이템들
                manualItems = pocket.items
            } else {
                aggregatedItems.append(contentsOf: pocket.items)
            }
        }
        
        // 동일한 아이템(productID 기준)이 중복되지 않도록 합칩니다.
        var combinedDict: [String: Item] = [:]
        for item in aggregatedItems {
            combinedDict[item.productID] = item
        }
        for item in manualItems {
            combinedDict[item.productID] = item
        }
        let combinedItems = Array(combinedDict.values)
        let sortedItems = combinedItems.sorted { (firstItem, secondItem) -> Bool in
            if let firstDate = firstItem.saveDate, let secondDate = secondItem.saveDate {
                return firstDate > secondDate
            }
            return firstItem.productID < secondItem.productID
        }
        return Pocket(title: "전체보기", items: sortedItems)
    }
    
    /// 개별 주머니들의 데이터를 반영하여 "전체보기" 주머니를 다시 계산하고, DB에 업데이트합니다.
    func updateAggregatePocketInDB(completion: @escaping () -> Void) {
        let aggregatePocket = createAggregatePocket()
        DatabaseManager.shared.createOrUpdateAggregatePocket(pocket: aggregatePocket) {
            print("전체보기 주머니 DB 업데이트 완료")
            completion()
        }
    }
    
    /// "전체보기" 주머니에 직접 아이템을 추가할 때 호출합니다.
    func addItemDirectlyToAggregatePocket(newItem: Item, completion: @escaping () -> Void) {
        DatabaseManager.shared.addItemToAggregatePocket(newItem: newItem) {
            // 직접 추가 후 최신 데이터를 반영하기 위해 전체보기 주머니 업데이트
            self.updateAggregatePocketInDB {
                completion()
            }
        }
    }
}
