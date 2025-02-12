//
//  model.swift
//  zzimtory
//
//  Created by t2023-m0072 on 1/21/25.
//

import Foundation

struct ShoppingAPIResponse: Decodable {
    let start: Int
    let display: Int
    let items: [Item]
}

struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let price: String
    let mallName: String
    let productID: String
    let productType: String
    let brand: String
    let maker: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String
    var saveDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case title
        case link
        case image
        case price = "lprice"
        case mallName
        case productID = "productId"
        case productType
        case brand
        case maker
        case category1
        case category2
        case category3
        case category4
    }
}


extension Item {
    func asAny() -> Any {
        var dict: [String: Any] = [
            "title": self.title,
            "link": self.link,
            "image": self.image,
            "lprice": self.price,
            "mallName": self.mallName,
            "productId": self.productID,
            "productType": self.productType,
            "brand": self.brand,
            "maker": self.maker,
            "category1": self.category1,
            "category2": self.category2,
            "category3": self.category3,
            "category4": self.category4
        ]
        
        if let saveDate = self.saveDate {
            dict["saveDate"] = Int(saveDate.timeIntervalSince1970 * 1000)
        }
        
        return dict
    }
}

// MARK: - API Response 참고용 JSON (추후 삭제 요망)
//{
//    "lastBuildDate": "Tue, 21 Jan 2025 10:20:29 +0900",
//    "total": 4832140,
//    "start": 1,
//    "display": 10,
//    "items": [
//        {
//            "title": "스파오 콜라보 긴팔 파자마 SPPPE49U02",
//            "link": "https://search.shopping.naver.com/catalog/49916208780",
//            "image": "https://shopping-phinf.pstatic.net/main_4991620/49916208780.20241129125038.jpg",
//            "lprice": "29900",
//            "hprice": "",
//            "mallName": "네이버",
//            "productId": "49916208780",
//            "productType": "1",
//            "brand": "스파오",
//            "maker": "",
//            "category1": "패션의류",
//            "category2": "여성언더웨어/잠옷",
//            "category3": "잠옷/홈웨어",
//            "category4": ""
//        },
//        {
//            "title": "극세사<b>잠옷</b> 겨울 수면<b>잠옷</b> 원피스 홈웨어 임부 여성",
//            "link": "https://smartstore.naver.com/main/products/5057212007",
//            "image": "https://shopping-phinf.pstatic.net/main_8260173/82601733384.52.jpg",
//            "lprice": "19500",
//            "hprice": "",
//            "mallName": "아델루아 커플잠옷",
//            "productId": "82601733384",
//            "productType": "2",
//            "brand": "",
//            "maker": "",
//            "category1": "패션의류",
//            "category2": "여성언더웨어/잠옷",
//            "category3": "잠옷/홈웨어",
//            "category4": ""
//        },
//        {
//            "title": "겨울 누빔 여성<b>잠옷</b> 수면<b>잠옷</b> 긴팔 파자마 면 홈웨어 원피스",
//            "link": "https://smartstore.naver.com/main/products/5113492932",
//            "image": "https://shopping-phinf.pstatic.net/main_8265801/82658014978.74.jpg",
//            "lprice": "18900",
//            "hprice": "",
//            "mallName": "아틀란티스.",
//            "productId": "82658014978",
//            "productType": "2",
//            "brand": "엘제이룸",
//            "maker": "",
//            "category1": "패션의류",
//            "category2": "여성언더웨어/잠옷",
//            "category3": "잠옷/홈웨어",
//            "category4": ""
//        },
//        {
//            "title": "편안한 피치기모 <b>잠옷</b> 세트 커플<b>잠옷</b> 홈웨어 세트",
//            "link": "https://smartstore.naver.com/main/products/4650604497",
//            "image": "https://shopping-phinf.pstatic.net/main_8219512/82195124972.16.jpg",
//            "lprice": "14900",
//            "hprice": "",
//            "mallName": "꿀잠랜드",
//            "productId": "82195124972",
//            "productType": "2",
//            "brand": "",
//            "maker": "",
//            "category1": "패션의류",
//            "category2": "여성언더웨어/잠옷",
//            "category3": "잠옷/홈웨어",
//            "category4": ""
//        },
//        {
//            "title": "국산 커플 <b>잠옷</b> 바지 순면 겨울 파자마파티 실내복 빅사이즈 홈웨어",
//            "link": "https://smartstore.naver.com/main/products/5406059086",
//            "image": "https://shopping-phinf.pstatic.net/main_8295055/82950552766.13.jpg",
//            "lprice": "6900",
//            "hprice": "",
//            "mallName": "멜로멜로:",
//            "productId": "82950552766",
//            "productType": "2",
//            "brand": "",
//            "maker": "",
//            "category1": "패션의류",
//            "category2": "여성언더웨어/잠옷",
//            "category3": "잠옷/홈웨어",
//            "category4": ""
//        },
//        {
//            "title": "겨울 극세사 커플<b>잠옷</b> 수면<b>잠옷</b> 누빔 파자마 여성 원피스",
//            "link": "https://smartstore.naver.com/main/products/5155675165",
//            "image": "https://shopping-phinf.pstatic.net/main_8270019/82700196088.59.jpg",
//            "lprice": "19900",
//            "hprice": "",
//            "mallName": "아틀란티스.",
//            "productId": "82700196088",
//            "productType": "2",
//            "brand": "엘제이룸",
//            "maker": "",
//            "category1": "패션의류",
//            "category2": "여성언더웨어/잠옷",
//            "category3": "잠옷/홈웨어",
//            "category4": ""
//        },
//        {
//            "title": "겨울 극세사 커플 수면<b>잠옷</b>",
//            "link": "https://smartstore.naver.com/main/products/3647883757",
//            "image": "https://shopping-phinf.pstatic.net/main_8119240/81192401323.5.jpg",
//            "lprice": "21900",
//            "hprice": "",
//            "mallName": "루다벨",
//            "productId": "81192401323",
//            "productType": "2",
//            "brand": "루다벨",
//            "maker": "",
//            "category1": "패션의류",
//            "category2": "여성언더웨어/잠옷",
//            "category3": "잠옷/홈웨어",
//            "category4": ""
//        },
//        {
//            "title": "트라이 남자 파자마바지 순면 기모 수면 피치기모 가을 겨울 <b>잠옷</b>바지 9부 빅사이즈 120",
//            "link": "https://smartstore.naver.com/main/products/4760962765",
//            "image": "https://shopping-phinf.pstatic.net/main_8230548/82305484667.44.jpg",
//            "lprice": "9900",
//            "hprice": "",
//            "mallName": "런닝숍",
//            "productId": "82305484667",
//            "productType": "2",
//            "brand": "트라이",
//            "maker": "",
//            "category1": "패션의류",
//            "category2": "남성언더웨어/잠옷",
//            "category3": "잠옷/홈웨어",
//            "category4": ""
//        },
//        {
//            "title": "국산 면원피스<b>잠옷</b> 디즈니 여성홈웨어 빅사이즈 긴팔 겨울 롱 임산부 파자마",
//            "link": "https://smartstore.naver.com/main/products/5105137941",
//            "image": "https://shopping-phinf.pstatic.net/main_8264965/82649659987.36.jpg",
//            "lprice": "7900",
//            "hprice": "",
//            "mallName": "미니드림",
//            "productId": "82649659987",
//            "productType": "2",
//            "brand": "",
//            "maker": "",
//            "category1": "패션의류",
//            "category2": "여성언더웨어/잠옷",
//            "category3": "잠옷/홈웨어",
//            "category4": ""
//        },
//        {
//            "title": "국산 안심 실크 커플 <b>잠옷</b> 신혼부부 겨울 파자마파티 빅사이즈 홈웨어 선물",
//            "link": "https://smartstore.naver.com/main/products/5038148317",
//            "image": "https://shopping-phinf.pstatic.net/main_8258266/82582669377.12.jpg",
//            "lprice": "39600",
//            "hprice": "",
//            "mallName": "멜로멜로:",
//            "productId": "82582669377",
//            "productType": "2",
//            "brand": "",
//            "maker": "",
//            "category1": "패션의류",
//            "category2": "여성언더웨어/잠옷",
//            "category3": "잠옷/홈웨어",
//            "category4": ""
//        }
//    ]
//}
//
