/*

Forcast playground for parsing 10 day forecast conditions returned as JSON
data from the Weather Underground API.

See the forecast10day.json file located in the Resources folder of this Playground
for a local copy of the json data.

Weather Underground API documentation:
https://www.wunderground.com/weather/api/d/docs

*/

import UIKit

// Models
// -----------------------------------------------------------------------------

struct ForecastText {
    let icon: String
    let title: String
    let text: String
    let pop: String
}

extension ForecastText {
    
    /// Initialize ForecastText model from JSON data.
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract values from json data
        guard let ic = json["icon"] as? String else { return nil }
        guard let ti = json["title"] as? String else { return nil }
        guard let te = json["fcttext"] as? String else { return nil }
        guard let po = json["pop"] as? String else { return nil }
        
        // set struct properties
        self.icon = ic
        self.title = ti
        self.text = te
        self.pop = po
    }
    
    /// An array of ForecastText structs from JSON data.
    /// - parameter json: JSON data
    
    static func forecastTextArray(json: [String: Any]) -> [ForecastText]? {
        guard let forecast = json["forecast"] as? [String: Any] else { return nil }
        guard let txtforecast = forecast["txt_forecast"] as? [String: Any] else { return nil }
        guard let forecastArray = txtforecast["forecastday"] as? [[String: Any]] else { return nil }
        let forecasts = forecastArray.flatMap{ ForecastText(json: $0) }
        return forecasts.count > 0 ? forecasts : nil    // if array has no elements return nil
    }
}


struct ForecastDate {
    let yday: Int
    let weekdayShort: String
    let weekday: String
}

extension ForecastDate {
    
    /// Initialize ForecastDate model from JSON data.
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract dictionary from json data
        guard let date = json["date"] as? [String: Any] else { return nil }

        // extract values from dictionary
        guard let yd = date["yday"] as? Int else { return nil }
        guard let dayshort = date["weekday_short"] as? String else { return nil }
        guard let day = date["weekday"] as? String else { return nil }
        
        // set struct properties
        self.yday = yd
        self.weekdayShort = dayshort
        self.weekday = day
    }
    
    /// An array of ForecastDate structs from JSON data.
    /// - parameter json: JSON data
    
    static func forecastDateArray(json: [String: Any]) -> [ForecastDate]? {
        guard let forecast = json["forecast"] as? [String: Any] else { return nil }
        guard let simpleforecast = forecast["simpleforecast"] as? [String: Any] else { return nil }
        guard let forecastArray = simpleforecast["forecastday"] as? [[String: Any]] else { return nil }
        let forecasts = forecastArray.flatMap{ ForecastDate(json: $0) }
        return forecasts.count > 0 ? forecasts : nil    // if array has no elements return nil
    }
}


struct ForecastDetail {
    let high: String
    let low: String
    let conditions: String
    let icon: String
    let pop: Float
    let humidity: Float
}

extension ForecastDetail {
    
    /// Initialize ForecastDetail model from JSON data.
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract dictionaries from json data
        guard let high = json["high"] as? [String: Any] else { return nil }
        guard let low = json["low"] as? [String: Any] else { return nil }
        
        // extract values from dictionaries
        guard let hi = high["fahrenheit"] as? String else { return nil }
        guard let lo = low["fahrenheit"] as? String else { return nil }
        guard let co = json["conditions"] as? String else { return nil }
        guard let ic = json["icon"] as? String else { return nil }
        guard let po = json["pop"] as? Float else { return nil }
        guard let hu = json["avehumidity"] as? Float else { return nil }
        
        // set struct properties
        self.high = hi
        self.low = lo
        self.conditions = co
        self.icon = ic
        self.pop = po
        self.humidity = hu
    }
    
    /// An array of ForecastDetail structs from JSON data.
    /// - parameter json: JSON data
    
    static func forecastDetialArray(json: [String: Any]) -> [ForecastDetail]? {
        guard let forecast = json["forecast"] as? [String: Any] else { return nil }
        guard let simpleforecast = forecast["simpleforecast"] as? [String: Any] else { return nil }
        guard let forecastArray = simpleforecast["forecastday"] as? [[String: Any]] else { return nil }
        let forecasts = forecastArray.flatMap{ ForecastDetail(json: $0) }
        return forecasts.count > 0 ? forecasts : nil    // if array has no elements return nil
    }
}


struct ForecastPrecip {
    let qpfAllDay: Float
    let qpfDay: Float?
    let qpfNight: Float?
    let snowAllDay: Float
    let snowDay: Float?
    let snowNight: Float?
}

extension ForecastPrecip {
    
    /// Initialize ForecastPrecip model from JSON data.
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract dictionaries from json data
        guard let qpfallday = json["qpf_allday"] as? [String: Any] else { return nil }
        guard let qpfday = json["qpf_day"] as? [String: Any] else { return nil }
        guard let qpfnight = json["qpf_night"] as? [String: Any] else { return nil }
        guard let snowallday = json["snow_allday"] as? [String: Any] else { return nil }
        guard let snowday = json["snow_day"] as? [String: Any] else { return nil }
        guard let snownight = json["snow_night"] as? [String: Any] else { return nil }
        
        // extract values from dictionaries
        guard let qa = qpfallday["in"] as? Float else { return nil }
        let qd = qpfday["in"] as? Float
        let qn = qpfnight["in"] as? Float
        guard let sa = snowallday["in"] as? Float else { return nil }
        let sd = snowday["in"] as? Float
        let sn = snownight["in"] as? Float
        
        // set struct properties
        self.qpfAllDay = qa
        self.qpfDay = qd
        self.qpfNight = qn
        self.snowAllDay = sa
        self.snowDay = sd
        self.snowNight = sn
    }
    
    /// An array of ForecastPrecip structs from JSON data.
    /// - parameter json: JSON data
    
    static func forecastPrecipArray(json: [String: Any]) -> [ForecastPrecip]? {
        guard let forecast = json["forecast"] as? [String: Any] else { return nil }
        guard let simpleforecast = forecast["simpleforecast"] as? [String: Any] else { return nil }
        guard let forecastArray = simpleforecast["forecastday"] as? [[String: Any]] else { return nil }
        let forecasts = forecastArray.flatMap{ ForecastPrecip(json: $0) }
        return forecasts.count > 0 ? forecasts : nil    // if array has no elements return nil
    }
}


struct ForecastWind {
    let maxSpeed: Float
    let maxDir: String
    let maxDeg: Float
    let avgSpeed: Float
    let avgDir: String
    let avgDeg: Float
}

extension ForecastWind {
    
    /// Initialize ForecastWind model from JSON data.
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract dictionaries from json data
        guard let maxwind = json["maxwind"] as? [String: Any] else { return nil }
        guard let avewind = json["avewind"] as? [String: Any] else { return nil }
        
        // extract values from dictionaries
        guard let ms = maxwind["mph"] as? Float else { return nil }
        guard let md = maxwind["dir"] as? String else { return nil }
        guard let mde = maxwind["degrees"] as? Float else { return nil }
        guard let asp = avewind["mph"] as? Float else { return nil }
        guard let ad = avewind["dir"] as? String else { return nil }
        guard let ade = avewind["degrees"] as? Float else { return nil }
        
        // set struct properties
        self.maxSpeed = ms
        self.maxDir = md
        self.maxDeg = mde
        self.avgSpeed = asp
        self.avgDir = ad
        self.avgDeg = ade
    }
    
    /// An array of ForecastWind structs from JSON data.
    /// - parameter json: JSON data
    
    static func forecastWindArray(json: [String: Any]) -> [ForecastWind]? {
        guard let forecast = json["forecast"] as? [String: Any] else { return nil }
        guard let simpleforecast = forecast["simpleforecast"] as? [String: Any] else { return nil }
        guard let forecastArray = simpleforecast["forecastday"] as? [[String: Any]] else { return nil }
        let forecasts = forecastArray.flatMap{ ForecastWind(json: $0) }
        return forecasts.count > 0 ? forecasts : nil    // if array has no elements return nil
    }
}


// Example
// -----------------------------------------------------------------------------

let file = Bundle.main.url(forResource: "forecast10day", withExtension: "json")
let data = try Data(contentsOf: file!)

let json: [String: Any]?

do {
    json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
} catch {
    json = nil
    print("Error is \(error.localizedDescription)")
}

let forecastText = ForecastText.forecastTextArray(json: json!)

forecastText?[0].icon
forecastText?[0].title
forecastText?[0].text
forecastText?[0].pop

let forecastDate = ForecastDate.forecastDateArray(json: json!)

forecastDate?[0].yday
forecastDate?[0].weekdayShort
forecastDate?[0].weekday

let forecastDetail = ForecastDetail.forecastDetialArray(json: json!)

forecastDetail?[0].high
forecastDetail?[0].low
forecastDetail?[0].conditions
forecastDetail?[0].icon
forecastDetail?[0].pop
forecastDetail?[0].humidity

let forecastPrecip = ForecastPrecip.forecastPrecipArray(json: json!)

forecastPrecip?[0].qpfAllDay
forecastPrecip?[0].qpfDay
forecastPrecip?[0].qpfNight
forecastPrecip?[0].snowAllDay
forecastPrecip?[0].snowDay
forecastPrecip?[0].snowNight

let forecastWind = ForecastWind.forecastWindArray(json: json!)

forecastWind?[0].maxSpeed
forecastWind?[0].maxDir
forecastWind?[0].maxDeg
forecastWind?[0].avgSpeed
forecastWind?[0].avgDir
forecastWind?[0].avgDeg

