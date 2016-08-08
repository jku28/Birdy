//
//  SettingsViewController.swift
//  Birdy
//
//  Created by Vladimir Yevdokimov on 8/6/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    //MARK: - outlets
    @IBOutlet weak private var usernameL: UILabel!
    @IBOutlet weak private var passwordTF: UITextField!
    @IBOutlet weak private var passwordConfirmTF: UITextField!
    @IBOutlet weak private var aboutTF: UITextField!
    @IBOutlet weak private var contactPhoneTF: UITextField!

    @IBOutlet weak private var bottomLC: NSLayoutConstraint!

    //MARK: - funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Settings"
        bottomLayoutConstraint = bottomLC
        self.registerKeyboardNotifications()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: - Actions

    @IBAction func onPasswordSubmit(sender: UIButton) {
        
    }

    @IBAction func onSignout(sender: UIButton) {
        StoryboardManager.initiateStoryboard("Auth")
    }
    //MARK: - UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == passwordTF{
            if passwordTF.text?.characters.count > 0 {
                passwordConfirmTF.becomeFirstResponder()
            } else {
                return false
            }
        } else if textField == passwordConfirmTF {
            if passwordConfirmTF.text?.characters.count > 0 {
                textField.resignFirstResponder()
            } else {
                return false
            }
        } else if textField == aboutTF {
            textField.resignFirstResponder()

        } else if textField == contactPhoneTF {
            textField.resignFirstResponder()

        }
        return true
    }

}
