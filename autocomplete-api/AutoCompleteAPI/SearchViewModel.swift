//
//  SearchViewModel.swift
//  AutoCompleteAPI
//
//  Created by Gavin Wiggins on 1/2/17.
//  Copyright © 2017 Gavin Wiggins. All rights reserved.
//

import Foundation

class SearchViewModel {
    
    var locations = [Location]()
    
    /// Obtain an array of locations from data returned from AutoComplete API.
    /// - parameter data: The NSData from the AutoComplete API
    
    func locationsArrayFrom(_ json: [String: Any]) {
        
        let locationArray = Location.locationsArray(json: json)
        
        if let locations = locationArray {
            self.locations = locations
        } else {
            let location = Location(name: "none", tzs: "tzs", lat: "lat", lon: "lon")
            self.locations = [location]
        }
    }
    
    /// Provide name of location from the AutoComplete API.
    /// - parameter row: Row index for locations array
    /// - returns: Name of location
    
    func locationNameFor(_ row: Int) -> String {
        if locations.count > 0 {
            return locations[row].name
        } else {
            return "unknown location"
        }
    }
    
}
