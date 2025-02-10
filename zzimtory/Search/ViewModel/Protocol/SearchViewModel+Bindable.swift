//
//  SearchViewModel+Bindable.swift
//  zzimtory
//
//  Created by 김하민 on 1/28/25.
//

import RxSwift

// ItemSearchView와 ItemCardsView는 동일한 검색 결과를 공유해야 하므로, 같은 ViewModel을 사용하도록 설계되었습니다.
// 이를 위해 프로토콜로 ViewModel을 추상화하여,
// 향후 기능 추가 시 유연한 확장이 가능하도록 하였습니다.
// 또한, 만약 ViewModel을 분리해야 하는 상황이 발생하더라도 쉽게 분리할 수 있도록 고려하였습니다.
protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

// ViewModel을 사용하는 View와 ViewModel 간의 바인딩을 간결하게 하기 위해 Bindable 프로토콜을 정의하였습니다.
// ViewModelBindable 프로토콜은 동일한 ViewModel을 공유하는 View들 간의 일관성을 유지하기 위한 약속으로,
// View가 ViewModel에 Bindable 하다는 관계를 명확히 나타내는 역할을 합니다.
protocol ViewModelBindable {
    func bind()
}
