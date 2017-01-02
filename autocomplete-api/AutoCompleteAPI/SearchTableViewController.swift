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
    func selectedSearchItem(_ i: Location)
    func searchError(_ error: NSError)
}

class SearchTableViewController: UITableViewController {
    
    let searchViewModel = SearchViewModel()
    var delegate: SearchDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchViewModel.locationNameFor(indexPath.row)
        return cell
    }
    
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loc = searchViewModel.locations[indexPath.row]
        self.delegate?.selectedSearchItem(loc)
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - Search delegate

extension SearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            // get text from search bar and replace spaces with %20
            let tx = searchController.searchBar.text ?? "no"
            let txt = tx.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
            
            // remove all previous results and fetch new results
            searchViewModel.locations.removeAll()
            let urlString = "http://autocomplete.wunderground.com/aq?query=\(txt)"
            let httpApi = HttpAPI()     // initialize HttpAPI class
            httpApi.delegate = self     // assign delegate of HttpAPI
            httpApi.dataFrom(urlString)       // call method to request http data
        }
    }
    
}

// MARK: - HttpAPI delegate

extension SearchTableViewController: HttpAPIDelegate {
    
    func apiSessionError(_ error: Error) {
        print("Session Error is \(error.localizedDescription)")
    }
    
    func apiHttpError(_ code: Int) {
        print("Http Response Error Code is \(code)")
    }
    
    func apiJsonError(_ error: Error) {
        print("JSON Serialization Error is \(error.localizedDescription)")
    }
    
    func apiSuccess(_ json: [String: Any]) {
        self.searchViewModel.locationsArrayFrom(json)
        self.tableView.reloadData()
    }
    
}

