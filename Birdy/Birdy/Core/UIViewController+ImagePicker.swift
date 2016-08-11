//
//  UIViewController+ImagePicker.swift
//  iApprove
//
//  Created by Vladimir Yevdokimov on 6/15/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

class UIViewController_ImagePicker: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    internal var pickerPontroller:UIImagePickerController?

    //MARK: - Public call

    func openSavedPhotoPicker() {
        self.pickerPontroller = UIImagePickerController()
        self.pickerPontroller?.delegate = self
        self.pickerPontroller?.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        self.presentViewController(self.pickerPontroller!, animated: true, completion: nil)
    }

    func openCameraPhotoPicker() {
        self.pickerPontroller = UIImagePickerController()
        self.pickerPontroller?.delegate = self
        self.pickerPontroller?.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(self.pickerPontroller!, animated: true, completion: nil)
    }

    //MARK: - Public callback

    internal func didPickImagePickerImage(image:UIImage) {
        print("image ready to be picked! Override didPickImagePickerImage to get image data")
    }

    //MARK: - UIImagePickerControllerDelegate

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.pickerPontroller?.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.didPickImagePickerImage(image)
        }
        self.pickerPontroller?.dismissViewControllerAnimated(true, completion: nil)
    }
}
