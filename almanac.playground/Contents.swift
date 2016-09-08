/*
 
Almanac playground for parsing historical weather information from the Weather
Underground API.

See the almanac.json file located in the Resources folder of this Playground
for a local copy of the json data.

Weather Underground API documentation:
https://www.wunderground.com/weather/api/d/docs

*/

import UIKit

// Model
// -----------------------------------------------------------------------------

struct Almanac {
    let airportCode: String
    let normalHigh: String
    let recordHigh: String
    let recordYearHigh: String
    let normalLow: String
    let recordLow: String
    let recordYearLow: String
}

// Parser
// -----------------------------------------------------------------------------

class AlmanacParser {
    
    // unit of 0 for Fahrenheight, unit of 1 for Celsius
    
    let units = 0
    
    /**
     Parse almanac returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: A single almanac struct.
     */
    
    func almanacFrom(json: [String: AnyObject]?) -> Almanac? {
        
        let key = units == 0 ? "F" : "C"
        
        guard let code = json?["almanac"]?["airport_code"] as? String else { return nil }
        
        guard let dictH = json?["almanac"]?["temp_high"] as? [String: AnyObject] else { return nil }
        guard let normH = dictH["normal"]?[key] as? String else { return nil }
        guard let recH = dictH["record"]?[key] as? String else { return nil }
        guard let recyrH = dictH["recordyear"] as? String else { return nil }

        guard let dictL = json?["almanac"]?["temp_low"] as? [String: AnyObject] else { return nil }
        guard let normL = dictL["normal"]?[key] as? String else { return nil }
        guard let recL = dictL["record"]?[key] as? String else { return nil }
        guard let recyrL = dictL["recordyear"] as? String else { return nil }
        
        return Almanac(airportCode: code, normalHigh: normH, recordHigh: recH, recordYearHigh: recyrH, normalLow: normL, recordLow: recL, recordYearLow: recyrL)
    }
    
}

// Example
// -----------------------------------------------------------------------------

let file = NSBundle.mainBundle().pathForResource("almanac", ofType: "json")
let data = NSData(contentsOfFile: file!)

let json: [String: AnyObject]?

do {
    json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]
} catch let error as NSError {
    json = nil
    print("error is \(error.localizedDescription)")
}

let parser = AlmanacParser()
let almanac = parser.almanacFrom(json)

almanac?.airportCode
almanac?.normalHigh
almanac?.recordHigh
almanac?.recordYearHigh
almanac?.normalLow
almanac?.recordLow
almanac?.recordYearLow
