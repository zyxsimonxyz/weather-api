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
    let pop: String
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
    
    func hourlyForecastFrom(json: [String: Any]?) -> [Hourly]? {
        
        guard let hourlyArray = json?["hourly_forecast"] as? [[String: AnyObject]] else { return nil }
        
        var hourly = [Hourly]()
        let keyUnits = units == 0 ? "english" : "metric"
        
        for hour in hourlyArray {
            if let yd = hour["FCTTIME"]?["yday"] as? String,
            let hr = hour["FCTTIME"]?["civil"] as? String,
            let tp = hour["temp"]?[keyUnits] as? String,
            let pp = hour["pop"] as? String {
                let hrly = Hourly(yday: yd, hourcivil: hr, temp: tp, pop: pp)
                hourly.append(hrly)
            }
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
let hourly = parser.hourlyForecastFrom(json: json!)

hourly?.count
hourly?[0].yday
hourly?[0].hourcivil
hourly?[0].temp
hourly?[0].pop
