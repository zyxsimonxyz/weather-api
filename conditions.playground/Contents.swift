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
    
    func currentLocationFrom(json: [String: Any]?) -> CurrentLocation? {
        
        guard let json = json else { return nil }
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        guard let location = observe["display_location"] as? [String: Any] else { return nil }

        guard let full = location["full"] as? String else { return nil }
        guard let city = location["city"] as? String else { return nil }
        guard let st = location["state"] as? String else { return nil }
        guard let zip = location["zip"] as? String else { return nil }
        guard let lat = location["latitude"] as? String else { return nil }
        guard let lon = location["longitude"] as? String else { return nil }
        guard let elev = location["elevation"] as? String else { return nil }
        
        return CurrentLocation(full: full, city: city, state: st, zip: zip, lat: lat, lon: lon, elevation: elev)
    }
    
    /**
     Parse the observation location returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Single observation location struct.
     */
    
    func observationLocationFrom(json: [String: Any]?) -> ObservationLocation? {
        
        guard let json = json else { return nil }
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        guard let location = observe["display_location"] as? [String: Any] else { return nil }
        
        guard let full = location["full"] as? String else { return nil }
        guard let city = location["city"] as? String else { return nil }
        guard let st = location["state"] as? String else { return nil }
        guard let lat = location["latitude"] as? String else { return nil }
        guard let lon = location["longitude"] as? String else { return nil }
        guard let el = location["elevation"] as? String else { return nil }
        
        return ObservationLocation(full: full, city: city, state: st, lat: lat, lon: lon, elevation: el)
    }
    
    /**
     Parse the time returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Single time struct.
     */
    
    func timeFrom(json: [String: Any]?) -> Time? {
        
        guard let json = json else { return nil }
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        
        guard let obs = observe["observation_time"] as? String else { return nil }
        guard let tzshort = observe["local_tz_short"] as? String else { return nil }
        guard let tzlong = observe["local_tz_long"] as? String else { return nil }

        return Time(observationTime: obs, timezoneShort: tzshort, timezoneLong: tzlong)
    }
    
    /**
     Parse the current weather returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Single current weather struct.
     */
    
    func currentFrom(json: [String: Any]?) -> Current? {
        
        guard let json = json else { return nil }
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }

        guard let st = observe["station_id"] as? String else { return nil }
        guard let we = observe["weather"] as? String else { return nil }
        guard let hu = observe["relative_humidity"] as? String else { return nil }
        
        let keyP = units == 0 ? "pressure_in" : "pressure_mb"
        guard let pr = observe[keyP] as? String else { return nil }
        
        guard let pt = observe["pressure_trend"] as? String else { return nil }

        let keyV = units == 0 ? "visibility_mi" : "visibility_km"
        guard let vi = observe[keyV] as? String else { return nil }

        guard let uv = observe["UV"] as? String else { return nil }
        guard let ic = observe["icon"] as? String else { return nil }

        return Current(stationId: st, weather: we, humidity: hu, pressure: pr, presstrend: pt, visibility: vi, uv: uv, icon: ic)
    }
    
    /**
     Parse the wind conditions returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Single wind conditions struct.
     */
    
    func windFrom(json: [String: Any]?) -> Wind? {
        
        guard let json = json else { return nil }
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        
        guard let di = observe["wind_dir"] as? String else { return nil }
        guard let dg = observe["wind_degrees"] as? Float else { return nil }

        let keyS = units == 0 ? "wind_mph" : "wind_kph"
        guard let sp = observe[keyS] as? Float else { return nil }
        
        let keyG = units == 0 ? "wind_gust_mph" : "wind_gust_kph"
        let gu = observe[keyG] as? String
        
        let keyC = units == 0 ? "windchill_f" : "windchill_c"
        guard let ch = observe[keyC] as? String else { return nil }
        
        return Wind(direction: di, degrees: dg, speed: sp, gustSpeed: gu, chill: ch)
    }
    
    /**
     Parse the temperature returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Single temperature struct.
     */
    
    func tempFrom(json: [String: Any]?) -> Temperature? {
        
        guard let json = json else { return nil }
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        
        let keyT = units == 0 ? "temp_f" : "temp_c"
        guard let te = observe[keyT] as? Float else { return nil }
        
        let keyD = units == 0 ? "dewpoint_f" : "dewpoint_c"
        guard let de = observe[keyD] as? Float else { return nil }
        
        let keyH = units == 0 ? "heat_index_f" : "heat_index_c"
        let he = observe[keyH] as? Float

        let keyF = units == 0 ? "feelslike_f" : "feelslike_c"
        guard let fe = observe[keyF] as? String else { return nil }

        return Temperature(temp: te, dewpoint: de, heatindex: he, feelslike: fe)
    }
    
}

// Example
// -----------------------------------------------------------------------------

let file = Bundle.main.url(forResource: "current", withExtension: "json")
let data = try Data(contentsOf: file!)

let json: [String: Any]?

do {
    json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
} catch {
    json = nil
    print("Error is \(error.localizedDescription)")
}

let parser = CurrentParser()

let display = parser.currentLocationFrom(json: json!)

display?.full
display?.city
display?.state
display?.zip
display?.lat
display?.lon
display?.elevation

let observation = parser.observationLocationFrom(json: json!)

observation?.full
observation?.city
observation?.state
observation?.lat
observation?.lon
observation?.elevation

let time = parser.timeFrom(json: json!)

time?.observationTime
time?.timezoneShort
time?.timezoneLong

let current = parser.currentFrom(json: json!)

current?.stationId
current?.weather
current?.humidity
current?.pressure
current?.presstrend
current?.visibility
current?.uv
current?.icon

let wind = parser.windFrom(json: json!)

wind?.direction
wind?.degrees
wind?.speed
wind?.gustSpeed
wind?.chill

let temperature = parser.tempFrom(json: json!)

temperature?.temp
temperature?.dewpoint
temperature?.heatindex
temperature?.feelslike
