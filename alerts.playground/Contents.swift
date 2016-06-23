//: Alerts Playground

import UIKit

/*
 
 Model
 
*/

struct Alert {
    let type: String
    let date: String
    let description: String
    let expires: String
    let message: String
}

/*
 
 Parser

*/

class AlertsParser {
    
    func alertsFrom(data: NSData?) -> [Alert]? {
        
        guard let data = data else { return nil }
        let json = JSON(data: data)
        
        var alerts = [Alert]()
        
        for (_, item):(String, JSON) in json["alerts"] {
            guard let type = item["type"].string else { return nil }
            guard let date = item["date"].string else { return nil }
            guard let descr = item["description"].string else { return nil }
            guard let exp = item["expires"].string else { return nil }
            guard let mess = item["message"].string else { return nil }
            let al = Alert(type: type, date: date, description: descr, expires: exp, message: mess)
            alerts.append(al)
        }
        
        return alerts.count > 0 ? alerts : nil
    }
    
}

/* 
 
 Example
 
*/

let jsonFile = NSBundle.mainBundle().pathForResource("alerts", ofType: "json")
let jsonData = NSData(contentsOfFile: jsonFile!)

let parser = AlertsParser()
let alerts = parser.alertsFrom(jsonData)

alerts?[0].type
alerts?[0].date
alerts?[0].description
alerts?[0].expires
alerts?[0].message




