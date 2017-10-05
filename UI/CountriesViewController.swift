//
//  CountriesViewController.swift
//  UI
//
//  Created by Anton Ogarkov on 10/5/17.
//  Copyright © 2017 private. All rights reserved.
//

import UIKit

public class CountriesViewController: UITableViewController {

    public typealias Country = (
        name: String,
        selected: () -> ()
    )
        
    public var countries: [Country] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Table view delegate
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.countries[indexPath.row].selected()
    }
    
    // MARK: - Table view data source

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.countries.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = self.countries[indexPath.row].name

        return cell
    }
}
