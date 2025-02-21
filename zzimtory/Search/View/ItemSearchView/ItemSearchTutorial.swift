//
//  ItemSearchTutorial.swift
//  zzimtory
//
//  Created by 김하민 on 2/21/25.
//

import UIKit
import SnapKit

final class ItemSearchTutorial: UIView {
    private let cardStack = SwipeCardStack()
    private lazy var cards: [SwipeCard] = [
        makeTutorialCard(with: .right),
        makeTutorialCard(with: .left),
        makeTutorialCard(with: .up)
    ]
    
    private let swipeDuration: TimeInterval = 1.5
    
    init() {
        super.init(frame: .zero)
        
        cardStack.delegate = self
        cardStack.dataSource = self
        
        addSubview(cardStack)
        
        cardStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func beginTutorial(onComplete: @escaping () -> Void) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.cardStack.swipe(.right, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + swipeDuration) {
            self.cardStack.swipe(.left, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + swipeDuration * 2) {
            self.cardStack.swipe(.up, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + swipeDuration * 3) {
            onComplete()
        }
    }
    
    private func makeTutorialCard(with direction: SwipeDirection) -> SwipeCard {
        let card = SwipeCard()
        card.content = ItemCardOverlay(with: direction)
        
        let overlay = ItemCardOverlay(with: direction)
        
        card.setOverlays([direction: overlay])
        
        card.animationOptions = CardAnimationOptions(totalSwipeDuration: swipeDuration)
        
        return card
    }
}

extension ItemSearchTutorial: SwipeCardStackDataSource, SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        cards[index]
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        cards.count
    }
}
