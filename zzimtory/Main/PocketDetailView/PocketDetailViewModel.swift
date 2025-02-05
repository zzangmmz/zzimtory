//
//  PocketDetailViewModel.swift
//  zzimtory
//
//  Created by t2023-m0072 on 2/2/25.
//

import Foundation

class PocketDetailViewModel {
    var pocket: Pocket
    
    var itemCount: String {
        return "아이템 개수: \(pocket.items.count)"
    }
    
    init(pocket: Pocket) {
        self.pocket = pocket
        print(self.pocket)
    }
}
