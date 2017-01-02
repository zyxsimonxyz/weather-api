//
//  Location.swift
//  AutoCompleteAPI
//
//  Created by Gavin Wiggins on 1/16/16.
//  Copyright © 2016 Gavin Wiggins. All rights reserved.
//

import Foundation

struct Location {
    let name: String
    let tzs: String
    let lat: String
    let lon: String
}

extension Location {
    
    init?(json: [String: Any]) {
        
        // extract values from json data
        guard let name = json["name"] as? String else { return nil }
        guard let tzs = json["tzs"] as? String else { return nil }
        guard let lat = json["lat"] as? String else { return nil }
        guard let lon = json["lon"] as? String else { return nil }
        
        // set struct properties
        self.name = name
        self.tzs = tzs
        self.lat = lat
        self.lon = lon
    }
    
    static func locationsArray(json: [String: Any]) -> [Location]? {
        guard let results = json["RESULTS"] as? [[String: Any]] else { return nil }
        let locations = results.flatMap{ Location(json: $0) }
        return locations.count > 0 ? locations : nil
    }
    
}

//import Foundation

//struct Location {
//    let name: String
//    let tzs: String
//    let lat: String
//    let lon: String
//    
//    init(jsonDict: [String: AnyObject]) {
//        self.name = jsonDict["name"] as? String ?? "none"
//        self.tzs = jsonDict["tzs"] as? String ?? "none"
//        self.lat = jsonDict["lat"] as? String ?? "none"
//        self.lon = jsonDict["lon"] as? String ?? "none"
//    }
//}

//struct Location {
//    let name: String
//    let timezone: String
//    let latitude: String
//    let longitude: String
//}

