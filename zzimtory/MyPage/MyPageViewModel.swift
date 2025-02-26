//
//  MyPageViewModel.swift
//  zzimtory
//
//  Created by 이명지 on 2/14/25.
//

import Foundation

final class MyPageViewModel {
    private let userDefaults = UserDefaults.standard
    private let recentItemsKey = "recentItems"
    private(set) var recentItems = [Item]()
    
    func loadItems() {
        if let data = userDefaults.data(forKey: recentItemsKey) {
            do {
                let items = try JSONDecoder().decode([Item].self, from: data)
                self.recentItems = items
            } catch {
                print("최근 본 아이템 - 유저 디폴트 디코딩 에러: \(error)")
            }
        }
    }
}
