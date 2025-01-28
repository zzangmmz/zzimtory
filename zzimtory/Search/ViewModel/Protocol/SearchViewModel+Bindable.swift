//
//  SearchViewModel+Bindable.swift
//  zzimtory
//
//  Created by 김하민 on 1/28/25.
//

import RxSwift

protocol SearchViewModel {
    var searchResult: BehaviorSubject<[Item]> { get }
    
    func setQuery(to string: String)
    func search()
}

protocol SearchViewModelBindable {
    func bind(to viewModel: some SearchViewModel)
}
