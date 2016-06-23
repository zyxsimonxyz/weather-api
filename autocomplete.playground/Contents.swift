/*
Example of parsing a list of locations returned as JSON from the AutoComplete API.

Link to AutoComplete API documentation
http://www.wunderground.com/weather/api/d/docs?d=autocomplete-api
*/

import UIKit

/*
 
 Model
 
*/

struct Location {
    let name: String
    let timezone: String
    let latitude: String
    let longitude: String
}

/*
 
 Parser
 
*/

class LocationsParser {
    
    func locationsFrom(data: NSData?) -> [Location]? {
        
        guard let data = data else { return nil }
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

/*
 
 Example
 
*/

let path = NSBundle.mainBundle().pathForResource("autocomplete", ofType: "json")
let jsonData = NSData(contentsOfFile: path!)

let parser = LocationsParser()

let locations = parser.locationsFrom(jsonData)

locations?[0].name
locations?[0].timezone
locations?[0].latitude
locations?[0].longitude

locations?.count
