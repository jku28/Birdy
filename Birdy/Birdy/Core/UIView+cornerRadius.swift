//
//  UIView+cornerRadius.swift
//  iApprove
//
//  Created by Vladimir Yevdokimov on 8/8/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(corners:UIRectCorner, radius:CGFloat) {

        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer.init()
        shape.path = maskPath.CGPath
        self.layer.mask = shape

    }
}