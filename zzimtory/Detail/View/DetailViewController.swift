//
//  DetailViewController.swift
//  zzimtory
//
//  Created by seohuibaek on 1/24/25.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    private var detailView = DetailView(frame: view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = detailView
    }
}
