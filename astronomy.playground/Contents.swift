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
    
    func moonFrom(json: [String: Any]?) -> Moon? {
        
        guard let json = json else { return nil }
        guard let moonphase = json["moon_phase"] as? [String: Any] else { return nil }
        
        guard let perc = moonphase["percentIlluminated"] as? String else { return nil }
        guard let age = moonphase["ageOfMoon"] as? String else { return nil }
        guard let phase = moonphase["phaseofMoon"] as? String else { return nil }
        guard let hemi = moonphase["hemisphere"] as? String else { return nil }
        
        return Moon(percentIlluminated: perc, age: age, phase: phase, hemisphere: hemi)
    }
    
    /**
     Parse sun phase returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: A single sun struct.
     */
    
    func sunFrom(json: [String: Any]?) -> Sun? {
        
        guard let json = json else { return nil }
        guard let sunphase = json["sun_phase"] as? [String: Any] else { return nil }
        guard let sunrise = sunphase["sunrise"] as? [String: Any] else { return nil }
        guard let sunset = sunphase["sunset"] as? [String: Any] else { return nil }
        
        
        guard let risehr = sunrise["hour"] as? String else { return nil }
        guard let risemin = sunrise["minute"] as? String else { return nil }
        guard let sethr = sunset["hour"] as? String else { return nil }
        guard let setmin = sunset["minute"] as? String else { return nil }
        
        return Sun(riseHour: risehr, riseMinute: risemin, setHour: sethr, setMinute: setmin)
    }
    
}

// Example
// -----------------------------------------------------------------------------

let file = Bundle.main.url(forResource: "astronomy", withExtension: "json")
let data = try Data(contentsOf: file!)

let json: [String: Any]?

do {
    json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
} catch {
    json = nil
    print("Error is \(error.localizedDescription)")
}

let parser = MoonSunParser()

let moon = parser.moonFrom(json: json!)

moon?.percentIlluminated
moon?.age
moon?.phase
moon?.hemisphere

let sun = parser.sunFrom(json: json!)

sun?.riseHour
sun?.riseMinute
sun?.setHour
sun?.setMinute
