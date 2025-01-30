//
//  NaverLoginAPI.swift
//  zzimtory
//
//  Created by 이명지 on 1/30/25.
//

import Foundation
import Moya

enum NaverAPI {
    case getUserInfo(tokenType: String, accessToken: String)
}

extension NaverAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://openapi.naver.com")!
    }
    
    var path: String {
        switch self {
        case .getUserInfo:
            return "/v1/nid/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getUserInfo(let tokenType, let accessToken):
            return ["Authorization": "\(tokenType) \(accessToken)"]
        }
    }
}
