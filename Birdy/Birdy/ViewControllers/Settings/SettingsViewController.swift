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

    //MARK: - funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Settings"
    }

    //MARK: - Actions

    @IBAction func onPasswordSubmit(sender: UIButton) {
        
    }

    //MARK: - UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == passwordTF{

        } else if textField == passwordConfirmTF {

        } else if textField == aboutTF {

        } else if textField == contactPhoneTF {

        }
        return true
    }

}
