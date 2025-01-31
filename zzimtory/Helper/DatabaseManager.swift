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
    
    /// 유저 등록 메서드
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
    
    /// 유저 데이터 읽어오는 메서드
    func fetchUserData(completion: @escaping (User?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("현재 인증된 유저가 없습니다.")
            completion(nil)
            return
        }
        
        let uid = currentUser.uid
        
        ref.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("유저를 찾지 못했습니다.")
                completion(nil)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                completion(user)
            } catch {
                print("디코딩 실패")
                completion(nil)
            }
        }
    }
}
