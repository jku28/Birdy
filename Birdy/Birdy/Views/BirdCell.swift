//
//  BirdCell.swift
//  Birdy
//
//  Created by Vladimir Yevdokimov on 8/11/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

class BirdCell: BaseTableCell {

    @IBOutlet weak private var birdIV: UIImageView!
    @IBOutlet weak private var birdNameL: UILabel!
    @IBOutlet weak private var scientNameL: UILabel!
    @IBOutlet weak private var weatherL: UILabel!
    @IBOutlet weak private var commentsL: UILabel!

    override func setup(fromObject object: BaseTableCellObject!) {
        self.object = object
        object.cell = self

        birdIV.roundCorners(.AllCorners, radius: 5)

        if let obj = object as? BirdCellObject {
            birdNameL.text = obj.bird.commonname
            scientNameL.text = obj.bird.scientificname
            weatherL.text = obj.bird.weather
            commentsL.text = obj.bird.comments
        }
    }
}


class BirdCellObject: BaseTableCellObject {
    var bird:Bird!

    override var cellClass: UITableViewCell.Type! {
        get {
            return BirdCell.self
        }
    }

    init(bird:Bird) {
        super.init()
        self.bird = bird
    }
}