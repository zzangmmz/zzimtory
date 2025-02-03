//
//  DummyModel.swift
//  zzimtory
//
//  Created by 김하민 on 1/24/25.
//

struct DummyModel {
    static let items = [
        Item(title: "선물1", link: "", image: "gift", price: "19,800원",
             mallName: "", productID: "", productType: "",
             brand: "", maker: "",
             category1: "", category2: "", category3: "", category4: ""),
        Item(title: "선물2", link: "", image: "gift", price: "29,800원",
             mallName: "", productID: "", productType: "",
             brand: "", maker: "",
             category1: "", category2: "", category3: "", category4: ""),
        Item(title: "선물3", link: "", image: "gift", price: "39,800원",
             mallName: "", productID: "", productType: "",
             brand: "", maker: "",
             category1: "", category2: "", category3: "", category4: ""),
        Item(title: "선물4", link: "", image: "gift", price: "49,800원",
             mallName: "", productID: "", productType: "",
             brand: "", maker: "",
             category1: "", category2: "", category3: "", category4: "")
    ]
    
    static var shared = DummyModel()
    
    private init() {}
    
    var defaultPocket = Pocket(title: "기본 주머니", items: [])
    
    var pockets: [Pocket] = [
        Pocket(title: "호주에서쓰는돈은호주머니", items: []),
        Pocket(title: "도라에몽주머니", items: []),
//        Pocket(title: "빵주머니", items: []),
//        Pocket(title: "복주머니", items: []),
//        Pocket(title: "뒷주머니", items: []),
//        Pocket(title: "앞주머니", items: []),
//        Pocket(title: "낡은주머니", items: []),
//        Pocket(title: "가죽주머니", items: []),
//        Pocket(title: "라탄주머니", items: []),
//        Pocket(title: "간식주머니", items: []),
    ]
}
