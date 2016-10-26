/*

Autocomplete playground for parsing a list of locations returned as JSON from 
the Autocomplete API provied by the Weather Underground.

See the autocomplete.json file located in the Resources folder of this Playground
for a local copy of the json data.

Weather Underground API documentation:
https://www.wunderground.com/weather/api/d/docs

*/

import UIKit

// Model
// -----------------------------------------------------------------------------

struct Location {
    let name: String
    let timezone: String
    let latitude: String
    let longitude: String
}

extension Location {
    
    /// Initialize Location model from JSON data.
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract values from json data
        guard let name = json["name"] as? String else { return nil }
        guard let tz = json["tzs"] as? String else { return nil }
        guard let lat = json["lat"] as? String else { return nil }
        guard let lon = json["lon"] as? String else { return nil }
        
        // set struct properties
        self.name = name
        self.timezone = tz
        self.latitude = lat
        self.longitude = lon
    }
    
    /// An array of Location structs from JSON data.
    /// - parameter json: JSON data
    
    static func locationArray(json: [String: Any]) -> [Location]? {
        guard let locations = json["RESULTS"] as? [[String: Any]] else { return nil }
        let locs = locations.flatMap{ Location(json: $0) }
        return locs.count > 0 ? locs : nil  // if array has no elements return nil
    }
    
}

// Example
// -----------------------------------------------------------------------------

let file = Bundle.main.url(forResource: "autocomplete", withExtension: "json")
let data = try Data(contentsOf: file!)

let json: [String: Any]?

do {
    json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
} catch {
    json = nil
    print("Error is \(error.localizedDescription)")
}

let locations = Location.locationArray(json: json!)

locations?.count
locations?[0].name
locations?[0].timezone
locations?[0].latitude
locations?[0].longitude

