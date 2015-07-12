//: Alerts Playground

import UIKit

let jsonFile = NSBundle.mainBundle().pathForResource("alerts", ofType: "json")
let jsonData = NSData(contentsOfFile: jsonFile!)

var err: NSError?
let opts = NSJSONReadingOptions.AllowFragments

let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData!, options: opts, error: &err)

if err == nil {
    "no error"
} else {
    "error"
}


class Alerts {
    
    let type: String
    let date: String
    let description: String
    let expires: String
    let message: String
    
    init(json: AnyObject) {
        
        if let
        jsonDict = json as? [String: AnyObject],
        alertsArray = jsonDict["alerts"] as? [AnyObject],
        alertsDict = alertsArray[0] as? [String: AnyObject],
        type = alertsDict["type"] as? String,
        date = alertsDict["date"] as? String,
        description = alertsDict["description"] as? String,
        expires = alertsDict["expires"] as? String,
        message = alertsDict["message"] as? String
        {
            self.type = type
            self.date = date
            self.description = description
            self.expires = expires
            self.message = message
        }
        else
        {
            self.type = "err"
            self.date = "err"
            self.description = "err"
            self.expires = "err"
            self.message = "err"
        }
    }
}


let alerts = Alerts(json: json!)

alerts.type
alerts.date
alerts.description
alerts.expires
alerts.message

