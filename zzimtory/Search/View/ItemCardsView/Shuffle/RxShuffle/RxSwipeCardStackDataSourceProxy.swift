//
//  RxSwipeCardStackDataSourceProxy.swift
//  zzimtory
//
//  Created by 김하민 on 2/11/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension SwipeCardStack: HasDataSource {
    public typealias DataSource = SwipeCardStackDataSource
}

private let swipeCardStackDataSourceNotSet = SwipeCardStackDataSourceNotSet()

private final class SwipeCardStackDataSourceNotSet
: NSObject,
  SwipeCardStackDataSource {
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        fatalError("Not implemented")
        // rxAbstractMethod(message: dataSourceNotSet) 이거왜안되냐
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        0
    }
    
}

open class RxSwipeCardStackDataSourceProxy
: DelegateProxy
<SwipeCardStack, SwipeCardStackDataSource>,
DelegateProxyType, SwipeCardStackDataSource {
    
    public func setForwardToDelegate(_ forwardToDelegate: (any Delegate)?, retainDelegate: Bool) {
        _requiredMethodsDataSource = forwardToDelegate ?? swipeCardStackDataSourceNotSet
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
    

    public static func currentDelegate(for object: SwipeCardStack) -> (any Delegate)? {
        <#code#>
    }
    
    public static func setCurrentDelegate(_ delegate: (any Delegate)?, to object: SwipeCardStack) {
        <#code#>
    }
    
    public func forwardToDelegate() -> (any Delegate)? {
        <#code#>
    }
    
    public typealias Delegate = SwipeCardStackDataSource & AnyObject
    
    public weak private(set) var swipeCardStack: SwipeCardStack?
    
    public init(swipeCardStack: ParentObject) {
        self.swipeCardStack = swipeCardStack
        super.init(parentObject: swipeCardStack,
                   delegateProxy: RxSwipeCardStackDataSourceProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { RxSwipeCardStackDataSourceProxy(swipeCardStack: $0) }
    }
    
    private weak var _requiredMethodsDataSource: SwipeCardStackDataSource? = swipeCardStackDataSourceNotSet

    public func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
//        (_requiredMethodsDataSource ?? swipeCardStackDataSourceNotSet).cardStack(cardStack, numberOfCardsForIndexAt: index)
        fatalError("Not implemented")
    }
    
    public func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        (_requiredMethodsDataSource ?? swipeCardStackDataSourceNotSet).numberOfCards(in: cardStack)
    }
}
