//
//  UIViewController+systemSpinner.swift
//  iApprove
//
//  Created by Vladimir Yevdokimov on 7/4/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit


private var root_spinner:UIActivityIndicatorView?

public extension UIViewController {

    func startAnimateWait() {
        if root_spinner == nil {
            root_spinner = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            root_spinner!.color = UIColor.darkGrayColor()
            root_spinner!.hidesWhenStopped = true
            self.view.addSubview(root_spinner!)
            root_spinner!.center = self.view.center
            root_spinner!.startAnimating()
        }
    }

    func stopAnimateWait() {
        if root_spinner != nil {
            root_spinner!.stopAnimating()
            root_spinner!.removeFromSuperview()
            root_spinner = nil
        }
    }

}
