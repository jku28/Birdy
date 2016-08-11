//
//  BaseTableCell.swift
//  iApprove
//
//  Created by Vladimir Yevdokimov on 7/28/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

class BaseTableCell: UITableViewCell {

    internal var object: BaseTableCellObject?;

    internal func setup(fromObject object: BaseTableCellObject!) {
        // fatalError(String(format:"internal func setInterface(fromObject object:BaseCollectionObject!) -> Should be overriden in %@", NSStringFromClass(self.classForCoder)));
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
