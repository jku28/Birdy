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

    @IBOutlet weak private var bottomLC: NSLayoutConstraint!

    //MARK: - funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Register"
        registerKeyboardNotifications()
        bottomLayoutConstraint = bottomLC
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    //MARK: - Actions

    @IBAction func onRegister(sender: UIButton) {
        // Do checksfor inputteddata in outlettext fields and do register call. When register return success, then sign in and go further
        if !(validateInputData(fullNameTF) &&
        validateInputData(usernameTF) &&
        validateInputData(passwordTF) &&
        validateInputData(passwordConfirmTF) &&
            validateInputData(emailTF)) {
            return
        }

        let user = User()
        user.fullName = fullNameTF.text
        user.userName = usernameTF.text
        user.password = passwordTF.text
        user.email = emailTF.text

        ServiceManager.registerNew(user) { (success, error) in
            if success {
                ServiceManager.getUserList()
                StoryboardManager.initiateStoryboard("Main")
            }
        }

    }

    @IBAction func onBack(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    //MARK: - UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let valid = validateInputData(textField)
        if textField == fullNameTF {
            if  valid { usernameTF.becomeFirstResponder() }
        } else if textField == usernameTF {
            if  valid { passwordTF.becomeFirstResponder() }
        } else if textField == passwordTF {
            if  valid { passwordConfirmTF.becomeFirstResponder() }
        } else if textField == passwordConfirmTF {
            if  valid { emailTF.becomeFirstResponder() }
        } else if textField == emailTF {
            textField.resignFirstResponder()
        }
        return valid
    }

    private func validateInputData(textField:UITextField) -> Bool {
        var val = false
        if textField == fullNameTF {
            if textField.text?.characters.count > 0 {
                val = true
            } else {
                AppUtils.showAlert(owner: self, title: nil, message: "Fullname should not be empty", actions: nil)
            }
        } else if textField == usernameTF {
            if textField.text?.characters.count > 0 {
                val = true
            } else {
                AppUtils.showAlert(owner: self, title: nil, message: "Username should not be empty", actions: nil)
            }
        } else if textField == passwordTF {
            if textField.text?.characters.count > 0 {
                val = true
            } else {
                AppUtils.showAlert(owner: self, title: nil, message: "Password should not be empty", actions: nil)
            }
        } else if textField == passwordConfirmTF {
            if textField.text?.characters.count > 0 {
                if textField.text == passwordTF.text {
                    val = true
                } else {
                    AppUtils.showAlert(owner: self, title: nil, message: "Passwords are not equal", actions: nil)
                }
            } else {
                AppUtils.showAlert(owner: self, title: nil, message: "Password confirm should not be empty", actions: nil)
            }
        } else if textField == emailTF {
            val = true
        }
        return val
    }
}
