//
//  PocketDetailViewModel.swift
//  zzimtory
//
//  Created by t2023-m0072 on 2/2/25.
//

import Foundation

class PocketDetailViewModel {
    var pocketTitle: String
    var items: [Item]
    var filteredItems: [Item]
    
    init(pocketTitle: String, items: [Item]) {
        self.pocketTitle = pocketTitle
        self.items = items
        self.filteredItems = items
    }
    
    var itemCount: String {
        return "아이템 개수: \(items.count)"
    }
}
