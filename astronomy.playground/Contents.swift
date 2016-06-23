//: Astronomy playground

import UIKit

/*
 
 Model
 
*/

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

/*
 
 Parser
 
*/

class MoonSunParser {
    
    func moonFrom(data: NSData?) -> Moon? {
        
        guard let data = data else { return nil }
        let json = JSON(data: data)
        
        guard let perc = json["moon_phase"]["percentIlluminated"].string else { return nil }
        guard let age = json["moon_phase"]["ageOfMoon"].string else { return nil }
        guard let phase = json["moon_phase"]["phaseofMoon"].string else { return nil }
        guard let hemi = json["moon_phase"]["hemisphere"].string else { return nil }
        
        return Moon(percentIlluminated: perc, age: age, phase: phase, hemisphere: hemi)
    }
    
    func sunFrom(data: NSData?) -> Sun? {
        
        guard let data = data else { return nil }
        let json = JSON(data: data)
        
        guard let risehr = json["sun_phase"]["sunrise"]["hour"].string else { return nil }
        guard let risemin = json["sun_phase"]["sunrise"]["minute"].string else { return nil }
        guard let sethr = json["sun_phase"]["sunset"]["hour"].string else { return nil }
        guard let setmin = json["sun_phase"]["sunset"]["minute"].string else { return nil }
        
        return Sun(riseHour: risehr, riseMinute: risemin, setHour: sethr, setMinute: setmin)
    }
    
}

/*
 
 Example
 
*/

let jsonFile = NSBundle.mainBundle().pathForResource("astronomy", ofType: "json")
let jsonData = NSData(contentsOfFile: jsonFile!)

let parser = MoonSunParser()

let moon = parser.moonFrom(jsonData)

moon?.percentIlluminated
moon?.age
moon?.phase
moon?.hemisphere

let sun = parser.sunFrom(jsonData)

sun?.riseHour
sun?.riseMinute
sun?.setHour
sun?.setMinute
