//
//  BirdsDateGroupCell.swift
//  Birdy
//
//  Created by Vladimir Yevdokimov on 8/11/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

class BirdsDateGroupCell: BaseTableCell {

    @IBOutlet weak private var birdsNames: UILabel!
    @IBOutlet weak private var birdsTotalCountL: UILabel!
    @IBOutlet weak private var dateL: UILabel!


    override func setup(fromObject object: BaseTableCellObject!) {
        self.object = object
        object.cell = self

        if let obj = object as? BirdsDateGroupObject {
            birdsTotalCountL.text = "\(obj.birds.count)"
            dateL.text = "\(obj.date)"
            var str:[String] = []
            for bird in obj.birds {
                str.append(bird.commonname)
            }
            birdsNames.text = str.joinWithSeparator(", ")
        }
    }
}

class BirdsDateGroupObject: BaseTableCellObject {

    var birds:[Bird]! = []
    var date:String! = NSDate().stringWithFormat(kFormat_MMddyyyy)

    override var cellClass: UITableViewCell.Type! {
        get {
            return BirdsDateGroupCell.self
        }
    }

    init(birds:[Bird]) {
        super.init()
        self.birds = birds
        if birds.count > 0 {
            let bird = birds.first
            self.date = bird?.date
        }
    }
}