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

// Parser
// -----------------------------------------------------------------------------

class LocationsParser {
    
    /**
     Parse locations returned as json data from Autocomplete API.
     - Parameter json: Dictionary representing json data.
     - Returns: Array of location structs.
     */
    
    func locationsFrom(json: [String: Any]?) -> [Location]? {
        
        guard let json = json else { return nil }
        guard let locationsArray = json["RESULTS"] as? [[String: AnyObject]] else { return nil }
        
        var locations = [Location]()
        
        for loc in locationsArray {
            guard let name = loc["name"] as? String else { return nil }
            guard let tz = loc["tzs"] as? String else { return nil }
            guard let lat = loc["lat"] as? String else { return nil }
            guard let lon = loc["lon"] as? String else { return nil }

            let lc = Location(name: name, timezone: tz, latitude: lat, longitude: lon)
            locations.append(lc)
        }
        
        return locations.count > 0 ? locations : nil
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

let parser = LocationsParser()
let locations = parser.locationsFrom(json: json!)

locations?.count
locations?[0].name
locations?[0].timezone
locations?[0].latitude
locations?[0].longitude
