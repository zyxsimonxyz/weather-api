/*

Astronomy playground for parsing astronomical information from the Weather
Underground API.

See the astronomy.json file located in the Resources folder of this Playground
for a local copy of the json data.

Weather Underground API documentation:
https://www.wunderground.com/weather/api/d/docs

*/

import UIKit

// Models
// -----------------------------------------------------------------------------

struct Moon {
    let percentIlluminated: String
    let age: String
    let phase: String
    let hemisphere: String
}

extension Moon {
    
    /// Initialize Model model from JSON data.
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract dictionary from json data
        guard let moonphase = json["moon_phase"] as? [String: Any] else { return nil }
        
        // extract values from dictionary
        guard let perc = moonphase["percentIlluminated"] as? String else { return nil }
        guard let age = moonphase["ageOfMoon"] as? String else { return nil }
        guard let phase = moonphase["phaseofMoon"] as? String else { return nil }
        guard let hemi = moonphase["hemisphere"] as? String else { return nil }
        
        // set struct properties
        self.percentIlluminated = perc
        self.age = age
        self.phase = phase
        self.hemisphere = hemi
    }
    
}


struct Sun {
    let riseHour: String
    let riseMinute: String
    let setHour: String
    let setMinute: String
}

extension Sun {
    
    init?(json: [String: Any]) {
        
        // extract dictionaries from json data
        guard let sunphase = json["sun_phase"] as? [String: Any] else { return nil }
        guard let sunrise = sunphase["sunrise"] as? [String: Any] else { return nil }
        guard let sunset = sunphase["sunset"] as? [String: Any] else { return nil }
        
        // extract values from dictionaries
        guard let risehr = sunrise["hour"] as? String else { return nil }
        guard let risemin = sunrise["minute"] as? String else { return nil }
        guard let sethr = sunset["hour"] as? String else { return nil }
        guard let setmin = sunset["minute"] as? String else { return nil }
        
        // set struct values
        self.riseHour = risehr
        self.riseMinute = risemin
        self.setHour = sethr
        self.setMinute = setmin
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

let moon = Moon(json: json!)
moon?.percentIlluminated
moon?.age
moon?.phase
moon?.hemisphere

let sun = Sun(json: json!)
sun?.riseHour
sun?.riseMinute
sun?.setHour
sun?.setMinute

