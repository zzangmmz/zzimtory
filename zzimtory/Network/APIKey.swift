//
//  APIKey.swift
//  zzimtory
//
//  Created by 이명지 on 1/24/25.
//

import Foundation

struct APIKey {
    static let clientID: String = {
        guard let clientId = Bundle.main.infoDictionary?["ClientID"] as? String else {
            fatalError("Client ID를 읽어오지 못했습니다.")
        }
        return clientId
    }()
    
    static let clientSecret: String = {
        guard let clientSecret = Bundle.main.infoDictionary?["ClientSecret"] as? String else {
            fatalError("Client Secret을 읽어오지 못했습니다.")
        }
        return clientSecret
    }()
}
