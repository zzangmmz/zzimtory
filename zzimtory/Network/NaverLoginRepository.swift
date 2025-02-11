//
//  NaverLoginRepository.swift
//  zzimtory
//
//  Created by 이명지 on 1/30/25.
//

import RxMoya
import Moya
import RxSwift

protocol NaverLoginRepositoryProtocol {
    func getUserInfo(tokenType: String, accessToken: String) -> Single<NaverLoginResponse>
}

final class NaverLoginRepository: NaverLoginRepositoryProtocol {
    private let provider = MoyaProvider<NaverLoginAPI>()
    
    func getUserInfo(tokenType: String, accessToken: String) -> Single<NaverLoginResponse> {
        provider.rx.request(.getUserInfo(tokenType: tokenType, accessToken: accessToken))
            .map(NaverLoginResponse.self)
    }
}
