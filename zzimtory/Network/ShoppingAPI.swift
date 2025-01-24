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
            guard let url = URL(string: "https://openapi.naver.com") else {
                fatalError("baseURL이 올바르지 않습니다.")
            }
            return url
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
            let parameters: [String: Any] = ["query": query]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            ["X-Naver-Client-Id": APIKey.clientID,
             "X-Naver-Client-Secret": APIKey.clientSecret]
        }
    }
}
