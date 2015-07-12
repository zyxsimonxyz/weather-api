//: Almanac playground

import UIKit

let jsonFile = NSBundle.mainBundle().pathForResource("almanac", ofType: "json")
let jsonData = NSData(contentsOfFile: jsonFile!)

var err: NSError?
let opts = NSJSONReadingOptions.AllowFragments

let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData!, options: opts, error: &err)

if err == nil {
    "no error"
} else {
    "error"
}


class Almanac {
    
    typealias JSON = [String: AnyObject]
    
    let airportCode: String
    
    let tempHighNormF: String
    let tempHighNormC: String
    let tempHighRecordF: String
    let tempHighRecordC: String
    let recordHighYr: String
    
    let tempLowNormF: String
    let tempLowNormC: String
    let tempLowRecordF: String
    let tempLowRecordC: String
    let recordLowYr: String
    
    init(json: AnyObject) {
        
        if let
        jsonDict = json as? JSON,
        almanacDict = jsonDict["almanac"] as? JSON,
        tempHighDict = almanacDict["temp_high"] as? JSON,
        tempHighNormalDict = tempHighDict["normal"] as? JSON,
        tempHighRecordDict = tempHighDict["record"] as? JSON,
        tempLowDict = almanacDict["temp_low"] as? JSON,
        tempLowNormalDict = tempLowDict["normal"] as? JSON,
        tempLowRecordDict = tempLowDict["record"] as? JSON,
        airportCode = almanacDict["airport_code"] as? String,
        tempHighNormF = tempHighNormalDict["F"] as? String,
        tempHighNormC = tempHighNormalDict["C"] as? String,
        tempHighRecordF = tempHighRecordDict["F"] as? String,
        tempHighRecordC = tempHighRecordDict["C"] as? String,
        recordHighYr = tempHighDict["recordyear"] as? String,
        tempLowNormF = tempLowNormalDict["F"] as? String,
        tempLowNormC = tempLowNormalDict["C"] as? String,
        tempLowRecordF = tempLowRecordDict["F"] as? String,
        tempLowRecordC = tempLowRecordDict["C"] as? String,
        recordLowYr = tempLowDict["recordyear"] as? String
        {
            self.airportCode = airportCode
            self.tempHighNormF = tempHighNormF
            self.tempHighNormC = tempHighNormC
            self.tempHighRecordF = tempHighRecordF
            self.tempHighRecordC = tempHighRecordC
            self.recordHighYr = recordHighYr
            self.tempLowNormF = tempLowNormF
            self.tempLowNormC = tempLowNormC
            self.tempLowRecordF = tempLowRecordF
            self.tempLowRecordC = tempLowRecordC
            self.recordLowYr = recordLowYr
        }
        else
        {
            self.airportCode = "err"
            self.tempHighNormF = "err"
            self.tempHighNormC = "err"
            self.tempHighRecordF = "err"
            self.tempHighRecordC = "err"
            self.recordHighYr = "err"
            self.tempLowNormF = "err"
            self.tempLowNormC = "err"
            self.tempLowRecordF = "err"
            self.tempLowRecordC = "err"
            self.recordLowYr = "err"
        }
    }
}


let almanac = Almanac(json: json!)

almanac.airportCode

almanac.tempHighNormF
almanac.tempHighNormC
almanac.tempHighRecordF
almanac.tempHighRecordC
almanac.recordHighYr

almanac.tempLowNormF
almanac.tempLowNormC
almanac.tempLowRecordF
almanac.tempLowRecordC
almanac.recordLowYr



