//
//  SearchViewController.swift
//  zzimtory
//
//  Created by 김하민 on 1/24/25.
//

import UIKit
import SnapKit

final class ItemSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ItemSearchViewController Loaded")
        view = ItemSearchView(frame: view.frame)
    }
    
}
