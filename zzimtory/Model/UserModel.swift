//
//  UserModel.swift
//  zzimtory
//
//  Created by 이명지 on 1/31/25.
//

struct User: Codable {
    let email: String
    let nickname: String
    let uid: String
    var pockets: [Pocket]
}

struct Pocket: Codable {
    var title: String
    var items: [Item]
    var images: [String] {
        if items.isEmpty {
            return []
        } else {
            return items.suffix(4).map { $0.image }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case title, items
    }
    
    init(title: String, items: [Item]) {
        self.title = title
        self.items = items
    }
}
