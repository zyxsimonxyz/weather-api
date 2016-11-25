/*

Current conditions playground for parsing current conditions returned as JSON
data from the Weather Underground API.

See the current.json file located in the Resources folder of this Playground
for a local copy of the json data.

Weather Underground API documentation:
https://www.wunderground.com/weather/api/d/docs

*/

import UIKit

// Models
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

extension CurrentLocation {
    
    init?(json: [String: Any]) {
        
        // extract dictionaries from json data
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        guard let location = observe["display_location"] as? [String: Any] else { return nil }
        
        // extract values from dictionaries
        guard let full = location["full"] as? String else { return nil }
        guard let city = location["city"] as? String else { return nil }
        guard let st = location["state"] as? String else { return nil }
        guard let zip = location["zip"] as? String else { return nil }
        guard let lat = location["latitude"] as? String else { return nil }
        guard let lon = location["longitude"] as? String else { return nil }
        guard let elev = location["elevation"] as? String else { return nil }
        
        // set struct properties
        self.full = full
        self.city = city
        self.state = st
        self.zip = zip
        self.lat = lat
        self.lon = lon
        self.elevation = elev
    }
}


struct ObservationLocation {
    let full: String
    let city: String
    let state: String
    let lat: String
    let lon: String
    let elevation: String
}

extension ObservationLocation {
    
    init?(json: [String: Any]) {
        
        // extract dictionaries from json data
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        guard let location = observe["display_location"] as? [String: Any] else { return nil }
        
        // extract values from dictionaries
        guard let full = location["full"] as? String else { return nil }
        guard let city = location["city"] as? String else { return nil }
        guard let st = location["state"] as? String else { return nil }
        guard let lat = location["latitude"] as? String else { return nil }
        guard let lon = location["longitude"] as? String else { return nil }
        guard let el = location["elevation"] as? String else { return nil }
        
        // set struct properties
        self.full = full
        self.city = city
        self.state = st
        self.lat = lat
        self.lon = lon
        self.elevation = el
    }
}


struct Time {
    let observationTime: String
    let timezoneShort: String
    let timezoneLong: String
}

extension Time {
    
    init?(json: [String: Any]) {
        
        // extract dictionary from json data
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        
        // extract values from dictionary
        guard let obs = observe["observation_time"] as? String else { return nil }
        guard let tzshort = observe["local_tz_short"] as? String else { return nil }
        guard let tzlong = observe["local_tz_long"] as? String else { return nil }
        
        // set struct properties
        self.observationTime = obs
        self.timezoneShort = tzshort
        self.timezoneLong = tzlong
    }
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

extension Current {
    
    init?(json: [String: Any]) {
        
        // extract dictionary from json data
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        
        // extract values from dictionary
        guard let st = observe["station_id"] as? String else { return nil }
        guard let we = observe["weather"] as? String else { return nil }
        guard let hu = observe["relative_humidity"] as? String else { return nil }
        guard let pr = observe["pressure_in"] as? String else { return nil }
        guard let pt = observe["pressure_trend"] as? String else { return nil }
        guard let vi = observe["visibility_mi"] as? String else { return nil }
        guard let uv = observe["UV"] as? String else { return nil }
        guard let ic = observe["icon"] as? String else { return nil }
        
        // set struct properties
        self.stationId = st
        self.weather = we
        self.humidity = hu
        self.pressure = pr
        self.presstrend = pt
        self.visibility = vi
        self.uv = uv
        self.icon = ic
    }
}


struct Wind {
    let direction: String
    let degrees: Float
    let speed: Float
    let gustSpeed: String?
    let chill: String
}

extension Wind {
    
    init?(json: [String: Any]) {
        
        // extract dictionary from json data
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        
        // extract values from dictionary
        guard let di = observe["wind_dir"] as? String else { return nil }
        guard let dg = observe["wind_degrees"] as? Float else { return nil }
        guard let sp = observe["wind_mph"] as? Float else { return nil }
        let gu = observe["wind_gust_mph"] as? String
        guard let ch = observe["windchill_f"] as? String else { return nil }
        
        // set struct properties
        self.direction = di
        self.degrees = dg
        self.speed = sp
        self.gustSpeed = gu
        self.chill = ch
    }
}


struct Temperature {
    let temp: Float
    let dewpoint: Float
    let heatindex: Float?
    let feelslike: String
}

extension Temperature {
    
    init?(json: [String: Any]) {
        
        // extract dictionary from json data
        guard let observe = json["current_observation"] as? [String: Any] else { return nil }
        
        // extract values from dictionary
        guard let te = observe["temp_f"] as? Float else { return nil }
        guard let de = observe["dewpoint_f"] as? Float else { return nil }
        let he = observe["heat_index_f"] as? Float
        guard let fe = observe["feelslike_f"] as? String else { return nil }
        
        // set struct properties
        self.temp = te
        self.dewpoint = de
        self.heatindex = he
        self.feelslike = fe
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

let display = CurrentLocation(json: json!)

display?.full
display?.city
display?.state
display?.zip
display?.lat
display?.lon
display?.elevation

let observation = ObservationLocation(json: json!)

observation?.full
observation?.city
observation?.state
observation?.lat
observation?.lon
observation?.elevation

let time = Time(json: json!)

time?.observationTime
time?.timezoneShort
time?.timezoneLong

let current = Current(json: json!)

current?.stationId
current?.weather
current?.humidity
current?.pressure
current?.presstrend
current?.visibility
current?.uv
current?.icon

let wind = Wind(json: json!)

wind?.direction
wind?.degrees
wind?.speed
wind?.gustSpeed
wind?.chill

let temperature = Temperature(json: json!)

temperature?.temp
temperature?.dewpoint
temperature?.heatindex
temperature?.feelslike
