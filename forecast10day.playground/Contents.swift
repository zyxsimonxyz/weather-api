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
    
    func forecastTextFrom(json: [String: AnyObject]?) -> [ForecastText]? {
        
        guard let json = json else { return nil }
        guard let jsonArray = json["forecast"]?["txt_forecast"]??["forecastday"] as? [[String: AnyObject]] else { return nil }
        
        var forecasts = [ForecastText]()
        
        for forecast in jsonArray {
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
    
    func forecastDateFrom(json: [String: AnyObject]?) -> [ForecastDate]? {
        
        guard let json = json else { return nil }
        guard let jsonArray = json["forecast"]?["simpleforecast"]??["forecastday"] as? [[String: AnyObject]] else { return nil }
        
        var forecasts = [ForecastDate]()
        
        for forecast in jsonArray {
            guard let yd = forecast["date"]?["yday"] as? Int else { return nil }
            guard let dayshort = forecast["date"]?["weekday_short"] as? String else { return nil }
            guard let day = forecast["date"]?["weekday"] as? String else { return nil }
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
    
    func forecastDetailFrom(json: [String: AnyObject]?) -> [ForecastDetail]? {
        
        guard let json = json else { return nil }
        guard let jsonArray = json["forecast"]?["simpleforecast"]??["forecastday"] as? [[String: AnyObject]] else { return nil }
        
        var forecasts = [ForecastDetail]()
        
        for forecast in jsonArray {
            
            let keyHL = units == 0 ? "fahrenheit" : "celsius"
            guard let hi = forecast["high"]?[keyHL] as? String else { return nil }
            guard let lo = forecast["low"]?[keyHL] as? String else { return nil }
            
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
    
    func forecastPrecipFrom(json: [String: AnyObject]?) -> [ForecastPrecip]? {
        
        guard let json = json else { return nil }
        guard let jsonArray = json["forecast"]?["simpleforecast"]??["forecastday"] as? [[String: AnyObject]] else { return nil }
        
        var forecasts = [ForecastPrecip]()
        
        for forecast in jsonArray {
            
            let keyQ = units == 0 ? "in" : "mm"
            guard let qa = forecast["qpf_allday"]?[keyQ] as? Float else { return nil }
            let qd = forecast["qpf_day"]?[keyQ] as? Float
            let qn = forecast["qpf_night"]?[keyQ] as? Float
            
            let keyS = units == 0 ? "in" : "cm"
            guard let sa = forecast["snow_allday"]?[keyS] as? Float else { return nil }
            let sd = forecast["snow_day"]?[keyS] as? Float
            let sn = forecast["snow_night"]?[keyS] as? Float
            
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
    
    func forecastWindFrom(json: [String: AnyObject]?) -> [ForecastWind]? {
        
        guard let json = json else { return nil }
        guard let jsonArray = json["forecast"]?["simpleforecast"]??["forecastday"] as? [[String: AnyObject]] else { return nil }
        
        var forecasts = [ForecastWind]()
        
        for forecast in jsonArray {
            let key = units == 0 ? "mph" : "kph"
            guard let ms = forecast["maxwind"]?[key] as? Float else { return nil }
            guard let md = forecast["maxwind"]?["dir"] as? String else { return nil }
            guard let mde = forecast["maxwind"]?["degrees"] as? Float else { return nil }
            guard let asp = forecast["avewind"]?[key] as? Float else { return nil }
            guard let ad = forecast["avewind"]?["dir"] as? String else { return nil }
            guard let ade = forecast["avewind"]?["degrees"] as? Float else { return nil }
            
            let fo = ForecastWind(maxSpeed: ms, maxDir: md, maxDeg: mde, avgSpeed: asp, avgDir: ad, avgDeg: ade)
            forecasts.append(fo)
        }
        
        return forecasts.count > 0 ? forecasts : nil
    }
    
}

// Example
// -----------------------------------------------------------------------------

let file = NSBundle.mainBundle().pathForResource("forecast10day", ofType: "json")
let data = NSData(contentsOfFile: file!)

let json: [String: AnyObject]?

do {
    json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]
} catch let error as NSError {
    json = nil
    print("error is \(error.localizedDescription)")
}

let parser = ForecastParser()

let forecastText = parser.forecastTextFrom(json)

forecastText?[0].icon
forecastText?[0].title
forecastText?[0].text
forecastText?[0].pop

let forecastDate = parser.forecastDateFrom(json)

forecastDate?[0].yday
forecastDate?[0].weekdayShort
forecastDate?[0].weekday

let forecastDetail = parser.forecastDetailFrom(json)

forecastDetail?[0].high
forecastDetail?[0].low
forecastDetail?[0].conditions
forecastDetail?[0].icon
forecastDetail?[0].pop
forecastDetail?[0].humidity

let forecastPrecip = parser.forecastPrecipFrom(json)

forecastPrecip?[0].qpfAllDay
forecastPrecip?[0].qpfDay
forecastPrecip?[0].qpfNight
forecastPrecip?[0].snowAllDay
forecastPrecip?[0].snowDay
forecastPrecip?[0].snowNight

let forecastWind = parser.forecastWindFrom(json)

forecastWind?[0].maxSpeed
forecastWind?[0].maxDir
forecastWind?[0].maxDeg
forecastWind?[0].avgSpeed
forecastWind?[0].avgDir
forecastWind?[0].avgDeg
