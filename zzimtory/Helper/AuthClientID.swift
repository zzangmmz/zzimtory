//
//  AuthClientID.swift
//  zzimtory
//
//  Created by 이명지 on 1/27/25.
//

import Foundation

struct AuthClientID {
    /// 구글 로그인 시 필요한 클라이언트 아이디
    static let google: String = {
        guard let gid = Bundle.main.infoDictionary?["GIDClientID"] as? String else {
            fatalError("GIDClientID를 읽어오지 못했습니다.")
        }
        return gid
    }()
}
