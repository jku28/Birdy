//
//  UIViewController+keyboard.swift
//  iApprove
//
//  Created by Vladimir Yevdokimov on 7/4/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

internal var bottomLayoutConstraint: NSLayoutConstraint!

public extension UIViewController {

    //MARK: - Call to activate
    /**
     Call to activate
     */
    func registerKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidShow(_:)), name:UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidHide(_:)), name:UIKeyboardDidHideNotification, object: nil)

    }

    //MARK: - May override to fetch activity
    /**
     Override to fetch activity
     */
    internal func keyboardDidShow() {

    }
    /**
     Override to fetch activity
     */
    internal func keyboardDidHide() {

    }


    //MARK: - Static
    /**
     Static
     */
    internal func keyboardDidShow(notification:NSNotification) {
        if let info = notification.userInfo {
            let size = info["UIKeyboardFrameEndUserInfoKey"]?.CGRectValue().size;
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(0.2, animations: { [weak self] in
                bottomLayoutConstraint.constant = size!.height
                self?.view.layoutIfNeeded()
                },completion: { [weak self](finished) in
                    self?.keyboardDidShow()
            })
        }
    }
    /**
     Static
     */
    internal func keyboardDidHide(notification:NSNotification) {
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.2, animations: { [weak self] in
            bottomLayoutConstraint.constant = 0
            self?.view.layoutIfNeeded()
            },completion: { [weak self](finished) in
                self?.keyboardDidHide()
        })
    }
}