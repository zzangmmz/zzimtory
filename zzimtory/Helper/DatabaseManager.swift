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
                        self.createPocket(title: "전체보기") {
                            self.completedLogin.onNext(true)
                        }
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
            
            // 전체보기 주머니와 나머지 주머니 분리
            let defaultPocket = pockets.first { $0.title == "전체보기" }
            var otherPockets = pockets.filter { $0.title != "전체보기" }

            // 나머지 주머니들은 saveDate 기준으로 정렬
            otherPockets.sort { pocket1, pocket2 in
                switch (pocket1.saveDate, pocket2.saveDate) {
                case (nil, nil): return false
                case (nil, _): return false
                case (_, nil): return true
                case (let date1?, let date2?): return date1 > date2
                }
            }

            // 전체보기 + 정렬된 나머지 주머니들
            pockets = []
            if let defaultPocket = defaultPocket {
                pockets.append(defaultPocket)
            }
            pockets.append(contentsOf: otherPockets)
            
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
        let allViewRef = ref.child("users").child(uid).child("pockets").child("pocket전체보기")
        
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
            
            // 선택된 주머니에 아이템 추가
            pocketRef.updateChildValues(updates) { error, _ in
                if let error = error {
                    print("아이템 추가 실패: \(error.localizedDescription)")
                } else {
                    print("아이템 추가 성공")
                    
                    // 전체보기 주머니가 아닌 경우에만 전체보기에도 추가
                    if pocketTitle != "전체보기" {
                        allViewRef.updateChildValues(updates) { error, _ in
                            if let error = error {
                                print("전체보기 주머니에 아이템 추가 실패: \(error.localizedDescription)")
                            } else {
                                print("전체보기 주머니에 아이템 추가 성공")
                            }
                        }
                    }
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
        
        // 삭제할 주머니의 아이템 정보를 먼저 가져옴
        ref.child("users").child(uid).child("pockets").child("pocket\(title)").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self,
                  let pocketData = snapshot.value as? [String: Any],
                  let itemsToDelete = pocketData["items"] as? [String: Any] else {
                print("주머니 데이터 가져오기 실패")
                return
            }
            
            // 1. 주머니 삭제
            self.ref.child("users").child(uid).child("pockets").child("pocket\(title)").removeValue { error, _ in
                if let error = error {
                    print("주머니 삭제 실패: \(error.localizedDescription)")
                    return
                }
                print("주머니 \(title) 삭제 성공")
                
                // 2. 전체보기에서도 해당 아이템들 삭제
                for itemKey in itemsToDelete.keys {
                    self.ref.child("users").child(uid).child("pockets").child("pocket전체보기").child("items").child(itemKey).removeValue { error, _ in
                        if let error = error {
                            print("전체보기에서 아이템 삭제 실패: \(error.localizedDescription)")
                        } else {
                            print("전체보기에서 아이템 삭제 성공")
                        }
                    }
                }
            }
        }
    }
    
    /// 아이템 삭제 메서드
    func deleteItem(productID: String, from pocketTitle: String) {
        guard let uid = self.getUserUID() else { return }
        
        let itemKey = "zzimtory\(productID)"
        
        if pocketTitle == "전체보기" {
            // 전체보기에서 삭제할 경우 모든 주머니에서 삭제
            ref.child("users").child(uid).child("pockets").observeSingleEvent(of: .value) { snapshot in
                guard let pockets = snapshot.value as? [String: [String: Any]] else {
                    print("주머니 데이터 탐색 실패")
                    return
                }
                
                // 모든 주머니에서 해당 아이템 삭제
                for (pocketKey, _) in pockets {
                    self.ref.child("users").child(uid).child("pockets").child(pocketKey).child("items").child(itemKey).removeValue()
                }
            }
        } else {
            // 특정 주머니에서 삭제할 경우
            
            // 1. 해당 주머니에서 삭제
            self.ref.child("users").child(uid).child("pockets").child("pocket\(pocketTitle)").child("items").child(itemKey).removeValue { error, _ in
                if let error = error {
                    print("아이템 삭제 실패: \(error.localizedDescription)")
                } else {
                    print("아이템 삭제 성공")
                }
            }
            
            // 2. 전체보기에서도 삭제
            self.ref.child("users").child(uid).child("pockets").child("pocket전체보기").child("items").child(itemKey).removeValue { error, _ in
                if let error = error {
                    print("전체보기에서 아이템 삭제 실패: \(error.localizedDescription)")
                } else {
                    print("전체보기에서 아이템 삭제 성공")
                }
            }
        }
    }
}
