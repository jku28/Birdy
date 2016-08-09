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

    private var presentingSights:[Bird] = []

    //MARK: - funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Sightings"
    }

    override func viewWillAppear(animated: Bool) {
        loadSights()
    }

    private func loadSights() {
        self.startAnimateWait()
        ServiceManager.getAllBirds {[weak self] (birds, error) in
            self?.presentingSights = birds
            self?.tableView.reloadData()
            self?.stopAnimateWait()
            if (error != nil) { print("error \(error)") }
        }
    }

    //MARK: - UITableViewDelegate, UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentingSights.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        }
        let bird = presentingSights[indexPath.row]
        cell!.textLabel?.text = bird.commonname
        cell!.detailTextLabel?.text = bird.weather
        cell!.selectionStyle = .None
        return cell!
    }

}
