//
//  AddBirdViewController.swift
//  Birdy
//
//  Created by Vladimir Yevdokimov on 8/10/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

class AddBirdViewController: UIViewController_ImagePicker, UITextFieldDelegate, UITextViewDelegate {

    //MARK: - outlets
    @IBOutlet weak private var birdIV: UIImageView!
    @IBOutlet weak private var scientificNameTF: UITextField!
    @IBOutlet weak private var commonNameTF: UITextField!
    @IBOutlet weak private var weatherTF: UITextField!
    @IBOutlet weak private var commentsTV: UITextView!


    //MARK: - vars

    //MARK: - funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Add Bird"
        commentsTV.layer.borderColor = UIColor.lightGrayColor().CGColor
        commentsTV.layer.borderWidth = 1
        commentsTV.layer.masksToBounds = true
    }

    //MARK: - Actions

    @IBAction func onSelectImage(sender: UIButton) {
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {[weak self] (action) in
            self?.openCameraPhotoPicker()
        }
        let saved = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) {[weak self] (action) in
            self?.openSavedPhotoPicker()
        }
        let clear = UIAlertAction(title: "Clear", style:UIAlertActionStyle.Default) {[weak self] (action) in
            self?.birdIV.image = nil
        }
        if self.birdIV.image == nil {
            clear.enabled = false
        }
        AppUtils.showAlert(owner: self, title: nil, message: "Please select picture source", actions: [camera,saved, clear])
    }

    @IBAction func onAddird(sender: UIButton) {


        scientificNameTF.resignFirstResponder()
        commonNameTF.resignFirstResponder()
        weatherTF.resignFirstResponder()
        commentsTV.resignFirstResponder()

        guard !(commonNameTF.text!.isEmpty) else {
            AppUtils.showAlert(owner: self, title: nil, message: "You should specify Scientific name", actions: nil)
            scientificNameTF.becomeFirstResponder()
            return
        }

        guard !(weatherTF.text!.isEmpty) else {
            AppUtils.showAlert(owner: self, title: nil, message: "You should specify Weather", actions: nil)
            weatherTF.becomeFirstResponder()
            return
        }

        self.startAnimateWait()

        if birdIV.image != nil {

            uploadImage(UIImagePNGRepresentation(birdIV.image!)!, success: { (data) in
                print("resp data \(NSString(data: data!, encoding: NSUTF8StringEncoding))")

                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                    guard let dataDict :NSDictionary = JSON as? NSDictionary else {
                        self.saveBirdData(nil)
                        return
                    }
                    if let uri = dataDict["data"] as? String {
                        self.saveBirdData(uri)
                    }
                } catch let error {
                    print("parse error \(error)")
                    self.stopAnimateWait()
                }
            }) { (error) in
                print("resp error \(error)")
                self.stopAnimateWait()
                
            }
        }else {
            saveBirdData(nil)
        }

    }

    private func saveBirdData(imageUrl:String?) {
        let newBird = Bird()

        newBird.image = imageUrl ?? ""
        newBird.scientificname = scientificNameTF.text ?? ""
        newBird.commonname = commonNameTF.text
        newBird.weather = weatherTF.text
        newBird.comments = commentsTV.text ?? ""
        newBird.date = NSDate().stringWithFormat(kFormat_MMddyyyy)
        newBird.owner = ServiceManager.loggedUser?.userId ?? ""
        newBird.seenbyuser = [ServiceManager.loggedUser?.userId ?? ""]
        newBird.votes.append([commonNameTF.text, 1])
        newBird.status = "unverified"
        newBird.latitude = 0
        newBird.longitude = 0

        startAnimateWait()

        ServiceManager.create(newBird) {[weak self] (success, error) in
            self?.stopAnimateWait()

            if success {
                self?.navigationController?.popViewControllerAnimated(true)
            } else {
                AppUtils.showAlert(owner: self!, title: nil, message: "Fail to save Bird", actions: nil)
            }
        }

    }

    override func didPickImagePickerImage(image: UIImage) {
        birdIV.image = image
    }

    //MARK: - UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == scientificNameTF {
            commonNameTF.becomeFirstResponder()
        } else if textField == commonNameTF {
            weatherTF.becomeFirstResponder()
        } else if textField == weatherTF {
            commentsTV.becomeFirstResponder()
        }
        return true
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        } else {
            return true
        }
    }

}
