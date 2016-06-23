//
//  HomeViewController.swift
//  AutoCompleteAPI
//
//  Created by Gavin Wiggins on 6/22/16.
//  Copyright © 2016 Gavin Wiggins. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var locations = [Location]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func searchForLocation(sender: UIButton) {
        
        let searchTableVC = SearchTableViewController()
        searchTableVC.delegate = self
        
        let searchController = UISearchController(searchResultsController: searchTableVC)
        searchController.searchResultsUpdater = searchTableVC
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell", forIndexPath: indexPath)
        cell.textLabel?.text = locations[indexPath.row].name
        let lat = locations[indexPath.row].latitude
        let lon = locations[indexPath.row].longitude
        let tz = locations[indexPath.row].timezone
        cell.detailTextLabel?.text = "\(lat), \(lon), \(tz)"
        return cell
    }
    
}

extension HomeViewController: SearchDelegate {
    
    func selectedSearchItem(i: Location) {
        locations.append(i)
        self.tableView.reloadData()
    }
    
    func searchError(error: NSError) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (_) in }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
