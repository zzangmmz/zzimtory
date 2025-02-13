//
//  RxSwipeCardStackDelegateProxy.swift
//  zzimtory
//
//  Created by 김하민 on 2/12/25.
//

import RxSwift
import RxCocoa

class RxSwipeCardStackDelegateProxy
: DelegateProxy<SwipeCardStack, SwipeCardStackDelegate>
, DelegateProxyType
, SwipeCardStackDelegate {
    
    weak private(set) var cardStack: SwipeCardStack?
    
    init(cardStack: SwipeCardStack) {
        self.cardStack = cardStack
        super.init(parentObject: cardStack, delegateProxy: RxSwipeCardStackDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxSwipeCardStackDelegateProxy(cardStack: $0) }
    }
}

//
//@objc
//optional func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int)
//
//@objc
//optional func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection)
//
//@objc
//optional func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection)
//
//@objc
//optional func didSwipeAllCards(_ cardStack: SwipeCardStack)
