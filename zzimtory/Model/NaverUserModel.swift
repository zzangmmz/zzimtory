//
//  NaverUserModel.swift
//  zzimtory
//
//  Created by 이명지 on 1/30/25.
//

struct NaverUserModel: Decodable {
    let resultCode: String
    let message: String
    let value: NaverUserInfo
    
    enum CodingKeys: String, CodingKey {
        case resultCode = "resultCode"
        case message
        case value = "response"
    }
}

struct NaverUserInfo: Decodable {
    let email: String
    let nickname: String
}
