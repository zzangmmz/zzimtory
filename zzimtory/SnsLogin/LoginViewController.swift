//
//  LoginViewController.swift
//  zzimtory
//
//  Created by 이명지 on 1/27/25.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import RxSwift

final class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view = LoginView(frame: view.frame)
    }
}
