/*

Astronomy playground for parsing astronomical information from the Weather
Underground API.

See the astronomy.json file located in the Resources folder of this Playground
for a local copy of the json data.

Weather Underground API documentation:
https://www.wunderground.com/weather/api/d/docs

*/

import UIKit

// Model
// -----------------------------------------------------------------------------

struct Moon {
    let percentIlluminated: String
    let age: String
    let phase: String
    let hemisphere: String
}

struct Sun {
    let riseHour: String
    let riseMinute: String
    let setHour: String
    let setMinute: String
}

// Parser
// -----------------------------------------------------------------------------

class MoonSunParser {
    
    /**
     Parse moon phase returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: A single moon struct.
     */
    
    func moonFrom(json: [String: AnyObject]?) -> Moon? {
        
        guard let json = json else { return nil }
        
        guard let perc = json["moon_phase"]?["percentIlluminated"] as? String else { return nil }
        guard let age = json["moon_phase"]?["ageOfMoon"] as? String else { return nil }
        guard let phase = json["moon_phase"]?["phaseofMoon"] as? String else { return nil }
        guard let hemi = json["moon_phase"]?["hemisphere"] as? String else { return nil }
        
        return Moon(percentIlluminated: perc, age: age, phase: phase, hemisphere: hemi)
    }
    
    /**
     Parse sun phase returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: A single sun struct.
     */
    
    func sunFrom(json: [String: AnyObject]?) -> Sun? {
        
        guard let json = json else { return nil }
        
        guard let risehr = json["sun_phase"]?["sunrise"]??["hour"] as? String else { return nil }
        guard let risemin = json["sun_phase"]?["sunrise"]??["minute"] as? String else { return nil }
        guard let sethr = json["sun_phase"]?["sunset"]??["hour"] as? String else { return nil }
        guard let setmin = json["sun_phase"]?["sunset"]??["minute"] as? String else { return nil }
        
        return Sun(riseHour: risehr, riseMinute: risemin, setHour: sethr, setMinute: setmin)
    }
    
}

// Example
// -----------------------------------------------------------------------------

let file = NSBundle.mainBundle().pathForResource("astronomy", ofType: "json")
let data = NSData(contentsOfFile: file!)

let json: [String: AnyObject]?

do {
    json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]
} catch let error as NSError {
    json = nil
    print("error is \(error.localizedDescription)")
}

let parser = MoonSunParser()

let moon = parser.moonFrom(json)

moon?.percentIlluminated
moon?.age
moon?.phase
moon?.hemisphere

let sun = parser.sunFrom(json)

sun?.riseHour
sun?.riseMinute
sun?.setHour
sun?.setMinute
