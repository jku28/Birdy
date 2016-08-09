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

    var bird:Bird?

    //MARK: - funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        navigationItem.title = "Bird Quiz"
    }

    override func viewWillAppear(animated: Bool) {
        loadBirdInfo()
    }

    private func loadBirdInfo() {
        ServiceManager.getRandomBird {[weak self] (bird, error) in
            if error == nil {
                self?.bird = bird
                self?.namePicker.reloadAllComponents()
                //setup data
                self?.birdIV.image = UIImage(data: NSData(base64EncodedString: bird!.image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!)
            } else {
                AppUtils.showAlert(owner: self, title: nil, message: (error?.localizedDescription)!, actions: nil)
            }
        }
    }
    //MARK: - Actions

    @IBAction func onAccept(sender: UIButton) {
        vote(true)
    }

    @IBAction func onDecline(sender: UIButton) {

        vote(false)
    }

    private func vote(vote:Bool) {
        guard self.bird != nil else {
            return
        }
        startAnimateWait()
        let voteStr = bird?.votes[namePicker.selectedRowInComponent(0)][0] as! String
        ServiceManager.updateBird(self.bird!.birdId, vote: "\(voteStr)") {[weak self] (result, error) in
            self?.stopAnimateWait()
            if (error == nil) {
                self?.loadBirdInfo()
            } else {
                AppUtils.showAlert(owner: self!, title: nil, message: (error?.localizedDescription)!, actions: nil)
            }
        }
    }

    //MARK: - UIPickerViewDelegate, UIPickerViewDataSource

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (bird?.votes.count) ?? 0
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
        if let votes = bird?.votes {
            let vote = votes[row]
            title = vote[0] as! String
        }
        return title
    }


}
