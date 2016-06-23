//
//  Location.swift
//  AutoCompleteAPI
//
//  Created by Gavin Wiggins on 1/16/16.
//  Copyright © 2016 Gavin Wiggins. All rights reserved.
//

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

struct Location {
    let name: String
    let timezone: String
    let latitude: String
    let longitude: String
}
