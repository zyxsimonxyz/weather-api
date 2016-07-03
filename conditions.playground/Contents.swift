/*
 
 Current Conditions Playground
 
 Parse the current weather conditions into a struct from the Weather Underground located at
 http://api.wunderground.com/api/#/conditions/q/knoxville,tn.json where # is your API key.
 
 See the current.json file located in the Resources folder of this Playground for a local copy of 
 the current conditions json data.
 
 */

import UIKit

/*
 
 Model
 
*/

struct DisplayLocation {
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
    let gustSpeed: Float
    let chill: String
}

struct Temperature {
    let temp: Float
    let dewpoint: Float
    let heatindex: Float?
    let feelslike: String
}

/*
 
 Parser
 
*/

class CurrentParser {
    
    let units = 0   // if units 0 then Fahrenheight, if unit 1 then Celsius
    
    func displayLocationFrom(data: NSData?) -> DisplayLocation? {
        guard let data = data else { return nil }
        let json = JSON(data: data)

        guard let full = json["current_observation"]["display_location"]["full"].string else { return nil }
        guard let city = json["current_observation"]["display_location"]["city"].string else { return nil }
        guard let st = json["current_observation"]["display_location"]["state"].string else { return nil }
        guard let zip = json["current_observation"]["display_location"]["zip"].string else { return nil }
        guard let lat = json["current_observation"]["display_location"]["latitude"].string else { return nil }
        guard let lon = json["current_observation"]["display_location"]["longitude"].string else { return nil }
        guard let elev = json["current_observation"]["display_location"]["elevation"].string else { return nil }
        
        return DisplayLocation(full: full, city: city, state: st, zip: zip, lat: lat, lon: lon, elevation: elev)
    }
    
    func observationLocationFrom(data: NSData?) -> ObservationLocation? {
        guard let data = data else { return nil }
        let json = JSON(data: data)
        
        guard let full = json["current_observation"]["observation_location"]["full"].string else { return nil }
        guard let city = json["current_observation"]["observation_location"]["city"].string else { return nil }
        guard let st = json["current_observation"]["observation_location"]["state"].string else { return nil }
        guard let lat = json["current_observation"]["observation_location"]["latitude"].string else { return nil }
        guard let lon = json["current_observation"]["observation_location"]["longitude"].string else { return nil }
        guard let el = json["current_observation"]["observation_location"]["elevation"].string else { return nil }
        
        return ObservationLocation(full: full, city: city, state: st, lat: lat, lon: lon, elevation: el)
    }
    
    func timeFrom(data: NSData?) -> Time? {
        guard let data = data else { return nil }
        let json = JSON(data: data)
        
        guard let obs = json["current_observation"]["observation_time"].string else { return nil }
        guard let tzshort = json["current_observation"]["local_tz_short"].string else { return nil }
        guard let tzlong = json["current_observation"]["local_tz_long"].string else { return nil }

        return Time(observationTime: obs, timezoneShort: tzshort, timezoneLong: tzlong)
    }
    
    func currentFrom(data: NSData?) -> Current? {
        guard let data = data else { return nil }
        let json = JSON(data: data)
        
        guard let st = json["current_observation"]["station_id"].string else { return nil }
        guard let we = json["current_observation"]["weather"].string else { return nil }
        guard let hu = json["current_observation"]["relative_humidity"].string else { return nil }
        
        let keyP = units == 0 ? "pressure_in" : "pressure_mb"
        guard let pr = json["current_observation"][keyP].string else { return nil }
        
        guard let pt = json["current_observation"]["pressure_trend"].string else { return nil }

        let keyV = units == 0 ? "visibility_mi" : "visibility_km"
        guard let vi = json["current_observation"][keyV].string else { return nil }

        guard let uv = json["current_observation"]["UV"].string else { return nil }
        guard let ic = json["current_observation"]["icon"].string else { return nil }

        return Current(stationId: st, weather: we, humidity: hu, pressure: pr, presstrend: pt, visibility: vi, uv: uv, icon: ic)
    }
    
    func windFrom(data: NSData?) -> Wind? {
        guard let data = data else { return nil }
        let json = JSON(data: data)
        
        guard let di = json["current_observation"]["wind_dir"].string else { return nil }
        guard let dg = json["current_observation"]["wind_degrees"].float else { return nil }

        let keyS = units == 0 ? "wind_mph" : "wind_kph"
        guard let sp = json["current_observation"][keyS].float else { return nil }
        
        let keyG = units == 0 ? "wind_gust_mph" : "wind_gust_kph"
        guard let gu = json["current_observation"][keyG].float else { return nil }
        
        let keyC = units == 0 ? "windchill_f" : "windchill_c"
        guard let ch = json["current_observation"][keyC].string else { return nil }
        
        return Wind(direction: di, degrees: dg, speed: sp, gustSpeed: gu, chill: ch)
    }
    
    func tempFrom(data: NSData?) -> Temperature? {
        guard let data = data else { return nil }
        let json = JSON(data: data)
        
        let keyT = units == 0 ? "temp_f" : "temp_c"
        guard let te = json["current_observation"][keyT].float else { return nil }
        
        let keyD = units == 0 ? "dewpoint_f" : "dewpoint_c"
        guard let de = json["current_observation"][keyD].float else { return nil }
        
        let keyH = units == 0 ? "heat_index_f" : "heat_index_c"
        let he = json["current_observation"][keyH].float

        let keyF = units == 0 ? "feelslike_f" : "feelslike_c"
        guard let fe = json["current_observation"][keyF].string else { return nil }

        return Temperature(temp: te, dewpoint: de, heatindex: he, feelslike: fe)
    }
    
}

/*
 
 Example
 
*/

let jsonFile = NSBundle.mainBundle().pathForResource("current", ofType: "json")
let jsonData = NSData(contentsOfFile: jsonFile!)

let parser = CurrentParser()

let display = parser.displayLocationFrom(jsonData)

display?.full
display?.city
display?.state
display?.zip
display?.lat
display?.lon
display?.elevation

let observation = parser.observationLocationFrom(jsonData)

observation?.full
observation?.city
observation?.state
observation?.lat
observation?.lon
observation?.elevation

let time = parser.timeFrom(jsonData)

time?.observationTime
time?.timezoneShort
time?.timezoneLong

let current = parser.currentFrom(jsonData)

current?.stationId
current?.weather
current?.humidity
current?.pressure
current?.presstrend
current?.visibility
current?.uv
current?.icon

let wind = parser.windFrom(jsonData)

wind?.direction
wind?.degrees
wind?.speed
wind?.gustSpeed
wind?.chill

let temperature = parser.tempFrom(jsonData)

temperature?.temp
temperature?.dewpoint
temperature?.heatindex
temperature?.feelslike

