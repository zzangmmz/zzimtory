//
//  +Int.swift
//  zzimtory
//
//  Created by seohuibaek on 1/27/25.
//

import Foundation

extension Int {
    // 천 단위로 설정
    var withSeparator: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? String(self)
    }
}
