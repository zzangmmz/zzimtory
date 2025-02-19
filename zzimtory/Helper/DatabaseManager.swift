//
//  DatabaseManager.swift
//  zzimtory
//
//  Created by 이명지 on 1/31/25.
//

import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import RxSwift

final class DatabaseManager {
    static let shared = DatabaseManager()
    private var ref: DatabaseReference!
    private var userUID: String?
    let completedLogin = PublishSubject<Bool>()
    
    private init() {
        // 파이어베이스 참조 설정
        ref = Database.database(url: "https://zzimtory-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    }
    
    func hasUserLoggedIn() -> Bool {
        guard let currentUser = Auth.auth().currentUser else {
            print("현재 인증된 유저가 없습니다.")
            return false
        }
        return true
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.userUID = nil
        } catch let error as NSError {
            print("파이어베이스 로그아웃 실패: \(error.localizedDescription)")
        }
    }
    
    private func getUserUID() -> String? {
        guard let currentUser = Auth.auth().currentUser else {
            print("현재 인증된 유저가 없습니다.")
            return nil
        }
        return currentUser.uid
    }
    
    // MARK: - Data Create Method
    /// 유저 등록하는 메서드
    func createUser(user: User) {
        let uid = user.uid
        self.userUID = uid
        
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
                        self.completedLogin.onNext(true)
                    }
                }
            } else {
                print("이미 등록된 유저")
                self.completedLogin.onNext(true)
            }
        }
    }
    
    /// 주머니 만드는 메서드
    func createPocket(title: String, completion: @escaping () -> Void) {
        guard let uid = self.getUserUID() else { return }
        
        ref.child("users").child(uid).child("pockets").observeSingleEvent(of: .value) { snapshot in
            let newPocket: [String: Any] = [
                "title": title,
                "items": [:],
                "images": [],
                "saveDate": ServerValue.timestamp()
            ]
            
            self.ref.child("users").child(uid).child("pockets").child("pocket\(title)").setValue(newPocket) { error, _ in
                if let error = error {
                    print("주머니 생성 실패: \(error.localizedDescription)")
                } else {
                    print("주머니 생성 성공")
                    completion()
                }
            }
        }
    }
    
    // MARK: - Data Read Method
    /// 유저 주머니 읽어오는 메서드
    func readPocket(completion: @escaping ([Pocket]) -> Void) {
        guard let uid = self.getUserUID() else {
            completion([])
            return
        }
        
        ref.child("users").child(uid).child("pockets").observeSingleEvent(of: .value) { snapshot, _ in
            guard let pocketData = snapshot.value as? [String: [String: Any]] else {
                print("❌ No data found or wrong format")
                completion([])
                return
            }
            
            print(pocketData)
            
            var pockets: [Pocket] = []
            
            for key in pocketData.keys {
                guard let pocketInfo = pocketData[key],
                      let title = pocketInfo["title"] as? String else { continue }
                
                var items: [Item] = []
                
                if let itemsDict = pocketInfo["items"] as? [String: [String: Any]] {
                    for itemKey in itemsDict.keys {
                        if let itemData = itemsDict[itemKey] {
                            do {
                                let itemJsonData = try JSONSerialization.data(withJSONObject: itemData)
                                if var item = try? JSONDecoder().decode(Item.self, from: itemJsonData) {
                                    if let saveDate = itemData["saveDate"] as? TimeInterval {
                                        item.saveDate = Date(timeIntervalSince1970: saveDate / 1000)
                                    }
                                    items.append(item)
                                }
                            } catch {
                                print("❌ Item 변환 실패: \(error)")
                                continue
                            }
                        }
                    }
                    items.sort {
                        switch ($0.saveDate, $1.saveDate) {
                        case (nil, nil): return false
                        case (nil, _): return false
                        case (_, nil): return true
                        case (let date1?, let date2?): return date1 > date2
                        }
                    }
                }
                
                var pocket = Pocket(title: title, items: items)
                
                if let saveDateTimestamp = pocketInfo["saveDate"] as? TimeInterval {
                    pocket.saveDate = Date(timeIntervalSince1970: saveDateTimestamp / 1000)
                } else {
                    pocket.saveDate = nil
                }
                pockets.append(pocket)
            }
            
            pockets.sort { pocket1, pocket2 in
                switch (pocket1.saveDate, pocket2.saveDate) {
                case (nil, nil): return false
                case (nil, _): return false
                case (_, nil): return true
                case (let date1?, let date2?): return date1 > date2
                }
            }
            
            print("✅ 최종 Pocket 데이터: \(pockets)")
            completion(pockets)
        }
    }
    
    /// 유저 프로필(이메일, 닉네임) 읽어오는 메서드
    func readUserProfile(completion: @escaping ((email: String, nickname: String)?) -> Void) {
        guard let uid = self.getUserUID() else { return }
        
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
        guard let uid = self.getUserUID() else { return }
        
        let pocketRef = ref.child("users").child(uid).child("pockets").child("pocket\(pocketTitle)")
        
        pocketRef.observeSingleEvent(of: .value) { snapshot in
            let newIndex = String("zzimtory\(newItem.productID)")
            
            var updatedItem = newItem
            updatedItem.saveDate = Date()
            
            // as? 를 사용하여 안전하게 타입 캐스팅
            guard let dict = updatedItem.asAny() as? [String: Any] else {
                print("아이템 데이터 변환 실패")
                return
            }
            
            let updates: [String: Any] = [
                "items/\(newIndex)": dict,
                "saveDate": ServerValue.timestamp()
            ]
            
            pocketRef.updateChildValues(updates) { error, _ in
                if let error = error {
                    print("아이템 추가 실패: \(error.localizedDescription)")
                } else {
                    print("아이템 추가 성공")
                }
            }
        }
    }
    
    // MARK: - Data Delete Methods
    /// 유저 삭제 메서드
    func deleteUser() {
        guard let uid = self.getUserUID() else { return }
        
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
        guard let uid = self.getUserUID() else { return }
        
        ref.child("users").child(uid).child("pockets").child("pocket\(title)").removeValue { error, _ in
            if let error = error {
                print("주머니 삭제 실패: \(error.localizedDescription)")
            } else {
                print("주머니 \(title) 삭제 성공")
            }
        }
    }
    
    /// 아이템 삭제 메서드
    func deleteItem(productID: String, from pocketTitle: String) {
        guard let uid = self.getUserUID() else { return }
        
        ref.child("users").child(uid).child("pockets").child("pocket\(pocketTitle)").observeSingleEvent(of: .value) { snapshot in
            guard let pocket = snapshot.value as? [String: Any],
                  let items = pocket["items"] as? [String: Any] else {
                print("주머니 탐색 실패")
                return
            }
            
            // 아이템 키 형식을 "zzimtory{productID}"로 사용
            let itemKey = "zzimtory\(productID)"
            
            // 해당 키가 items에 존재하는지 확인
            if items[itemKey] != nil {
                self.ref.child("users").child(uid).child("pockets").child("pocket\(pocketTitle)").child("items").child(itemKey).removeValue { error, _ in
                    if let error = error {
                        print("아이템 삭제 실패: \(error.localizedDescription)")
                    } else {
                        print("아이템 삭제 성공")
                    }
                }
            } else {
                print("해당 아이템을 찾을 수 없습니다: \(itemKey)")
            }
        }
    }
}
