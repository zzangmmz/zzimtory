//
//  DatabaseManager.swift
//  zzimtory
//
//  Created by 이명지 on 1/31/25.
//

import FirebaseCore
import FirebaseDatabase

final class DatabaseManager {
    private var ref: DatabaseReference!
    
    init() {
        // 파이어베이스 참조 설정
        ref = Database.database().reference()
    }
}
