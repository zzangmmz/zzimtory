//
//  RxShuffle.swift
//  zzimtory
//
//  Created by 김하민 on 2/13/25.
//

import RxSwift
import RxCocoa

extension Reactive where Base: SwipeCardStack {
    var delegate: DelegateProxy<SwipeCardStack, SwipeCardStackDelegate> {
        return RxSwipeCardStackDelegateProxy.proxy(for: base)
    }
    
    // MARK: - Delegate methods
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
                    direction: SwipeDirection(rawValue: args[2] as? Int ?? 3) ?? .down
                )
            }
    }
    
    // MARK: - Datasource function
    func items(with makeItem: @escaping (Item) -> SwipeCard) -> Binder<[Item]> {
      return Binder(base) { base, element in
        let proxy = RxSwipeCardStackDataSource.proxy(for: base)
        proxy.cardItems = element
        proxy.makeCard = makeItem
        base.reloadData()
      }
    }
}
