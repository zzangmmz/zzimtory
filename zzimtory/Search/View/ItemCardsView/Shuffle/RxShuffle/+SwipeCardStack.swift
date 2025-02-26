//
//  +SwipeCardStack.swift
//  zzimtory
//
//  Created by 김하민 on 2/13/25.
//

import RxSwift
import RxCocoa

extension SwipeCardStack: HasDelegate, HasDataSource {
    public typealias Delegate = SwipeCardStackDelegate
}
