//
//  RxSwipeCardStackDelegateProxy.swift
//  zzimtory
//
//  Created by 김하민 on 2/12/25.
//

import RxSwift
import RxCocoa

extension SwipeCardStack: HasDelegate {
    public typealias Delegate = SwipeCardStackDelegate
}

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

extension Reactive where Base: SwipeCardStack {
    var delegate: DelegateProxy<SwipeCardStack, SwipeCardStackDelegate> {
        return RxSwipeCardStackDelegateProxy.proxy(for: base)
    }
    
    var didSelectCardAt: Observable<Int> {
        return delegate
            .methodInvoked(#selector(SwipeCardStackDelegate.cardStack(_:didSelectCardAt:)))
            .map { num in
                return num[1] as? Int ?? 0
            }
    }
    
    var didSwipeAllCards: Observable<Void> {
        return delegate
            .methodInvoked(#selector(SwipeCardStackDelegate.didSwipeAllCards(_:)))
            .map { _ in () }
    }
    
    var didSwipeCardAt: Observable<(Int, SwipeDirection)> {
        return delegate
            .methodInvoked(#selector(SwipeCardStackDelegate.cardStack(_:didSwipeCardAt:with:)))
            .map { args in
                return (
                    index: args[1] as? Int ?? 0,
                    direction: args[2] as! SwipeDirection
                )
            }
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
