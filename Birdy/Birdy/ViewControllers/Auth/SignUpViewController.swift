//
//  SignUpViewController.swift
//  Birdy
//
//  Created by Vladimir Yevdokimov on 8/6/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    //MARK: - outlets

    @IBOutlet weak private var fullNameTF: UITextField!
    @IBOutlet weak private var usernameTF: UITextField!
    @IBOutlet weak private var passwordTF: UITextField!
    @IBOutlet weak private var passwordConfirmTF: UITextField!
    @IBOutlet weak private var emailTF: UITextField!

    //MARK: - funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Register"
    }


    //MARK: - Actions

    @IBAction func onRegister(sender: UIButton) {
        // Do checksfor inputteddata in outlettext fields and do register call. When register return success, then sign in and go further

        StoryboardManager.initiateStoryboard("Main")
    }

    @IBAction func onBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    //MARK: - UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == fullNameTF {

        } else if textField == usernameTF {

        } else if textField == passwordTF {

        } else if textField == passwordConfirmTF {

        } else if textField == emailTF {

        }
        return true
    }

}
