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
        ServiceManager.getUserList()
        // Do any additional setup after loading the view.
    }

    //MARK: - Actions

    @IBAction func onSignIn(sender: UIButton) {
        //Here weshouldtaketext fields texts, check if they are not empty and make auth request

        guard let login = usernameTF.text where usernameTF.text?.characters.count > 0 else {
                self.usernameTF.becomeFirstResponder()
            return
        }

        guard let password = passwordTF.text where passwordTF.text?.characters.count > 0 else {
                self.passwordTF.becomeFirstResponder()
            return
        }

        usernameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()

        startAnimateWait()
        ServiceManager.login(login, password: password) {[weak self] (success, error) in
            self?.stopAnimateWait()
            if success {
                StoryboardManager.initiateStoryboard("Main")
            } else {
                AppUtils.showAlert(owner: self, title: nil, message: "Please check credentials and try again later", actions: nil)
            }
        }
    }

    @IBAction func onBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
