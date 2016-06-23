//: Almanac playground

import UIKit

/*
 
 Model
 
*/

struct Almanac {
    let airportCode: String
    let normalHigh: String
    let recordHigh: String
    let recordYearHigh: String
    let normalLow: String
    let recordLow: String
    let recordYearLow: String
}

/*
 
 Parser
 
*/

class AlmanacParser {
    
    let units = 0   // if units 0 then Fahrenheight, if unit 1 then Celsius
    
    func almanacFrom(data: NSData?) -> Almanac? {
        
        guard let data = data else { return nil }
        let json = JSON(data: data)
        
        let key = units == 0 ? "F" : "C"
        
        guard let code = json["almanac"]["airport_code"].string else { return nil }
        guard let normhigh = json["almanac"]["temp_high"]["normal"][key].string else { return nil }
        guard let rechigh = json["almanac"]["temp_high"]["record"][key].string else { return nil }
        guard let recyrhigh = json["almanac"]["temp_high"]["recordyear"].string else { return nil }
        guard let normlow = json["almanac"]["temp_low"]["normal"][key].string else { return nil }
        guard let reclow = json["almanac"]["temp_low"]["record"][key].string else { return nil }
        guard let recyrlow = json["almanac"]["temp_low"]["recordyear"].string else { return nil }
        
        return Almanac(airportCode: code, normalHigh: normhigh, recordHigh: rechigh, recordYearHigh: recyrhigh, normalLow: normlow, recordLow: reclow, recordYearLow: recyrlow)
    }
    
}

/*
 
 Example
 
*/


let jsonFile = NSBundle.mainBundle().pathForResource("almanac", ofType: "json")
let jsonData = NSData(contentsOfFile: jsonFile!)

let parser = AlmanacParser()

let almanac = parser.almanacFrom(jsonData)

almanac?.airportCode
almanac?.normalHigh
almanac?.recordHigh
almanac?.recordYearHigh
almanac?.normalLow
almanac?.recordLow
almanac?.recordYearLow
