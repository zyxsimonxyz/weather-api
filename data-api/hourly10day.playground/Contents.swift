/*

Hourly 10 day forecast playground for parsing forecast data from the Weather
Underground API.

See the hourly10day.json file located in the Resources folder of this
Playground for a local copy of the json data.

Weather Underground API documentation:
https://www.wunderground.com/weather/api/d/docs

*/

import UIKit

// Models
// -----------------------------------------------------------------------------

struct Hourly {
    let yday: String
    let hourcivil: String
    let temp: String
    let humidity: String
    let pop: String
}

extension Hourly {
    
    /// Initialize Hourly struct from JSON data
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract dictionaries
        guard let fcttime = json["FCTTIME"] as? [String: String] else { return nil }
        guard let temp = json["temp"] as? [String: String] else { return nil }
        
        // extract values from dictionaries
        guard let yd = fcttime["yday"] else { return nil }
        guard let hr = fcttime["civil"] else { return nil }
        guard let tp = temp["english"] else { return nil }
        guard let hm = json["humidity"] as? String else { return nil }
        guard let pp = json["pop"] as? String else { return nil }
        
        // set struct properties
        self.yday = yd
        self.hourcivil = hr
        self.temp = tp
        self.humidity = hm
        self.pop = pp
    }
    
    /// An array of Hourly structs from JSON data.
    /// - parameter json: JSON data
    
    static func hourlyArray(json: [String: Any]) -> [Hourly]? {
        guard let hourlyArray = json["hourly_forecast"] as? [[String: Any]] else { return nil }
        let hourly = hourlyArray.flatMap{ Hourly(json: $0) }
        return hourly.count > 239 ? hourly : nil  // if array is missing an element return nil
    }
    
}


struct HourlyWind {
    let speed: String
    let direction: String
    let degrees: String
}

extension HourlyWind {
    
    /// Initialize HourlyWind struct from JSON data
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract dictionaries
        guard let wspd = json["wspd"] as? [String: String] else { return nil }
        guard let wdir = json["wdir"] as? [String: String] else { return nil }
        
        // extract values from dictionaries
        guard let spd = wspd["english"] else { return nil }
        guard let dir = wdir["dir"] else { return nil }
        guard let deg = wdir["degrees"] else { return nil }
        
        // set struct properties
        self.speed = spd
        self.direction = dir
        self.degrees = deg
    }
    
    /// An array of HourlyWind structs from JSON data.
    /// - parameter json: JSON data
    
    static func hourlyWindArray(json: [String: Any]) -> [HourlyWind]? {
        guard let hourlyArray = json["hourly_forecast"] as? [[String: Any]] else { return nil }
        let hourlyWind = hourlyArray.flatMap{ HourlyWind(json: $0) }
        return hourlyWind.count > 239 ? hourlyWind : nil  // if array is missing an element return nil

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

let hourly = Hourly.hourlyArray(json: json!)

hourly?.count
hourly?[0].yday
hourly?[0].hourcivil
hourly?[0].temp
hourly?[0].humidity
hourly?[0].pop

let hourlyWind = HourlyWind.hourlyWindArray(json: json!)

hourlyWind?.count
hourlyWind?[0].speed
hourlyWind?[0].direction
hourlyWind?[0].degrees
