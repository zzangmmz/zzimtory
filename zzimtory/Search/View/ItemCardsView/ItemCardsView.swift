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
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubview(cardStack)
        cardStack.dataSource = self
        cardStack.backgroundColor = .clear
        
        cardStack.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.9)
            make.height.equalTo(UIScreen.main.bounds.height * 0.7)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func makeCard(with item: Item) -> SwipeCard {
        let card = SwipeCard()
        
        card.swipeDirections = [.left, .right, .up]
        // TO-DO: card.footer 확인해서 넣을지 결정
        card.content = ItemCardContents(item: item)
        card.contentMode = .scaleAspectFill
        
        let leftOverlay = UIView()
        leftOverlay.backgroundColor = .darkGray
        
        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .pink400ZtPrimary
        
        let upOverlay = UIView()
        upOverlay.backgroundColor = .blue400ZtPrimary
        
        card.setOverlays([.left: leftOverlay, .right: rightOverlay, .up: upOverlay])
        
        return card
    }
    
    func setDelegate(to target: SwipeCardStackDelegate) {
        cardStack.delegate = target
    }
}

// ItemCardsView를 ViewModel에 바인딩해주기 위한 프로토콜 적용입니다.
// ItemSearchView에서 사용되며, 자세한 설명은 SearchViewModel+Bindable 참고 바랍니다.
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

// SwipeCardStack의 DataSource를 지정해주기 위한 프로토콜입니다.
// UIKit의 UITableViewDataSource 등과 비슷하다고 보시면 됩니다.
extension ItemCardsView: SwipeCardStackDataSource {
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        return makeCard(with: items[index])
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        items.count
    }
}
