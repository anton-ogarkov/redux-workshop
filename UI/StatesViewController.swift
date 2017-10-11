//
//  StatesViewController.swift
//  UI
//
//  Created by Anton Ogarkov on 10/5/17.
//  Copyright © 2017 private. All rights reserved.
//

import UIKit

public class StatesViewController: UITableViewController {

    public typealias State = (
        name: String,
        selected: () -> ()
    )
    
    public typealias Props = (
        states: [State],
        countryName: String
    )
    
    public var props: Props = ([], "") {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.setNeedsLayout()
            }
        }
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationItem.title = self.props.countryName
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Table view delegate

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.props.states[indexPath.row].selected()
    }

    // MARK: - Table view data source

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.props.states.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = self.props.states[indexPath.row].name

        return cell
    }

}
