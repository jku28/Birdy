//
//  CustomView.swift
//  iApprove
//
//  Created by Vladimir Yevdokimov on 6/14/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

@IBDesignable class CustomView : UIView {
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
