/*
 
Current hurricane playground for parsing hurricane conditions returned as JSON
data from the Weather Underground API.

See the currenthurricane.json file located in the Resources folder of this
Playground for a local copy of the json data.

Weather Underground API documentation:
https://www.wunderground.com/weather/api/d/docs

*/

import UIKit

// Models
// -----------------------------------------------------------------------------

struct StormInfo {
    let name: String
    let nameNice: String
    let number: String
}

extension StormInfo {
    
    /// Initialize StormInfo model from JSON data.
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract dictionary from json data
        guard let storm = json["stormInfo"] as? [String: Any] else { return nil }
        
        // extract values from dictionary
        guard let name = storm["stormName"] as? String else { return nil }
        guard let namen = storm["stormName_Nice"] as? String else { return nil }
        guard let num = storm["stormNumber"] as? String else { return nil }
        
        // set struct properties
        self.name = name
        self.nameNice = namen
        self.number = num
    }
    
    /// An array of Alert structs from JSON data.
    /// - parameter json: JSON data
    
    static func stormInfoArray(json: [String: Any]) -> [StormInfo]? {
        guard let stormArray = json["currenthurricane"] as? [[String: AnyObject]] else { return nil }
        let storms = stormArray.flatMap{ StormInfo(json: $0) }
        return storms.count > 0 ? storms : nil  // if array has no elements return nil
    }
}


struct Current {
    let lat: Float
    let lon: Float
    let saffcategory: Float
    let category: String
}

extension Current {
    
    /// Initialize Current model from JSON data.
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract dictionary from json data
        guard let current = json["Current"] as? [String: Any] else { return nil }
        
        // extract values from dictionary
        guard let lat = current["lat"] as? Float else { return nil }
        guard let lon = current["lon"] as? Float else { return nil }
        guard let saff = current["SaffirSimpsonCategory"] as? Float else { return nil }
        guard let cat = current["Category"] as? String else { return nil }
        
        // set struct properties
        self.lat = lat
        self.lon = lon
        self.saffcategory = saff
        self.category = cat
    }
    
    /// An array of Current structs from JSON data.
    /// - parameter json: JSON data
    
    static func currentArray(json: [String: Any]) -> [Current]? {
        guard let currentArray = json["currenthurricane"] as? [[String: AnyObject]] else { return nil }
        let hurricanes = currentArray.flatMap{ Current(json: $0) }
        return hurricanes.count > 0 ? hurricanes : nil  // if array has no elements return nil
    }
}

// Example
// -----------------------------------------------------------------------------

let file = Bundle.main.url(forResource: "currenthurricane", withExtension: "json")
let data = try Data(contentsOf: file!)

let json: [String: Any]?

do {
    json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
} catch {
    json = nil
    print("Error is \(error.localizedDescription)")
}

let storminf = StormInfo.stormInfoArray(json: json!)

storminf?[0].name
storminf?[0].nameNice
storminf?[0].number

storminf?[1].name
storminf?[1].nameNice
storminf?[1].number

let current = Current.currentArray(json: json!)

current?[0].lat
current?[0].lon
current?[0].saffcategory
current?[0].category

current?[1].lat
current?[1].lon
current?[1].saffcategory
current?[1].category
