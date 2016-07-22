/*

Forecast Conditions Playground

Parse the 10 day forecast conditions into a struct from the Weather Underground located at
http://api.wunderground.com/api/#/forecast10day/q/knoxville,tn.json where # is your API key.

See the forecast10day.json file located in the Resources folder of this Playground for a local copy of
the 10 day forecast conditions json data.

*/

import UIKit

/*
 
 Model
 
*/

struct ForecastText {
    let icon: String
    let title: String
    let text: String
    let pop: String
}

struct ForecastDate {
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

/*
 
 Parser
 
*/

class ForecastParser {
    
    let units = 0
    
    func forecastTextFrom(data: NSData?) -> [ForecastText]? {
        
        guard let data = data else { return nil }
        let json = JSON(data: data)
        
        var forecast = [ForecastText]()
        
        for (_, item):(String, JSON) in json["forecast"]["txt_forecast"]["forecastday"] {
            guard let ic = item["icon"].string else { return nil }
            guard let ti = item["title"].string else { return nil }
            
            let keyT = units == 0 ? "fcttext" : "fcttext_metric"
            guard let te = item[keyT].string else { return nil }
            
            guard let po = item["pop"].string else { return nil }
            
            let fo = ForecastText(icon: ic, title: ti, text: te, pop: po)
            forecast.append(fo)
        }
        
        return forecast.count > 0 ? forecast : nil
    }
    
    func forecastDateFrom(data: NSData?) -> [ForecastDate]? {
        
        guard let data = data else { return nil }
        let json = JSON(data: data)
        
        var forecast = [ForecastDate]()
        
        for (_, item):(String, JSON) in json["forecast"]["simpleforecast"]["forecastday"] {
            guard let dayshort = item["date"]["weekday_short"].string else { return nil }
            guard let day = item["date"]["weekday"].string else { return nil }
            let fo = ForecastDate(weekdayShort: dayshort, weekday: day)
            forecast.append(fo)
        }
        return forecast.count > 0 ? forecast : nil
    }
    
    func forecastDetailFrom(data: NSData?) -> [ForecastDetail]? {
        
        guard let data = data else { return nil }
        let json = JSON(data: data)
        
        var forecast = [ForecastDetail]()
        
        for (_, item):(String, JSON) in json["forecast"]["simpleforecast"]["forecastday"] {
            
            let keyHL = units == 0 ? "fahrenheit" : "celsius"
            guard let hi = item["high"][keyHL].string else { return nil }
            guard let lo = item["low"][keyHL].string else { return nil }
            
            guard let co = item["conditions"].string else { return nil }
            guard let ic = item["icon"].string else { return nil }
            guard let po = item["pop"].float else { return nil }
            guard let hu = item["avehumidity"].float else { return nil }
            
            let fo = ForecastDetail(high: hi, low: lo, conditions: co, icon: ic, pop: po, humidity: hu)
            forecast.append(fo)
        }
        
        return forecast.count > 0 ? forecast : nil
    }
    
    func forecastPrecipFrom(data: NSData?) -> [ForecastPrecip]? {
        
        guard let data = data else { return nil }
        let json = JSON(data: data)
        
        var forecast = [ForecastPrecip]()
        
        for (_, item):(String, JSON) in json["forecast"]["simpleforecast"]["forecastday"] {
            
            let keyQ = units == 0 ? "in" : "mm"
            guard let qa = item["qpf_allday"][keyQ].float else { return nil }
            let qd = item["qpf_day"][keyQ].float
            let qn = item["qpf_night"][keyQ].float
            
            let keyS = units == 0 ? "in" : "cm"
            guard let sa = item["snow_allday"][keyS].float else { return nil }
            let sd = item["snow_day"][keyS].float
            let sn = item["snow_night"][keyS].float
            
            let fo = ForecastPrecip(qpfAllDay: qa, qpfDay: qd, qpfNight: qn, snowAllDay: sa, snowDay: sd, snowNight: sn)
            forecast.append(fo)
        }
        
        return forecast.count > 0 ? forecast : nil
    }
    
    func forecastWindFrom(data: NSData?) -> [ForecastWind]? {
        
        guard let data = data else {return nil }
        let json = JSON(data: data)
        
        var forecast = [ForecastWind]()
        
        for (_, item):(String, JSON) in json["forecast"]["simpleforecast"]["forecastday"] {
            let key = units == 0 ? "mph" : "kph"
            guard let ms = item["maxwind"][key].float else { return nil }
            guard let md = item["maxwind"]["dir"].string else { return nil }
            guard let mde = item["maxwind"]["degrees"].float else { return nil }
            guard let asp = item["avewind"][key].float else { return nil }
            guard let ad = item["avewind"]["dir"].string else { return nil }
            guard let ade = item["avewind"]["degrees"].float else { return nil }
            
            let fo = ForecastWind(maxSpeed: ms, maxDir: md, maxDeg: mde, avgSpeed: asp, avgDir: ad, avgDeg: ade)
            forecast.append(fo)
        }
        
        return forecast.count > 0 ? forecast : nil
    }
    
}

/*
 
 Example
 
*/

let jsonFile = NSBundle.mainBundle().pathForResource("forecast10day", ofType: "json")
let jsonData = NSData(contentsOfFile: jsonFile!)

let parser = ForecastParser()

let forecastText = parser.forecastTextFrom(jsonData)

forecastText?[0].icon
forecastText?[0].title
forecastText?[0].text
forecastText?[0].pop

let forecastDate = parser.forecastDateFrom(jsonData)

forecastDate?[0].weekdayShort
forecastDate?[0].weekday

let forecastDetail = parser.forecastDetailFrom(jsonData)

forecastDetail?[0].high
forecastDetail?[0].low
forecastDetail?[0].conditions
forecastDetail?[0].icon
forecastDetail?[0].pop
forecastDetail?[0].humidity

let forecastPrecip = parser.forecastPrecipFrom(jsonData)

forecastPrecip?[0].qpfAllDay
forecastPrecip?[0].qpfDay
forecastPrecip?[0].qpfNight
forecastPrecip?[0].snowAllDay
forecastPrecip?[0].snowDay
forecastPrecip?[0].snowNight

let forecastWind = parser.forecastWindFrom(jsonData)

forecastWind?[0].maxSpeed
forecastWind?[0].maxDir
forecastWind?[0].maxDeg
forecastWind?[0].avgSpeed
forecastWind?[0].avgDir
forecastWind?[0].avgDeg


