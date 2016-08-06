//
//  SignInViewController.swift
//  Birdy
//
//  Created by Vladimir Yevdokimov on 8/6/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    //MARK: - outlets

    @IBOutlet weak private var usernameTF: UITextField!
    @IBOutlet weak private var passwordTF: UITextField!

    //MARK: - funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - Actions

    @IBAction func onSignIn(sender: UIButton) {
        //Here weshouldtaketext fields texts, check if they are not empty and make auth request

        StoryboardManager.initiateStoryboard("Main")

    }

}
