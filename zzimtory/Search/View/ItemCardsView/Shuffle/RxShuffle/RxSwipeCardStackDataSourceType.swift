//
//  RxSwipeCardStackDataSourceType.swift
//  zzimtory
//
//  Created by 김하민 on 2/11/25.
//

import RxSwift

public protocol RxSwipeCardStackDataSourceType {
    
    associatedtype Element
    
    func cardStack(_ cardStack: SwipeCardStack, observedEvent: Event<Element>)
}
