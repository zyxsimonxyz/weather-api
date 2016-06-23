//
//  LocationsParser.swift
//  AutoCompleteAPI
//
//  Created by Gavin Wiggins on 6/22/16.
//  Copyright © 2016 Gavin Wiggins. All rights reserved.
//

import Foundation

class LocationsParser {
    
    func locationsFrom(data: NSData) -> [Location]? {
        
        let json = JSON(data: data)
        
        var locations = [Location]()
        
        for (_, item):(String, JSON) in json["RESULTS"] {
            guard let name = item["name"].string else { return nil }
            guard let tzs = item["tzs"].string else { return nil }
            guard let lat = item["lat"].string else { return nil }
            guard let lon = item["lon"].string else { return nil }
            let loc = Location(name: name, timezone: tzs, latitude: lat, longitude: lon)
            locations.append(loc)
        }
        
        return locations.count > 0 ? locations : nil
    }
    
}
