//
//  ItemCardsView.swift
//  zzimtory
//
//  Created by 김하민 on 1/27/25.
//

import UIKit
import SnapKit
import RxSwift

final class ItemCardsView: UIView {
    private var items: [Item] = []
    private let cardStack = SwipeCardStack()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cardStack)
        cardStack.dataSource = self
        cardStack.backgroundColor = .pink300Zt
        
        cardStack.snp.makeConstraints { make in
            
            make.width.equalTo(UIScreen.main.bounds.width * 0.9)
            make.height.equalTo(UIScreen.main.bounds.height * 0.7)
            make.center.equalToSuperview()
        }
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeCard(with item: Item) -> SwipeCard {
        let card = SwipeCard()
        
        card.swipeDirections = [.left, .right, .up]
        card.content = ItemCardContents(item: item)
        card.contentMode = .scaleAspectFill
        
        let leftOverlay = UIView()
        leftOverlay.backgroundColor = .red
        
        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .green
        
        let upOverlay = UIView()
        upOverlay.backgroundColor = .blue400ZtPrimary
        
        card.setOverlays([.left: leftOverlay, .right: rightOverlay, .up: upOverlay])
        
        return card
    }
}

extension ItemCardsView: SearchViewModelBindable {
    func bind(to viewModel: some SearchViewModel) {
        viewModel.searchResult.observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] result in
                    self?.items.append(contentsOf: result)
                    self?.cardStack.reloadData()
                },
                onError: { error in
                    print("error: \(error)")
                }
            ).disposed(by: disposeBag)
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
