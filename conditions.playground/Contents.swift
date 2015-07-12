//: Current Conditions Playground

import UIKit

let jsonFile = NSBundle.mainBundle().pathForResource("current", ofType: "json")
let jsonData = NSData(contentsOfFile: jsonFile!)

var err: NSError?
let opts = NSJSONReadingOptions.AllowFragments

let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData!, options: opts, error: &err)

if err == nil {
    "no error"
} else {
    "error"
}

/*
Class to store properties from current_observation json data
*/

class Current {
    
    typealias JSON = [String: AnyObject]
    
    // "current_observation": { "display_location": {...} }
    let full: String
    let city: String
    let state: String
    let stateName: String
    let country: String
    let zip: String
    let latitude: String
    let longitude: String
    let elevation: String
    
    // "current_observation": { "observation_location": {...} }
    let full2: String
    let city2: String
    let state2: String
    let country2: String
    let latitude2: String
    let longitude2: String
    let elevation2: String
    
    // "current_observation": {...}
    let stationId: String
    let observTime: String
    let tzShort: String
    let tzLong: String
    let weather: String
    let tempF: Float
    let tempC: Float
    let relHum: String
    let windDir: String
    let windDeg: Int
    let windMph: Float
    let windGustMph: Float
    let windKph: Float
    let windGustKph: Float
    let pressureMb: String
    let pressureIn: String
    let dewpointF: Int
    let dewpointC: Int
    let feelsLikeF: String
    let feelsLikeC: String
    let visibilityMi: String
    let visibilityKm: String
    let uv: String
    let precipTodayIn: String
    let precipTodayMm: String
    let icon: String
    
    init(json: AnyObject) {
        
        // display_location dictionary
        if let
            jsonDict = json as? JSON,
            currentObsDict = jsonDict["current_observation"] as? JSON,
            displayLocDict = currentObsDict["display_location"] as? JSON,
            full = displayLocDict["full"] as? String,
            city = displayLocDict["city"] as? String,
            state = displayLocDict["state"] as? String,
            stateName = displayLocDict["state_name"] as? String,
            country = displayLocDict["country"] as? String,
            zip = displayLocDict["zip"] as? String,
            latitude = displayLocDict["latitude"] as? String,
            longitude = displayLocDict["longitude"] as? String,
            elevation = displayLocDict["elevation"] as? String
        {
            self.full = full
            self.city = city
            self.state = state
            self.stateName = stateName
            self.country = country
            self.zip = zip
            self.latitude = latitude
            self.longitude = longitude
            self.elevation = elevation
        }
        else
        {
            self.full = "err"
            self.city = "err"
            self.state = "err"
            self.stateName = "err"
            self.country = "err"
            self.zip = "err"
            self.latitude = "err"
            self.longitude = "err"
            self.elevation = "err"
        }
        
        // observation_location dictionary
        if let
            jsonDict = json as? JSON,
            currentObsDict = jsonDict["current_observation"] as? JSON,
            observationLocDict = currentObsDict["observation_location"] as? JSON,
            full2 = observationLocDict["full"] as? String,
            city2 = observationLocDict["city"] as? String,
            state2 = observationLocDict["state"] as? String,
            country2 = observationLocDict["country"] as? String,
            latitude2 = observationLocDict["latitude"] as? String,
            longitude2 = observationLocDict["longitude"] as? String,
            elevation2 = observationLocDict["elevation"] as? String
        {
            self.full2 = full2
            self.city2 = city2
            self.state2 = state2
            self.country2 = country2
            self.latitude2 = latitude2
            self.longitude2 = longitude2
            self.elevation2 = elevation2
        }
        else
        {
            self.full2 = "err"
            self.city2 = "err"
            self.state2 = "err"
            self.country2 = "err"
            self.latitude2 = "err"
            self.longitude2 = "err"
            self.elevation2 = "err"
        }
        
        // current_observation
        if let
            jsonDict = json as? JSON,
            currentObsDict = jsonDict["current_observation"] as? JSON,
            stationId = currentObsDict["station_id"] as? String,
            observTime = currentObsDict["observation_time"] as? String,
            tzShort = currentObsDict["local_tz_short"] as? String,
            tzLong = currentObsDict["local_tz_long"] as? String,
            weather = currentObsDict["weather"] as? String,
            tempF = currentObsDict["temp_f"] as? Float,
            tempC = currentObsDict["temp_c"] as? Float,
            relHum = currentObsDict["relative_humidity"] as? String,
            windDir = currentObsDict["wind_dir"] as? String,
            windDeg = currentObsDict["wind_degrees"] as? Int,
            windMph = currentObsDict["wind_mph"] as? Float,
            windGustMph = currentObsDict["wind_gust_mph"] as? Float,
            windKph = currentObsDict["wind_kph"] as? Float,
            windGustKph = currentObsDict["wind_gust_kph"] as? Float,
            pressureMb = currentObsDict["pressure_mb"] as? String,
            pressureIn = currentObsDict["pressure_in"] as? String,
            dewpointF = currentObsDict["dewpoint_f"] as? Int,
            dewpointC = currentObsDict["dewpoint_c"] as? Int,
            feelsLikeF = currentObsDict["feelslike_f"] as? String,
            feelsLikeC = currentObsDict["feelslike_c"] as? String,
            visibilityMi = currentObsDict["visibility_mi"] as? String,
            visibilityKm = currentObsDict["visibility_km"] as? String,
            uv = currentObsDict["UV"] as? String,
            precipTodayIn = currentObsDict["precip_today_in"] as? String,
            precipTodayMm = currentObsDict["precip_today_metric"] as? String,
            icon = currentObsDict["icon"] as? String
        {
            self.stationId = stationId
            self.observTime = observTime
            self.tzShort = tzShort
            self.tzLong = tzLong
            self.weather = weather
            self.tempF = tempF
            self.tempC = tempC
            self.relHum = relHum
            self.windDir = windDir
            self.windDeg = windDeg
            self.windMph = windMph
            self.windGustMph = windGustMph
            self.windKph = windKph
            self.windGustKph = windGustKph
            self.pressureMb = pressureMb
            self.pressureIn = pressureIn
            self.dewpointF = dewpointF
            self.dewpointC = dewpointC
            self.feelsLikeF = feelsLikeF
            self.feelsLikeC = feelsLikeC
            self.visibilityMi = visibilityMi
            self.visibilityKm = visibilityKm
            self.uv = uv
            self.precipTodayIn = precipTodayIn
            self.precipTodayMm = precipTodayMm
            self.icon = icon
        }
        else
        {
            self.stationId = "err"
            self.observTime = "err"
            self.tzShort = "err"
            self.tzLong = "err"
            self.weather = "err"
            self.tempF = 99
            self.tempC = 99
            self.relHum = "err"
            self.windDir = "err"
            self.windDeg = 99
            self.windMph = 99
            self.windGustMph = 99
            self.windKph = 99
            self.windGustKph = 99
            self.pressureMb = "err"
            self.pressureIn = "err"
            self.dewpointF = 99
            self.dewpointC = 99
            self.feelsLikeF = "err"
            self.feelsLikeC = "err"
            self.visibilityMi = "err"
            self.visibilityKm = "err"
            self.uv = "err"
            self.precipTodayIn = "err"
            self.precipTodayMm = "err"
            self.icon = "err"
        }
    }
    
}

// Create a current object from the json file then view the values

let current = Current(json: json!)

current.full
current.city
current.state
current.stateName
current.country
current.zip
current.latitude
current.longitude
current.elevation

current.full2
current.city2
current.state2
current.country2
current.latitude2
current.longitude2
current.elevation2

current.stationId
current.observTime
current.tzShort
current.tzLong
current.weather
current.tempF
current.tempC
current.relHum
current.windDir
current.windDeg
current.windMph
current.windGustMph
current.windKph
current.windGustKph
current.pressureMb
current.pressureIn
current.dewpointF
current.dewpointC
current.feelsLikeF
current.feelsLikeC
current.visibilityMi
current.visibilityKm
current.uv
current.precipTodayIn
current.precipTodayMm
current.icon


