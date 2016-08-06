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

    private var presentingSights = []

    //MARK: - funcs

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Sightings"
    }

    private func loadSights() {
        // Load sights and set them to @presenting and reload table to refresh data
    }

    //MARK: - UITableViewDelegate, UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentingSights.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")

        return cell!
    }

}