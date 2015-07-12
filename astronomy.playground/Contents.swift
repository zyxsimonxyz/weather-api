//: Astronomy playground

import UIKit

let jsonFile = NSBundle.mainBundle().pathForResource("astronomy", ofType: "json")
let jsonData = NSData(contentsOfFile: jsonFile!)

var err: NSError?
let opts = NSJSONReadingOptions.AllowFragments

let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData!, options: opts, error: &err)

if err == nil {
    "no error"
} else {
    "error"
}

typealias JSON = [String: AnyObject]

if let jsonDict = json as? JSON {
    
    print(jsonDict)
    
    if let moonPhaseDict = jsonDict["moon_phase"] as? JSON {
        
        let percentIlluminated = moonPhaseDict["percentIlluminated"] as? String
        let ageOfMoon = moonPhaseDict["ageOfMoon"] as? String
        let phaseOfMoon = moonPhaseDict["phaseofMoon"] as? String
        let hemisphere = moonPhaseDict["hemisphere"] as? String
        
        let currentTime = moonPhaseDict["current_time"] as? [String: AnyObject]
        
        if let currentTimeDict = moonPhaseDict["current_time"] as? JSON {
            let hour  = currentTimeDict["hour"] as? String
            let minute = currentTimeDict["minute"] as? String
        }
        
        if let sunriseDict = moonPhaseDict["sunrise"] as? JSON {
            let hour = sunriseDict["hour"] as? String
            let minute = sunriseDict["minute"] as? String
        }
        
        if let sunsetDict = moonPhaseDict["sunset"] as? JSON {
            let hour = sunsetDict["hour"] as? String
            let minute = sunsetDict["minute"] as? String
        }
    }
    
    if let sunphaseDict = jsonDict["sun_phase"] as? JSON {
        
        if let sunriseDict = sunphaseDict["sunrise"] as? JSON {
            let hour = sunriseDict["hour"] as? String
            let minutre = sunriseDict["minute"] as? String
        }
        
        if let sunsetDict = sunphaseDict["sunset"] as? JSON {
            let hour = sunsetDict["hour"] as? String
            let minute = sunsetDict["minute"] as? String
        }
    }
    
}
