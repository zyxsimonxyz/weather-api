/*
Hourly 10 day forecast from Weather Underground API.

Parse the 10 day forecast conditions into a struct from the Weather Underground located at
http://api.wunderground.com/api/#/hourly10day/q/knoxville,tn.json where # is your API key.

See the hourly10day.json file located in the Resources folder of this Playground for a local copy of
the 10 day hourly conditions json data.
*/

import UIKit

// Model
// ----------------------------------------------------------------------

struct Hourly {
    let yday: String
    let hourcivil: String
    let temp: String
    let pop: String
}

// Parser
// ----------------------------------------------------------------------

class Parser {
    
    let units = 0
    
    /**
     Parse the hourly 10 day forecast data from Weather Underground.
     - Parameter data: The NSData from the Weather Underground API.
     - Returns: Array of Hourly structs for next 240 hours.
     */
    
    func hourlyForecast(fromData: NSData?) -> [Hourly]? {
        guard let data = fromData else { return nil }
        let json = JSON(data: data)
        
        var hourly = [Hourly]()
        
        for (_, item):(String, JSON) in json["hourly_forecast"] {
            guard let yd = item["FCTTIME"]["yday"].string else {return nil}
            guard let hr = item["FCTTIME"]["hour"].string else {return nil}
            
            let keyUnits = units == 0 ? "english" : "metric"
            guard let tp = item["temp"][keyUnits].string else {return nil}
            
            guard let pp = item["pop"].string else {return nil}
            
            let hrly = Hourly(yday: yd, hourcivil: hr, temp: tp, pop: pp)
            hourly.append(hrly)
        }
        
        return hourly.count > 0 ? hourly : nil
    }

}

// Example
// ----------------------------------------------------------------------

let jsonFile = NSBundle.mainBundle().pathForResource("hourly10day", ofType: "json")
let jsonData = NSData(contentsOfFile: jsonFile!)

let hourlyParser = Parser()

let hoursText = hourlyParser.hourlyForecast(jsonData)

hoursText?[0].yday
hoursText?[0].hourcivil
hoursText?[0].temp
hoursText?[0].pop

