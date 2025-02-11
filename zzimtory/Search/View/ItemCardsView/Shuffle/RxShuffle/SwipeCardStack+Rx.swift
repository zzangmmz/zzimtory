//
//  SwipeCardStack+Rx.swift
//  zzimtory
//
//  Created by 김하민 on 2/11/25.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: SwipeCardStack {
    public func items<Sequence: Swift.Sequence, Source: ObservableType>
    (_ source: Source)
    -> (_ cardFactory: @escaping (SwipeCardStack, Int, Sequence.Element) -> SwipeCard)
    -> Disposable where Source.Element == Sequence {
        return { cardFactory in
            let dataSource = RxSwipeCardStackReactiveArrayDataSourceSequenceWrapper<Sequence>(cardFactory: cardFactory)
            
            return self.items
        }
    }
    
    public func items<
        DataSource: RxSwipeCardStackDataSourceType & SwipeCardStackDataSource,
        Source: ObservableType>
    (dataSource: DataSource)
    -> (_ source: Source)
    -> Disposable where DataSource.Element == [Source.Element] {
        
        return { source in
            _ = self.delegate
            
            return source.subscribeProxyDataSource(ofObject: self.base, dataSource: dataSource, retainDataSource: true) { [weak swipeCardStack = self.base] (_: RxSwipeCardStackDataSourceProxy, event) -> Void in
                
                guard let swipeCardStack = swipeCardStack else { return }
                
                dataSource.cardStack(swipeCardStack, observedEvent: event)
            }
        }
    }
}

extension ObservableType {
    func subscribeProxyDataSource<DelegateProxy: DelegateProxyType>(ofObject object: DelegateProxy.ParentObject, dataSource: DelegateProxy.Delegate, retainDataSource: Bool, binding: @escaping (DelegateProxy, Event<Element>) -> Void)
        -> Disposable
        where DelegateProxy.ParentObject: UIView
        , DelegateProxy.Delegate: AnyObject {
        let proxy = DelegateProxy.proxy(for: object)
        let unregisterDelegate = DelegateProxy.installForwardDelegate(dataSource, retainDelegate: retainDataSource, onProxyForObject: object)

        // Do not perform layoutIfNeeded if the object is still not in the view hierarchy
        if object.window != nil {
            // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
            object.layoutIfNeeded()
        }

        let subscription = self.asObservable()
            .observe(on:MainScheduler())
            .catch { error in
                bindingError(error)
                return Observable.empty()
            }
            // source can never end, otherwise it would release the subscriber, and deallocate the data source
            .concat(Observable.never())
            .take(until: object.rx.deallocated)
            .subscribe { [weak object] (event: Event<Element>) in

                if let object = object {
                    assert(proxy === DelegateProxy.currentDelegate(for: object), "Proxy changed from the time it was first set.\nOriginal: \(proxy)\nExisting: \(String(describing: DelegateProxy.currentDelegate(for: object)))")
                }
                
                binding(proxy, event)
                
                switch event {
                case .error(let error):
                    bindingError(error)
                    unregisterDelegate.dispose()
                case .completed:
                    unregisterDelegate.dispose()
                default:
                    break
                }
            }
            
        return Disposables.create { [weak object] in
            subscription.dispose()

            if object?.window != nil {
                object?.layoutIfNeeded()
            }

            unregisterDelegate.dispose()
        }
    }
    
    func bindingError(_ error: Swift.Error) {
        let error = "Binding error: \(error)"
    #if DEBUG
        rxFatalError(error)
    #else
        print(error)
    #endif
    }
    
    func rxFatalError(_ lastMessage: String) -> Never  {
        // The temptation to comment this line is great, but please don't, it's for your own good. The choice is yours.
        fatalError(lastMessage)
    }
}
