//
//  BirdQuizViewController.swift
//  Birdy
//
//  Created by Vladimir Yevdokimov on 8/6/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

class BirdQuizViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK: - outlets

    @IBOutlet weak private var birdIV: UIImageView!
    @IBOutlet weak private var namePicker: UIPickerView!

    //MARK: - vars


    //MARK: - funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        navigationItem.title = "Bird Quiz"
    }

    //MARK: - Actions

    @IBAction func onAccept(sender: UIButton) {
    }

    @IBAction func onDecline(sender: UIButton) {
    }

    //MARK: - UIPickerViewDelegate, UIPickerViewDataSource

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ["Eagle","Hawk","Pidgeon"][row]
    }


}
