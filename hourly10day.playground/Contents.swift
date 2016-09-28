/*

Hourly 10 day forecast playground for parsing forecast data from the Weather
Underground API.

See the hourly10day.json file located in the Resources folder of this
Playground for a local copy of the json data.

Weather Underground API documentation:
https://www.wunderground.com/weather/api/d/docs

*/

import UIKit

// Model
// -----------------------------------------------------------------------------

struct Hourly {
    let yday: String
    let hourcivil: String
    let temp: String
    let humidity: String
    let pop: String
}

struct HourlyWind {
    let speed: String
    let direction: String
    let degrees: String
}

// Parser
// -----------------------------------------------------------------------------

class HourlyParser {
    
    let units = 0
    
    /**
     Parse the hourly 10 day forecast returned as json data from Weather Underground.
     - Parameter json: Dictionary representing json data.
     - Returns: Array of hourly structs.
     */
    
    func hourlyForecastFrom(_ json: [String: Any]) -> [Hourly]? {
        
        guard let hourlyArray = json["hourly_forecast"] as? [[String: Any]] else { return nil }
        
        var hourly = [Hourly]()
        let keyUnits = units == 0 ? "english" : "metric"
        
        for hour in hourlyArray {
            guard let fcttime = hour["FCTTIME"] as? [String: String] else { return nil }
            guard let temp = hour["temp"] as? [String: String] else { return nil }
            
            guard let yd = fcttime["yday"] else { return nil }
            guard let hr = fcttime["civil"] else { return nil }
            guard let tp = temp[keyUnits] else { return nil }
            guard let hm = hour["humidity"] as? String else { return nil }
            guard let pp = hour["pop"] as? String else { return nil }
            let hrly = Hourly(yday: yd, hourcivil: hr, temp: tp, humidity: hm, pop: pp)
            hourly.append(hrly)
        }
        
        return hourly.count > 0 ? hourly : nil
    }
    
    func hourlyWindFrom(_ json: [String: Any]) -> [HourlyWind]? {
        guard let hourlyArray = json["hourly_forecast"] as? [[String: Any]] else { return nil }

        var hourly = [HourlyWind]()
        let keyUnits = units == 0 ? "english" : "metric"
        
        for hour in hourlyArray {
            guard let wspd = hour["wspd"] as? [String: String] else { return nil }
            guard let wdir = hour["wdir"] as? [String: String] else { return nil }
            
            guard let sp = wspd[keyUnits] else { return nil }
            guard let dir = wdir["dir"] else { return nil }
            guard let deg = wdir["degrees"] else { return nil }
            let hrly = HourlyWind(speed: sp, direction: dir, degrees: deg)
            hourly.append(hrly)
        }
        
        return hourly.count > 0 ? hourly : nil
    }

}

// Example
// -----------------------------------------------------------------------------

let file = Bundle.main.url(forResource: "hourly10day", withExtension: "json")
let data = try Data(contentsOf: file!)

let json: [String: Any]?

do {
    json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
} catch {
    json = nil
    print("Error is \(error.localizedDescription)")
}

let parser = HourlyParser()

let hourly = parser.hourlyForecastFrom(json!)

hourly?.count
hourly?[0].yday
hourly?[0].hourcivil
hourly?[0].temp
hourly?[0].humidity
hourly?[0].pop

let hourlyWind = parser.hourlyWindFrom(json!)

hourlyWind?.count
hourlyWind?[0].speed
hourlyWind?[0].direction
hourlyWind?[0].degrees
