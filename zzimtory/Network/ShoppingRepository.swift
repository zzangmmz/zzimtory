//
//  ShoppingRepository.swift
//  zzimtory
//
//  Created by 이명지 on 1/24/25.
//

import Foundation
import RxMoya
import Moya
import RxSwift

protocol ShoppingRepositoryProtocol {
    func fetchSearchData(query: String, page: Int) -> Single<ShoppingAPIResponse>
}

final class ShoppingRepository: ShoppingRepositoryProtocol {
    private let provider = MoyaProvider<ShoppingAPI>()
    
    /// query 검색어에 대한 검색 결과 반환
    func fetchSearchData(query: String, page: Int = 1) -> Single<ShoppingAPIResponse> {
        provider.rx.request(.search(query: query, page: page))
            .map(ShoppingAPIResponse.self)
    }
    
    func fetchForViewModel(with query: String, page: Int = 1, itemsPerPage: Int = 10) -> Observable<[Item]> {
        provider.rx.request(.search(query: query, page: page))
            .map(ShoppingAPIResponse.self)
            .map { $0.items }
            .asObservable()
    }
}
