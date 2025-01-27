//
//  ItemCardsView.swift
//  zzimtory
//
//  Created by 김하민 on 1/27/25.
//

import UIKit
import SnapKit

final class ItemCardsView: UIView {
    private let items = DummyModel.items
    private let cardStack = SwipeCardStack()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cardStack)
        cardStack.dataSource = self
        
        cardStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeCard(with item: Item) -> SwipeCard {
        let card = SwipeCard()
        
        card.swipeDirections = [.left, .right, .up]
        card.content = UIImageView(image: UIImage(systemName: item.image))
        
        let leftOverlay = UIView()
        leftOverlay.backgroundColor = .green
        
        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .red
        
        card.setOverlays([.left: leftOverlay, .right: rightOverlay])
        
        return card
    }
}

extension ItemCardsView: SwipeCardStackDataSource {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        return makeCard(with: items[index])
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        items.count
    }
    
}
