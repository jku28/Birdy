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
        cell.editing = true
        cell.setup(fromObject: object)

        return cell
    }


    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "DELETE") {[weak self] (action, path) in
            let birdObj = self?.presentingBirdObjects[indexPath.row]
            self?.startAnimateWait()

            ServiceManager.delete(birdObj!.bird.birdId, callback: { (success, error) in
                if success {
                    self?.tableView.beginUpdates()
                    self?.presentingBirdObjects.removeAtIndex(indexPath.row)
                    self?.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    self?.tableView.endUpdates()
                }
                self?.stopAnimateWait()
            })
        }

        return [action]
    }

}
