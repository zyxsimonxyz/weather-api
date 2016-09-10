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
    
    func locationsFrom(json: [String: AnyObject]?) -> [Location]? {
        
        guard let json = json else { return nil }
        guard let locationsArray = json["RESULTS"] as? [[String: AnyObject]] else { return nil }
        
        var locations = [Location]()
        
        for loc in locationsArray {
            if let
                name = loc["name"] as? String,
                tz = loc["tzs"] as? String,
                lat = loc["lat"] as? String,
                lon = loc["lon"] as? String
            {
                let lc = Location(name: name, timezone: tz, latitude: lat, longitude: lon)
                locations.append(lc)
            }
        }
        
        return locations.count > 0 ? locations : nil
    }
    
}

// Example
// -----------------------------------------------------------------------------

let file = NSBundle.mainBundle().pathForResource("autocomplete", ofType: "json")
let data = NSData(contentsOfFile: file!)

let json: [String: AnyObject]?

do {
    json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]
} catch let error as NSError {
    json = nil
    print("error is \(error.localizedDescription)")
}

let parser = LocationsParser()
let locations = parser.locationsFrom(json)

locations?[0].name
locations?[0].timezone
locations?[0].latitude
locations?[0].longitude

locations?.count
