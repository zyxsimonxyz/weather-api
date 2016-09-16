/*

Forcast playground for parsing 10 day forecast conditions returned as JSON
data from the Weather Underground API.

See the forecast10day.json file located in the Resources folder of this Playground
for a local copy of the json data.

Weather Underground API documentation:
https://www.wunderground.com/weather/api/d/docs

*/

import UIKit

// Model
// -----------------------------------------------------------------------------

struct ForecastText {
    let icon: String
    let title: String
    let text: String
    let pop: String
}

struct ForecastDate {
    let yday: Int
    let weekdayShort: String
    let weekday: String
}

struct ForecastDetail {
    let high: String
    let low: String
    let conditions: String
    let icon: String
    let pop: Float
    let humidity: Float
}

struct ForecastPrecip {
    let qpfAllDay: Float
    let qpfDay: Float?
    let qpfNight: Float?
    let snowAllDay: Float
    let snowDay: Float?
    let snowNight: Float?
}

struct ForecastWind {
    let maxSpeed: Float
    let maxDir: String
    let maxDeg: Float
    let avgSpeed: Float
    let avgDir: String
    let avgDeg: Float
}

// Parser
// -----------------------------------------------------------------------------

class ForecastParser {
    
    let units = 0
    
    /**
     Parse the forecast text returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Array of forecast text structs.
     */
    
    func forecastTextFrom(json: [String: Any]?) -> [ForecastText]? {
        
        guard let json = json else { return nil }
        guard let forecast = json["forecast"] as? [String: Any] else { return nil }
        guard let txtforecast = forecast["txt_forecast"] as? [String: Any] else { return nil }
        guard let forecastday = txtforecast["forecastday"] as? [[String: Any]] else { return nil }
        
        var forecasts = [ForecastText]()
        
        for forecast in forecastday {
            guard let ic = forecast["icon"] as? String else { return nil }
            guard let ti = forecast["title"] as? String else { return nil }
            
            let keyT = units == 0 ? "fcttext" : "fcttext_metric"
            guard let te = forecast[keyT] as? String else { return nil }
            
            guard let po = forecast["pop"] as? String else { return nil }
            
            let fo = ForecastText(icon: ic, title: ti, text: te, pop: po)
            forecasts.append(fo)
        }
        
        return forecasts.count > 0 ? forecasts : nil
    }
    
    /**
     Parse the forecast date returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Array of forecast dates as structs.
     */
    
    func forecastDateFrom(json: [String: Any]?) -> [ForecastDate]? {
        
        guard let json = json else { return nil }
        guard let forecast = json["forecast"] as? [String: Any] else { return nil }
        guard let simpleforecast = forecast["simpleforecast"] as? [String: Any] else { return nil }
        guard let forecastday = simpleforecast["forecastday"] as? [[String: Any]] else { return nil }
        
        var forecasts = [ForecastDate]()
        
        for forecast in forecastday {
            guard let date = forecast["date"] as? [String: Any] else { return nil }
            guard let yd = date["yday"] as? Int else { return nil }
            guard let dayshort = date["weekday_short"] as? String else { return nil }
            guard let day = date["weekday"] as? String else { return nil }
            let fo = ForecastDate(yday: yd, weekdayShort: dayshort, weekday: day)
            forecasts.append(fo)
        }
        return forecasts.count > 0 ? forecasts : nil
    }
    
    /**
     Parse the forecast details returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Array of forecast detail structs.
     */
    
    func forecastDetailFrom(json: [String: Any]?) -> [ForecastDetail]? {
        
        guard let json = json else { return nil }
        guard let forecast = json["forecast"] as? [String: Any] else { return nil }
        guard let simpleforecast = forecast["simpleforecast"] as? [String: Any] else { return nil }
        guard let forecastday = simpleforecast["forecastday"] as? [[String: Any]] else { return nil }
        
        var forecasts = [ForecastDetail]()
        
        for forecast in forecastday {
            let keyHL = units == 0 ? "fahrenheit" : "celsius"
            guard let high = forecast["high"] as? [String: Any] else { return nil }
            guard let low = forecast["low"] as? [String: Any] else { return nil }
            
            guard let hi = high[keyHL] as? String else { return nil }
            guard let lo = low[keyHL] as? String else { return nil }
            guard let co = forecast["conditions"] as? String else { return nil }
            guard let ic = forecast["icon"] as? String else { return nil }
            guard let po = forecast["pop"] as? Float else { return nil }
            guard let hu = forecast["avehumidity"] as? Float else { return nil }
            
            let fo = ForecastDetail(high: hi, low: lo, conditions: co, icon: ic, pop: po, humidity: hu)
            forecasts.append(fo)
        }
        
        return forecasts.count > 0 ? forecasts : nil
    }
    
    /**
     Parse the forecast text returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Array of forecast text structs.
     */
    
    func forecastPrecipFrom(json: [String: Any]?) -> [ForecastPrecip]? {
        
        guard let json = json else { return nil }
        guard let forecast = json["forecast"] as? [String: Any] else { return nil }
        guard let simpleforecast = forecast["simpleforecast"] as? [String: Any] else { return nil }
        guard let forecastday = simpleforecast["forecastday"] as? [[String: Any]] else { return nil }
        
        var forecasts = [ForecastPrecip]()
        
        for forecast in forecastday {
            guard let qpfallday = forecast["qpf_allday"] as? [String: Any] else { return nil }
            guard let qpfday = forecast["qpf_day"] as? [String: Any] else { return nil }
            guard let qpfnight = forecast["qpf_night"] as? [String: Any] else { return nil }
            
            let keyQ = units == 0 ? "in" : "mm"
            guard let qa = qpfallday[keyQ] as? Float else { return nil }
            let qd = qpfday[keyQ] as? Float
            let qn = qpfnight[keyQ] as? Float
            
            guard let snowallday = forecast["snow_allday"] as? [String: Any] else { return nil }
            guard let snowday = forecast["snow_day"] as? [String: Any] else { return nil }
            guard let snownight = forecast["snow_night"] as? [String: Any] else { return nil }
            
            let keyS = units == 0 ? "in" : "cm"
            guard let sa = snowallday[keyS] as? Float else { return nil }
            let sd = snowday[keyS] as? Float
            let sn = snownight[keyS] as? Float
            
            let fo = ForecastPrecip(qpfAllDay: qa, qpfDay: qd, qpfNight: qn, snowAllDay: sa, snowDay: sd, snowNight: sn)
            forecasts.append(fo)
        }
        
        return forecasts.count > 0 ? forecasts : nil
    }
    
    /**
     Parse the forecast wind returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Array of forecast wind structs.
     */
    
    func forecastWindFrom(json: [String: Any]?) -> [ForecastWind]? {
        
        guard let json = json else { return nil }
        guard let forecast = json["forecast"] as? [String: Any] else { return nil }
        guard let simpleforecast = forecast["simpleforecast"] as? [String: Any] else { return nil }
        guard let forecastday = simpleforecast["forecastday"] as? [[String: Any]] else { return nil }
        
        var forecasts = [ForecastWind]()
        
        for forecast in forecastday {
            guard let maxwind = forecast["maxwind"] as? [String: Any] else { return nil }
            guard let avewind = forecast["avewind"] as? [String: Any] else { return nil }
            
            let key = units == 0 ? "mph" : "kph"
            guard let ms = maxwind[key] as? Float else { return nil }
            guard let md = maxwind["dir"] as? String else { return nil }
            guard let mde = maxwind["degrees"] as? Float else { return nil }
            guard let asp = avewind[key] as? Float else { return nil }
            guard let ad = avewind["dir"] as? String else { return nil }
            guard let ade = avewind["degrees"] as? Float else { return nil }
            
            let fo = ForecastWind(maxSpeed: ms, maxDir: md, maxDeg: mde, avgSpeed: asp, avgDir: ad, avgDeg: ade)
            forecasts.append(fo)
        }
        
        return forecasts.count > 0 ? forecasts : nil
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

let parser = ForecastParser()

let forecastText = parser.forecastTextFrom(json: json!)

forecastText?[0].icon
forecastText?[0].title
forecastText?[0].text
forecastText?[0].pop

let forecastDate = parser.forecastDateFrom(json: json!)

forecastDate?[0].yday
forecastDate?[0].weekdayShort
forecastDate?[0].weekday

let forecastDetail = parser.forecastDetailFrom(json: json!)

forecastDetail?[0].high
forecastDetail?[0].low
forecastDetail?[0].conditions
forecastDetail?[0].icon
forecastDetail?[0].pop
forecastDetail?[0].humidity

let forecastPrecip = parser.forecastPrecipFrom(json: json!)

forecastPrecip?[0].qpfAllDay
forecastPrecip?[0].qpfDay
forecastPrecip?[0].qpfNight
forecastPrecip?[0].snowAllDay
forecastPrecip?[0].snowDay
forecastPrecip?[0].snowNight

let forecastWind = parser.forecastWindFrom(json: json!)

forecastWind?[0].maxSpeed
forecastWind?[0].maxDir
forecastWind?[0].maxDeg
forecastWind?[0].avgSpeed
forecastWind?[0].avgDir
forecastWind?[0].avgDeg
