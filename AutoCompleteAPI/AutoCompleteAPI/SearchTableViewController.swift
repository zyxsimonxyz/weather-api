//
//  SearchTableViewController.swift
//  AutoCompleteAPI
//
//  Created by Gavin Wiggins on 1/17/16.
//  Copyright © 2016 Gavin Wiggins. All rights reserved.
//

import UIKit

protocol SearchDelegate {
    // Delegate methods called for search controller results
    func selectedSearchItem(i: Location)
    func searchError(error: NSError)
}

class SearchTableViewController: UITableViewController {
    
    var results = [Location]()
    var delegate: SearchDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if results.count > 0 {
            cell.textLabel?.text = results[indexPath.row].name
        } else {
            cell.textLabel?.text = "none"
        }
        return cell
    }
    
    // MARK: - Table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let loc = results[indexPath.row]
        self.delegate?.selectedSearchItem(loc)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - Search delegate

extension SearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if searchController.active && searchController.searchBar.text != "" {
            
            // get text from search bar and replace spaces with %20
            let tx = searchController.searchBar.text ?? "no"
            let txt = tx.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
            
            // remove all previous results and fetch new results
            results.removeAll()
            let urlString = "http://autocomplete.wunderground.com/aq?query=\(txt)"
            let url = NSURL(string: urlString)!
            let httpApi = HttpAPI()     // initialize HttpAPI class
            httpApi.delegate = self     // assign delegate of HttpAPI
            httpApi.dataFrom(url)       // call method to request http data
        }
    }
    
}

// MARK: Http delegate

extension SearchTableViewController: HttpAPIDelegate {
    
    // Delegate method to handle url session error from HttpAPI
    
    func apiError(error: NSError) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.searchError(error)
    }
    
    // Delegate method to handle http response error from HttpAPI
    
    func apiHttpError(code: Int) {
        print(code)
    }
    
    // Delegate method to handle data successfully downloaded from HttpAPI
    
    func apiSuccess(data: NSData) {
        
        let parser = LocationsParser()
        let locations = parser.locationsFrom(data)
        
        if let locs = locations {
            results = locs
            self.tableView.reloadData()
        } else {
            let loc = Location(name: "unknown location", timezone: "tz", latitude: "lat", longitude: "lon")
            results.append(loc)
            self.tableView.reloadData()
        }
    }
    
}

