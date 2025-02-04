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
    static let shared = DatabaseManager()
    private var ref: DatabaseReference!
    private var userUID: String?
    
    private init() {
        // 파이어베이스 참조 설정
        ref = Database.database(url: "https://zzimtory-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
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
    /// 유저 등록하는 메서드
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
    
    /// 주머니 만드는 메서드
    func createPocket(title: String) {
        guard let uid = self.userUID else { return }
        
        let newPocket: [String: Any] = [
            "title": title,
            "items": [Item]()
        ]
        
        ref.child("users").child(uid).child("pockets").child(title).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                self.ref.child("users").child(uid).child("pockets").child(title).setValue(newPocket) { error, _ in
                    if let error = error {
                        print("주머니 생성 실패: \(error.localizedDescription)")
                    } else {
                        print("주머니 생성 성공")
                    }
                }
            } else {
                print("이미 존재하는 주머니")
            }
        }
    }
    
    // MARK: - Data Read Method
    /// 유저 주머니 읽어오는 메서드
    func readPocket(completion: @escaping ([Pocket]?) -> Void) {
        guard let uid = self.userUID else { return }
        
        ref.child("users").child(uid).child("pockets").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("유저를 찾지 못했습니다.")
                completion(nil)
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let pockets = try JSONDecoder().decode([Pocket].self, from: jsonData)
                completion(pockets)
            } catch {
                print("디코딩 실패")
                completion(nil)
            }
        }
    }
    
    /// 유저 프로필(이메일, 닉네임) 읽어오는 메서드
    func readUserProfile(completion: @escaping ((email: String, nickname: String)?) -> Void) {
        guard let uid = self.userUID else { return }
        
        ref.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any],
                  let email = value["email"] as? String,
                  let nickname = value["nickname"] as? String else {
                print("프로필 정보를 찾을 수 없습니다.")
                completion(nil)
                return
            }
            completion((email: email, nickname: nickname))
        }
    }

    
    // MARK: - Data Update Methods
    /// 아이템 추가하는 메서드
    func updatePocketItem(newItem: Item, pocketTitle: String) {
        guard let uid = self.userUID else { return }
        
        let pocketRef = ref.child("users").child(uid).child("pockets").child(pocketTitle)
        pocketRef.child("items").observeSingleEvent(of: .value) { snapshot in
            var currentItems: [[String: Any]] = []
            if let existingItems = snapshot.value as? [[String: Any]] {
                currentItems = existingItems
            }
            
            guard let itemDictionary = newItem.asNSDictionary() as? [String: Any] else {
                print("NSDictionary로 변환 실패")
                return
            }
            currentItems.append(itemDictionary)
            
            pocketRef.updateChildValues(["items": currentItems]) { error, _ in
                if let error = error {
                    print("아이템 업데이트 실패: \(error.localizedDescription)")
                } else {
                    print("아이템 업데이트 성공")
                }
            }
        }
    }
    
    // MARK: - Data Delete Methods
    /// 유저 삭제 메서드
    func deleteUser() {
        guard let uid = self.userUID else { return }
        
        ref.child("users").child(uid).removeValue() { error, _ in
            if let error = error {
                print("유저 삭제 실패: \(error.localizedDescription)")
            } else {
                print("유저 삭제 성공")
            }
        }
    }
    
    /// 주머니 삭제 메서드
    func deletePocket(title: String) {
        guard let uid = self.userUID else { return }
        
        ref.child("users").child(uid).child("pockets").child(title).removeValue { error, _ in
            if let error = error {
                print("주머니 삭제 실패: \(error.localizedDescription)")
            } else {
                print("주머니 \(title) 삭제 성공")
            }
        }
    }
    
    /// 아이템 삭제 메서드
    func deleteItem(productID: String, from pocketTitle: String) {
        guard let uid = self.userUID else { return }
        
        ref.child("users").child(uid).child("pockets").child(pocketTitle).observeSingleEvent(of: .value) { snapshot in
            guard let pocket = snapshot.value as? [String: Any],
                  var items = pocket["items"] as? [String: Any] else {
                print("주머니 탐색 실패")
                return
            }
            
            var removeIndex: String?
            for (index, item) in items {
                if let itemDict = item as? [String: Any],
                   let itemProductID = itemDict["productID"] as? String,
                   itemProductID == productID {
                    removeIndex = index
                    break
                }
            }
            
            if let removeIndex = removeIndex {
                self.ref.child("users").child(uid).child("pockets").child(pocketTitle).child("items").child(removeIndex).removeValue { error, _ in
                    if let error = error {
                        print("아이템 삭제 실패: \(error.localizedDescription)")
                    } else {
                        print("아이템 삭제 성공")
                    }
                }
            }
        }
    }
}
