/*

Current conditions playground for parsing current conditions returned as JSON
data from the Weather Underground API.

See the current.json file located in the Resources folder of this Playground
for a local copy of the json data.

Weather Underground API documentation:
https://www.wunderground.com/weather/api/d/docs

*/

import UIKit

// Model
// -----------------------------------------------------------------------------

struct CurrentLocation {
    let full: String
    let city: String
    let state: String
    let zip: String
    let lat: String
    let lon: String
    let elevation: String
}

struct ObservationLocation {
    let full: String
    let city: String
    let state: String
    let lat: String
    let lon: String
    let elevation: String
}

struct Time {
    let observationTime: String
    let timezoneShort: String
    let timezoneLong: String
}

struct Current {
    let stationId: String
    let weather: String
    let humidity: String
    let pressure: String
    let presstrend: String
    let visibility: String
    let uv: String
    let icon: String
}

struct Wind {
    let direction: String
    let degrees: Float
    let speed: Float
    let gustSpeed: String?
    let chill: String
}

struct Temperature {
    let temp: Float
    let dewpoint: Float
    let heatindex: Float?
    let feelslike: String
}

// Parser
// -----------------------------------------------------------------------------

class CurrentParser {
    
    let units = 0   // if units 0 then Fahrenheight, if unit 1 then Celsius
    
    /**
     Parse the current location returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Single current location struct.
     */
    
    func currentLocationFrom(json: [String: AnyObject]?) -> CurrentLocation? {
        
        guard let json = json else { return nil }
        guard let dict = json["current_observation"]?["display_location"] as? [String: AnyObject] else { return nil }

        guard let full = dict["full"] as? String else { return nil }
        guard let city = dict["city"] as? String else { return nil }
        guard let st = dict["state"] as? String else { return nil }
        guard let zip = dict["zip"] as? String else { return nil }
        guard let lat = dict["latitude"] as? String else { return nil }
        guard let lon = dict["longitude"] as? String else { return nil }
        guard let elev = dict["elevation"] as? String else { return nil }
        
        return CurrentLocation(full: full, city: city, state: st, zip: zip, lat: lat, lon: lon, elevation: elev)
    }
    
    /**
     Parse the observation location returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Single observation location struct.
     */
    
    func observationLocationFrom(json: [String: AnyObject]?) -> ObservationLocation? {
        
        guard let json = json else { return nil }
        guard let dict = json["current_observation"]?["observation_location"] as? [String: AnyObject] else { return nil }
        
        guard let full = dict["full"] as? String else { return nil }
        guard let city = dict["city"] as? String else { return nil }
        guard let st = dict["state"] as? String else { return nil }
        guard let lat = dict["latitude"] as? String else { return nil }
        guard let lon = dict["longitude"] as? String else { return nil }
        guard let el = dict["elevation"] as? String else { return nil }
        
        return ObservationLocation(full: full, city: city, state: st, lat: lat, lon: lon, elevation: el)
    }
    
    /**
     Parse the time returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Single time struct.
     */
    
    func timeFrom(json: [String: AnyObject]?) -> Time? {
        
        guard let json = json else { return nil }
        
        guard let obs = json["current_observation"]?["observation_time"] as? String else { return nil }
        guard let tzshort = json["current_observation"]?["local_tz_short"] as? String else { return nil }
        guard let tzlong = json["current_observation"]?["local_tz_long"] as? String else { return nil }

        return Time(observationTime: obs, timezoneShort: tzshort, timezoneLong: tzlong)
    }
    
    /**
     Parse the current weather returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Single current weather struct.
     */
    
    func currentFrom(json: [String: AnyObject]?) -> Current? {
        
        guard let json = json else { return nil }
        
        guard let st = json["current_observation"]?["station_id"] as? String else { return nil }
        guard let we = json["current_observation"]?["weather"] as? String else { return nil }
        guard let hu = json["current_observation"]?["relative_humidity"] as? String else { return nil }
        
        let keyP = units == 0 ? "pressure_in" : "pressure_mb"
        guard let pr = json["current_observation"]?[keyP] as? String else { return nil }
        
        guard let pt = json["current_observation"]?["pressure_trend"] as? String else { return nil }

        let keyV = units == 0 ? "visibility_mi" : "visibility_km"
        guard let vi = json["current_observation"]?[keyV] as? String else { return nil }

        guard let uv = json["current_observation"]?["UV"] as? String else { return nil }
        guard let ic = json["current_observation"]?["icon"] as? String else { return nil }

        return Current(stationId: st, weather: we, humidity: hu, pressure: pr, presstrend: pt, visibility: vi, uv: uv, icon: ic)
    }
    
    /**
     Parse the wind conditions returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Single wind conditions struct.
     */
    
    func windFrom(json: [String: AnyObject]?) -> Wind? {
        
        guard let json = json else { return nil }
        
        guard let di = json["current_observation"]?["wind_dir"] as? String else { return nil }
        guard let dg = json["current_observation"]?["wind_degrees"] as? Float else { return nil }

        let keyS = units == 0 ? "wind_mph" : "wind_kph"
        guard let sp = json["current_observation"]?[keyS] as? Float else { return nil }
        
        let keyG = units == 0 ? "wind_gust_mph" : "wind_gust_kph"
        let gu = json["current_observation"]?[keyG] as? String
        
        let keyC = units == 0 ? "windchill_f" : "windchill_c"
        guard let ch = json["current_observation"]?[keyC] as? String else { return nil }
        
        return Wind(direction: di, degrees: dg, speed: sp, gustSpeed: gu, chill: ch)
    }
    
    /**
     Parse the temperature returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Single temperature struct.
     */
    
    func tempFrom(json: [String: AnyObject]?) -> Temperature? {
        
        guard let json = json else { return nil }
        
        let keyT = units == 0 ? "temp_f" : "temp_c"
        guard let te = json["current_observation"]?[keyT] as? Float else { return nil }
        
        let keyD = units == 0 ? "dewpoint_f" : "dewpoint_c"
        guard let de = json["current_observation"]?[keyD] as? Float else { return nil }
        
        let keyH = units == 0 ? "heat_index_f" : "heat_index_c"
        let he = json["current_observation"]?[keyH] as? Float

        let keyF = units == 0 ? "feelslike_f" : "feelslike_c"
        guard let fe = json["current_observation"]?[keyF] as? String else { return nil }

        return Temperature(temp: te, dewpoint: de, heatindex: he, feelslike: fe)
    }
    
}

// Example
// -----------------------------------------------------------------------------

let file = NSBundle.mainBundle().pathForResource("current", ofType: "json")
let data = NSData(contentsOfFile: file!)

let json: [String: AnyObject]?

do {
    json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]
} catch let error as NSError {
    json = nil
    print("error is \(error.localizedDescription)")
}

let parser = CurrentParser()

let display = parser.currentLocationFrom(json)

display?.full
display?.city
display?.state
display?.zip
display?.lat
display?.lon
display?.elevation

let observation = parser.observationLocationFrom(json)

observation?.full
observation?.city
observation?.state
observation?.lat
observation?.lon
observation?.elevation

let time = parser.timeFrom(json)

time?.observationTime
time?.timezoneShort
time?.timezoneLong

let current = parser.currentFrom(json)

current?.stationId
current?.weather
current?.humidity
current?.pressure
current?.presstrend
current?.visibility
current?.uv
current?.icon

let wind = parser.windFrom(json)

wind?.direction
wind?.degrees
wind?.speed
wind?.gustSpeed
wind?.chill

let temperature = parser.tempFrom(json)

temperature?.temp
temperature?.dewpoint
temperature?.heatindex
temperature?.feelslike
