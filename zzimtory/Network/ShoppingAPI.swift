//
//  ShoppingAPI.swift
//  zzimtory
//
//  Created by 이명지 on 1/24/25.
//

import Foundation
import Moya

enum ShoppingAPI {
    case search(query: String, page: Int)
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
        case .search(let query, let page):
            let parameters: [String: Any] = [
                "query": query,
                "display": 10,
                "start": (page - 1) * 10 + 1    // 다음으로 가져올 데이터 시작 인덱스 계산
            ]
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
