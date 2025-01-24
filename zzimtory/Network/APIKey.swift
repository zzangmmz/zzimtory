//
//  APIKey.swift
//  zzimtory
//
//  Created by 이명지 on 1/24/25.
//

import Foundation

struct APIKey {
    let clientID: String = {
        Bundle.main.infoDictionary?["ClientID"] as! String
    }()
    
    let clientSecret: String = {
        Bundle.main.infoDictionary?["ClientSecret"] as! String
    }()
    
    let firebase: String = {
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        let plistDict = NSDictionary(contentsOfFile: filePath!) as! [String: Any]
        
        return plistDict["API_KEY"] as! String
    }()
}
