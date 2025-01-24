//
//  ViewController.swift
//  zzimtory
//
//  Created by 이명지 on 1/20/25.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shoppingRepository = ShoppingRepository()

        shoppingRepository.fetchSearchData(query: "탁호 인형")
            .subscribe(
                onSuccess: { response in
                    // 성공적으로 데이터를 받았을 때의 처리
                    print("받은 데이터:", response.items)
                },
                onFailure: { error in
                    // 에러가 발생했을 때의 처리
                    print("에러 발생:", error)
                }
            )
            .disposed(by: disposeBag)
    }
}
