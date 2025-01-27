//
//  MainViewModel.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/24/25.
//

import Foundation

class MainPoketViewModel {
    
    private(set) var pockets: [String] = ["전체보기"]
    
    var onDataChanged: (() -> Void)?
    
    func addPocket(named name: String) {
        pockets.append(name)
        onDataChanged?()
    }
    
    func pocketCount() -> Int {
        return pockets.count
    }
}
