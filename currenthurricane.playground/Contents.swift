//: Playground - noun: a place where people can play

import UIKit

/*
 
 Model
 
 */

struct StormInfo {
    let name: String
    let nameNice: String
    let number: String
}

struct Current {
    let lat: Float
    let lon: Float
    let saffcategory: Float
    let category: String
}

/*

 Parser
 
*/

class HurrParser {
    
    let units = 0   // if units 0 then Fahrenheight, if unit 1 then Celsius
    
    func stormInfo(data: NSData?) -> [StormInfo]? {
        
        guard let jsondata = data else { return nil }
        let json = JSON(data: jsondata)
        
        var storminfo = [StormInfo]()
        
        for (_, item): (String, JSON) in json["currenthurricane"] {
            guard let name = item["stormInfo"]["stormName"].string else { return nil }
            guard let namen = item["stormInfo"]["stormName_Nice"].string else { return nil }
            guard let num = item["stormInfo"]["stormNumber"].string else { return nil }
            let si = StormInfo(name: name, nameNice: namen, number: num)
            storminfo.append(si)
        }
        
        // if storminfo array is empty then return nil
        return storminfo.count > 0 ? storminfo : nil
    }
    
    func currInfo(data: NSData?) -> [Current]? {
        
        guard let jsondata = data else { return nil }
        let json = JSON(data: jsondata)
        
        var curr = [Current]()
        
        for (_, item): (String, JSON) in json["currenthurricane"] {
            guard let lat = item["Current"]["lat"].float else { return nil }
            guard let lon = item["Current"]["lon"].float else { return nil }
            guard let saff = item["Current"]["SaffirSimpsonCategory"].float else { return nil }
            guard let cat = item["Current"]["Category"].string else { return nil }
            let cu = Current(lat: lat, lon: lon, saffcategory: saff, category: cat)
            curr.append(cu)
        }
        
        return curr.count > 0 ? curr : nil
    }
    
}

/*
 
 Example
 
 */

let jsonFile = NSBundle.mainBundle().pathForResource("currenthurricane", ofType: "json")
let jsonData = NSData(contentsOfFile: jsonFile!)

let pars = HurrParser()

let storminf = pars.stormInfo(jsonData)

storminf?[0].name
storminf?[0].nameNice
storminf?[0].number

storminf?[1].name
storminf?[1].nameNice
storminf?[1].number

let curr = pars.currInfo(jsonData)

curr?[0].lat
curr?[0].lon
curr?[0].saffcategory
curr?[0].category

curr?[1].lat
curr?[1].lon
curr?[1].saffcategory
curr?[1].category

