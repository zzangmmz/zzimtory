//
//  ShoppingAPI.swift
//  zzimtory
//
//  Created by 이명지 on 1/24/25.
//

import Foundation
import Moya

enum ShoppingAPI {
    case search(query: String)
}

extension ShoppingAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .search:
            URL(string: "https://openapi.naver.com")!
        }
    }
    
    var path: String {
        "/v1/search/shop.json"
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .search(query: let query):
            guard let utf8Query = query.data(using: .utf8) else {
                return .requestParameters(parameters: [:], encoding: URLEncoding.default)
            }
            let parameters: [String: Any] = ["query": utf8Query]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            ["X-Naver-Client-Id": APIKey.clientID,
             "X-Naver-Client-Secret": APIKey.clientSecret]
        }
    }
}

