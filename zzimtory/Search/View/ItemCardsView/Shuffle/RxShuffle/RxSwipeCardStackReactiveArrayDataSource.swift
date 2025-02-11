//
//  RxSwipeCardStackReactiveArrayDataSource.swift
//  zzimtory
//
//  Created by 김하민 on 2/11/25.
//

import Foundation
import RxSwift
import RxCocoa

class RxSwipeCardStackReactiveArrayDataSourceSequenceWrapper<Sequence: Swift.Sequence>
: RxSwipeCardStackReactiveArrayDataSource<Sequence.Element>,
  RxSwipeCardStackDataSourceType {

    typealias Element = Sequence
    
    override init(cardFactory: @escaping CardFactory) {
        super.init(cardFactory: cardFactory)
    }
    
    func cardStack(_ cardStack: SwipeCardStack, observedEvent: RxSwift.Event<Sequence>) {
        Binder(self) { cardStackDataSource, sectionModels in
            let sections = Array(sectionModels)
            cardStackDataSource.cardStack(cardStack, observedElements: sections)
        }.on(observedEvent)
    }
    
    
}
    

class RxSwipeCardStackReactiveArrayDataSource<Element>
: SectionedViewDataSourceType,
  SwipeCardStackDataSource {
    
    typealias CardFactory = (SwipeCardStack, Int, Element) -> SwipeCard
    
    var itemModels: [Element]?
    
    func modelAtIndex(_ index: Int) -> Element? {
        itemModels?[index]
    }
    
    func model(at indexPath: IndexPath) throws -> Any {
        precondition(indexPath.section == 0)
        guard let item = itemModels?[indexPath.row] else {
            throw RxCocoaError.itemsNotYetBound(object: self)
        }
        return item
    }
    
    var cardFactory: CardFactory
    
    init(cardFactory: @escaping CardFactory) {
        self.cardFactory = cardFactory
    }
    
    // Data source
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        cardFactory(cardStack, index, itemModels![index])
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        itemModels?.count ?? 0
    }
    
    // Reactive
    
    func cardStack(_ cardStack: SwipeCardStack, observedElements: [Element]) {
        self.itemModels = observedElements
        
        cardStack.reloadData()
    }
    
}
