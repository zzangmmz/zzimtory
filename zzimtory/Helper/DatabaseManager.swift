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
    /// 읽어온 데이터에 append하는 방향으로 수정.
    func createPocket(title: String) {
        guard let uid = self.userUID else { return }
        
        ref.child("users").child(uid).child("pockets").observeSingleEvent(of: .value) { snapshot in
            let newPocket: [String: Any] = [
                "title": title,
                "items": [:],
                "image": "exampleImage"
            ]
            
            self.ref.child("users").child(uid).child("pockets").child(title).setValue(newPocket) { error, _ in
                if let error = error {
                    print("주머니 생성 실패: \(error.localizedDescription)")
                } else {
                    print("주머니 생성 성공")
                }
            }
        }
    }
    
    // MARK: - Data Read Method
    /// 유저 주머니 읽어오는 메서드
    func readPocket(completion: @escaping ([Pocket]) -> Void) {
        guard let uid = self.userUID else { return }
        
        ref.child("users").child(uid).child("pockets").observeSingleEvent(of: .value) { snapshot in
            guard let pocketData = snapshot.value as? [String: [String: Any]] else {
                print("❌ No data found or wrong format")
                completion([])
                return
            }
            
            var pockets: [Pocket] = []
            
            let sortedKeys = pocketData.keys.sorted { Int($0) ?? 0 < Int($1) ?? 0 }
            
            for key in sortedKeys {
                guard let pocketInfo = pocketData[key],
                      let title = pocketInfo["title"] as? String else { continue }
                
                var items: [Item] = []
                if let itemsDict = pocketInfo["items"] as? [String: [String: Any]] {
                    // items도 숫자 키로 정렬하여 처리합니다
                    let sortedItemKeys = itemsDict.keys.sorted { Int($0) ?? 0 < Int($1) ?? 0 }
                    for itemKey in sortedItemKeys {
                        if let itemData = itemsDict[itemKey] {
                            do {
                                let itemJsonData = try JSONSerialization.data(withJSONObject: itemData)
                                if let item = try? JSONDecoder().decode(Item.self, from: itemJsonData) {
                                    items.append(item)
                                }
                            } catch {
                                print("❌ Item 변환 실패: \(error)")
                                continue
                            }
                        }
                    }
                }
                
                let pocket = Pocket(title: title, items: items, image: nil)
                pockets.append(pocket)
            }
            
            completion(pockets)
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
//    func updatePocketItem(newItem: Item, pocketIndex: String) {
//        guard let uid = self.userUID else { return }
//        
//        // 해당 주머니의 items 참조를 가져옵니다
//        let itemsRef = ref.child("users").child(uid).child("pockets").child(pocketIndex).child("items")
//        
//        // 현재 items의 개수를 확인하여 새로운 인덱스를 결정합니다
//        itemsRef.observeSingleEvent(of: .value) { snapshot in
//            let newIndex = String(snapshot.childrenCount)
//            
//            // 아이템을 딕셔너리로 변환합니다
//            guard let itemDictionary = newItem. as? [String: Any] else {
//                print("아이템 변환 실패")
//                return
//            }
//            
//            // 새로운 아이템을 추가합니다
//            itemsRef.child(newIndex).setValue(itemDictionary) { error, _ in
//                if let error = error {
//                    print("아이템 추가 실패: \(error.localizedDescription)")
//                } else {
//                    print("아이템 추가 성공")
//                }
//            }
//        }
//    }
    
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
