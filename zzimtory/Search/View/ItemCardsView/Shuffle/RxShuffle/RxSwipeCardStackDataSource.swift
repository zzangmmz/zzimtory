//
//  RxSwipeCardStackDataSource.swift
//  zzimtory
//
//  Created by 김하민 on 2/13/25.
//

import RxSwift
import RxCocoa

class RxSwipeCardStackDataSource
: DelegateProxy<SwipeCardStack, SwipeCardStackDataSource>
, DelegateProxyType
, SwipeCardStackDataSource {
    
    var cardItems = [Item]()
    var makeCard: ((Item) -> SwipeCard)?
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        guard let makeCard else { return .init() }
        return makeCard(cardItems[index])
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return cardItems.count
    }
    
    weak private(set) var cardStack: SwipeCardStack?
    
    init(cardStack: SwipeCardStack) {
        self.cardStack = cardStack
        super.init(parentObject: cardStack, delegateProxy: RxSwipeCardStackDataSource.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxSwipeCardStackDataSource(cardStack: $0) }
    }
    
}


