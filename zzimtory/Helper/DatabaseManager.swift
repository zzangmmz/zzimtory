//
//  DatabaseManager.swift
//  zzimtory
//
//  Created by 이명지 on 1/31/25.
//

import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

final class DatabaseManager {
    private var ref: DatabaseReference!
    
    init() {
        // 파이어베이스 참조 설정
        ref = Database.database().reference()
    }
    
    func registerUser(email: String, nickname: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("현재 인증된 유저가 없습니다.")
            return
        }
        
        let uid = currentUser.uid
        
        let userData: [String: Any] = [
            "email": email,
            "nickname": nickname,
            "uid": uid,
            "pockets": []
        ]
        
        ref.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                self.ref.child("users").child(uid).setValue(userData) { error, _ in
                    if let error = error {
                        print("유저 등록 실패: \(error.localizedDescription)")
                    } else {
                        print("유저 등록 성공")
                    }
                }
            } else {
                print("이미 등록된 유저")
            }
        }
    }
}
