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
    
    static let firebase: String = {
        guard let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: filePath) as? [String: Any] else {
            fatalError("GoogleService-Info.plist를 찾지 못했습니다.")
        }
        
        guard let apiKey = plistDict["API_KEY"] as? String else {
            fatalError("Firebase API Key를 받아오지 못했습니다.")
        }
        return apiKey
    }()
}
