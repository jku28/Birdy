//
//  NSDate+format.swift
//  iApprove
//
//  Created by Vladimir Yevdokimov on 6/22/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import Foundation

extension NSDate {
    func stringWithFormat(formatString:String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.stringFromDate(self)
    }
}