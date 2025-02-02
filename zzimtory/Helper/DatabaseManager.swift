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
    private var userUID: String?
    
    init() {
        // 파이어베이스 참조 설정
        ref = Database.database().reference()
        getUserUID()
    }
    
    private func getUserUID() {
        guard let currentUser = Auth.auth().currentUser else {
            print("현재 인증된 유저가 없습니다.")
            return
        }
        self.userUID = currentUser.uid
    }
    
    // MARK: - Data Create Method
    /// DB에 유저 등록하는 메서드
    func createUser(user: User) {
        guard let uid = self.userUID else { return }
        
        let userData: [String: Any] = [
            "email": user.email,
            "nickname": user.nickname,
            "uid": user.uid,
            "pockets": user.pockets
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
    
    // MARK: - Data Read Method
    /// DB에서 유저 읽어오는 메서드
    func readUserData(completion: @escaping (User?) -> Void) {
        guard let uid = self.userUID else { return }
        
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
    
    // MARK: - Data Update Methods
    /// DB에 유저 주머니 데이터 업데이트 하는 메서드
    func updateUserPockets(newPockets: [Pocket], completion: @escaping (Bool) -> Void) {
        guard let uid = self.userUID else { return }
        
        let updateData = ["pockets": newPockets]
        
        ref.child("users").child(uid).updateChildValues(updateData) { error, _ in
            if let error = error {
                print("주머니 업데이트 실패: \(error.localizedDescription)")
                completion(false)
            } else {
                print("주머니 업데이트 성공")
                completion(true)
            }
        }
    }
    
    /// 유저 주머니 타이틀 업데이트 하는 메서드
    func updatePocketTitle(newTitle: String) {
        guard let uid = self.userUID else { return }
        
        let updateTitle = ["title": newTitle]
        
        ref.child("users").child(uid).updateChildValues(updateTitle) { error, _ in
            if let error = error {
                print("주머니 타이틀 업데이트 실패: \(error.localizedDescription)")
            } else {
                print("주머니 타이틀 업데이트 성공")
            }
        }
    }
    
    // MARK: - Data Delete Methods
    /// DB에서 유저 삭제하는 메서드
    func deleteUser(completion: @escaping (Bool) -> Void) {
        guard let uid = self.userUID else { return }
        
        ref.child("users").child(uid).removeValue() { error, _ in
            if let error = error {
                print("유저 삭제 실패")
                completion(false)
            } else {
                print("유저 삭제 성공")
                completion(true)
            }
        }
    }
    
    /// DB에서 유저의 주머니를 삭제하는 메서드
    func deletePocket(title: String, completion: @escaping (Bool) -> Void) {
        guard let uid = self.userUID else { return }
        
        ref.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard var userData = snapshot.value as? [String: Any],
                  var pockets = userData["pockets"] as? [Pocket] else {
                completion(false)
                return
            }
            
            if let indexToRemove = pockets.firstIndex(where: { $0.title == title }) {
                pockets.remove(at: indexToRemove)
                
                userData["pockets"] = pockets
                self.ref.child("users").child(uid).updateChildValues(userData) { error, _ in
                    if let error = error {
                        print("유저 주머니 삭제 실패")
                        completion(false)
                    } else {
                        print("유저 주머니 삭제 성공")
                        completion(true)
                    }
                }
            } else {
                print("해당 타이틀의 주머니가 없습니다.")
                completion(false)
            }
        }
    }
    
    /// 주머니 여러 개 삭제하는 메서드
    func deletePockets(titles: [String], completion: @escaping (Bool) -> Void) {
        guard let uid = self.userUID else { return }
        
        ref.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard var userData = snapshot.value as? [String: Any],
                  var pockets = userData["pockets"] as? [Pocket] else {
                completion(false)
                return
            }
            
            pockets.removeAll { pocket in
                titles.contains(pocket.title)
            }
            
            userData["pockets"] = pockets
            self.ref.child("users").child(uid).updateChildValues(userData) { error, _ in
                if let error = error {
                    print("주머니들 삭제 실패")
                    completion(false)
                } else {
                    print("주머니 삭제 성공")
                    completion(true)
                }
            }
        }
    }
}
