//
//  BIrdsSubListViewController.swift
//  Birdy
//
//  Created by Vladimir Yevdokimov on 8/11/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

class BirdsSubListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak private var tableView: UITableView!

    var birds:[Bird] = []

    private var presentingBirdObjects:[BirdCellObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: BirdCell.stringName(), bundle: nil), forCellReuseIdentifier: BirdCell.stringName())
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 360.0
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        if birds.count > 0 {
            let bird = birds.first
            navigationItem.title = bird?.date

            presentingBirdObjects.removeAll()
            for bird in birds {
                presentingBirdObjects.append(BirdCellObject.init(bird: bird))
            }
            tableView.reloadData()
        }
    }

    //MARK: - UITableViewDelegate, UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentingBirdObjects.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = presentingBirdObjects[indexPath.row] as BaseTableCellObject

        let cell = tableView.dequeueReusableCellWithIdentifier(object.cellClass.stringName()) as! BaseTableCell
        cell.selectionStyle = .None

        cell.setup(fromObject: object)

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
