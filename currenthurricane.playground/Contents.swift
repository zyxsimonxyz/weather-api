/*
 
Current hurricane playground for parsing hurricane conditions returned as JSON
data from the Weather Underground API.

See the currenthurricane.json file located in the Resources folder of this
Playground for a local copy of the json data.

Weather Underground API documentation:
https://www.wunderground.com/weather/api/d/docs

*/

import UIKit

// Model
// -----------------------------------------------------------------------------

struct StormInfo {
    let name: String
    let nameNice: String
    let number: String
}

struct Current {
    let lat: Float
    let lon: Float
    let saffcategory: Float
    let category: String
}

// Parser
// -----------------------------------------------------------------------------

class HurricaneParser {
    
    /**
     Parse storm information returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Array of storm info structs.
     */
    
    func stormInfo(json: [String: Any]?) -> [StormInfo]? {
        
        guard let json = json else { return nil }
        guard let storms = json["currenthurricane"] as? [[String: AnyObject]] else { return nil }
        
        var storminfo = [StormInfo]()
        
        for storm in storms {
            guard let name = storm["stormInfo"]?["stormName"] as? String else { return nil }
            guard let namen = storm["stormInfo"]?["stormName_Nice"] as? String else { return nil }
            guard let num = storm["stormInfo"]?["stormNumber"] as? String else { return nil }
            let si = StormInfo(name: name, nameNice: namen, number: num)
            storminfo.append(si)
        }
        
        return storminfo.count > 0 ? storminfo : nil
    }
    
    /**
     Parse current information returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Array of current info structs.
     */
    
    func currInfo(json: [String: Any]?) -> [Current]? {
        
        guard let json = json else { return nil }
        guard let currentsArray = json["currenthurricane"] as? [[String: AnyObject]] else { return nil }
        
        var currents = [Current]()
        
        for current in currentsArray {
            guard let lat = current["Current"]?["lat"] as? Float else { return nil }
            guard let lon = current["Current"]?["lon"] as? Float else { return nil }
            guard let saff = current["Current"]?["SaffirSimpsonCategory"] as? Float else { return nil }
            guard let cat = current["Current"]?["Category"] as? String else { return nil }
            let cu = Current(lat: lat, lon: lon, saffcategory: saff, category: cat)
            currents.append(cu)
        }
        
        return currents.count > 0 ? currents : nil
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

let parser = HurricaneParser()

let storminf = parser.stormInfo(json: json!)

storminf?[0].name
storminf?[0].nameNice
storminf?[0].number

storminf?[1].name
storminf?[1].nameNice
storminf?[1].number

let current = parser.currInfo(json: json!)

current?[0].lat
current?[0].lon
current?[0].saffcategory
current?[0].category

current?[1].lat
current?[1].lon
current?[1].saffcategory
current?[1].category
