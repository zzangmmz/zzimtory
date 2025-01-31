//
//  NaverUserModel.swift
//  zzimtory
//
//  Created by 이명지 on 1/30/25.
//

struct NaverLoginResponse: Decodable {
    let resultCode: String
    let message: String
    let value: NaverUserInfo
    
    enum CodingKeys: String, CodingKey {
        case resultCode = "resultcode"
        case message
        case value = "response"
    }
}

struct NaverUserInfo: Decodable {
    let id: String
    let email: String
}
