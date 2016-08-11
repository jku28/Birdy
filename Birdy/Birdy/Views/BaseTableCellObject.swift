//
//  BaseTableCellObject.swift
//  iApprove
//
//  Created by Vladimir Yevdokimov on 7/28/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

@objc protocol SelectionDelegate : NSObjectProtocol {
    optional func didSelect(object:AnyObject, withValue value:AnyObject?)
}

class BaseTableCellObject: NSObject {

    internal var index: NSIndexPath?
    internal weak var cell: BaseTableCell?
    internal weak var selectionDelegate:SelectionDelegate?
    
    internal var cellClass:UITableViewCell.Type! {
        get{
            fatalError(String(format: "internal func getCellClass() -> Should be overriden in %@", NSStringFromClass(self.classForCoder)));
        }
    }
}
