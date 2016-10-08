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

extension Almanac {
    
    /// Initialize almanac model from JSON data.
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract dictionaries from json data
        guard let almanac = json["almanac"] as? [String: Any] else { return nil }
        guard let high = almanac["temp_high"] as? [String: Any] else { return nil }
        guard let normHigh = high["normal"] as? [String: Any] else { return nil }
        guard let recHigh = high["record"] as? [String: Any] else { return nil }
        guard let low = almanac["temp_low"] as? [String: Any] else { return nil }
        guard let normLow = low["normal"] as? [String: Any] else { return nil }
        guard let recLow = low["record"] as? [String: Any] else { return nil }
        
        // extract values from dictionaries
        guard let code = almanac["airport_code"] as? String else { return nil }
        guard let normHighValue = normHigh["F"] as? String else { return nil }
        guard let recHighValue = recHigh["F"] as? String else { return nil }
        guard let recHighYear = high["recordyear"] as? String else { return nil }
        guard let normLowValue = normLow["F"] as? String else { return nil }
        guard let recLowValue = recLow["F"] as? String else { return nil }
        guard let recLowYear = low["recordyear"] as? String else { return nil }
        
        // set struct properties from extracted values
        self.airportCode = code
        self.normalHigh = normHighValue
        self.recordHigh = recHighValue
        self.recordYearHigh = recHighYear
        self.normalLow = normLowValue
        self.recordLow = recLowValue
        self.recordYearLow = recLowYear
    }
    
}

// Example
// -----------------------------------------------------------------------------

let file = Bundle.main.url(forResource: "almanac", withExtension: "json")
let data = try Data(contentsOf: file!)

let json: [String: Any]?

do {
    json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
} catch {
    json = nil
    print("Error is \(error.localizedDescription)")
}

let almanac = Almanac(json: json!)
almanac?.airportCode
almanac?.normalHigh
almanac?.recordHigh
almanac?.recordYearHigh
almanac?.normalLow
almanac?.recordLow
almanac?.recordYearLow

