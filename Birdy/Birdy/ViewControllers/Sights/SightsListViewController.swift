//
//  SightsListViewController.swift
//  Birdy
//
//  Created by Vladimir Yevdokimov on 8/6/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

class SightsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - outlets

    @IBOutlet weak private var tableView: UITableView!

    //MARK: - vars

    private var presentingSights:[BirdsDateGroupObject] = []
    private var tableRefresh:UIRefreshControl = UIRefreshControl()
    //MARK: - funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Sightings"
        tableView.registerNib(UINib(nibName: BirdsDateGroupCell.stringName(), bundle: nil), forCellReuseIdentifier: BirdsDateGroupCell.stringName())
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 360.0

        tableRefresh.addTarget(self, action: #selector(loadSights), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(tableRefresh)
    }

    override func viewWillAppear(animated: Bool) {
        loadSights()
    }

    internal func loadSights() {
        self.startAnimateWait()
        ServiceManager.getBirdsList {[weak self] (birds, error) in

            self?.sortBirds(birds)

            self?.stopAnimateWait()
            self?.tableRefresh.endRefreshing()
            if (error != nil) { print("error \(error)") }
        }
    }

    private func sortBirds(birds:[Bird]) {

        var groupped:[String:[Bird]!] = [:]
        for bird in birds {
            if groupped.count == 0 {
                groupped[bird.date] = [bird]
            } else {
                var exist = false
                for key in groupped.keys {
                    if key == bird.date {
                        exist = true
                        var birds = groupped[key]
                        birds!.append(bird)
                        groupped[key] = birds
                        break
                    }
                }
                if !exist {
                    groupped[bird.date] = [bird]
                }
            }
        }

        presentingSights.removeAll()

        let res = groupped.sort {
            return $0.0 < $1.0
        }

        for (_,val) in res {
            presentingSights.append(BirdsDateGroupObject(birds: val))
        }

        tableView.reloadData()

    }

    //MARK: - UITableViewDelegate, UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentingSights.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = presentingSights[indexPath.row] as BaseTableCellObject

        let cell = tableView.dequeueReusableCellWithIdentifier(object.cellClass.stringName()) as! BaseTableCell
        cell.selectionStyle = .None

        cell.setup(fromObject: object)

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = StoryboardManager.controllerFrom(storyboard: sbId_Sights, withId: sbId_Sights_BirdsSubVC) as! BirdsSubListViewController
        let obj = presentingSights[indexPath.row]
        vc.birds = obj.birds
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
