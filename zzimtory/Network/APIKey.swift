//
//  APIKey.swift
//  zzimtory
//
//  Created by 이명지 on 1/24/25.
//

import Foundation

struct APIKey {
    static let clientID: String = {
        Bundle.main.infoDictionary?["ClientID"] as! String
    }()
    
    static let clientSecret: String = {
        Bundle.main.infoDictionary?["ClientSecret"] as! String
    }()
    
    static let firebase: String = {
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        let plistDict = NSDictionary(contentsOfFile: filePath!) as! [String: Any]
        
        return plistDict["API_KEY"] as! String
    }()
}
