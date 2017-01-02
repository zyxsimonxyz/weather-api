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
    
    @IBAction func searchForLocation(_ sender: UIButton) {
        
        let searchTableVC = SearchTableViewController()
        searchTableVC.delegate = self
        
        let searchController = UISearchController(searchResultsController: searchTableVC)
        searchController.searchResultsUpdater = searchTableVC
        self.present(searchController, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].name
        let lat = locations[indexPath.row].lat
        let lon = locations[indexPath.row].lon
        let tz = locations[indexPath.row].tzs
        cell.detailTextLabel?.text = "\(lat), \(lon), \(tz)"
        return cell
    }
    
}

extension HomeViewController: SearchDelegate {
    
    func selectedSearchItem(_ i: Location) {
        locations.append(i)
        self.tableView.reloadData()
    }
    
    func searchError(_ error: NSError) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
