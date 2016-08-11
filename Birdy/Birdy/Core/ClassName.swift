//
//  ClassName.swift
//  iApprove
//
//  Created by Vladimir Yevdokimov on 6/22/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import Foundation

extension NSObject {
    class func stringName()->String {
        let ident:String = NSStringFromClass(self).componentsSeparatedByString(".").last!
        return ident
    }
}