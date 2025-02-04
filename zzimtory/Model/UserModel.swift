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
    var image: String?
}
