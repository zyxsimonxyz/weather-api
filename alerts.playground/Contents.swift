/*

Alerts playground for parsing weather alerts from the Weather Underground API.

See the alerts.json file located in the Resources folder of this Playground
for a local copy of the json data.

Weather Underground API documentation:
https://www.wunderground.com/weather/api/d/docs

*/

import UIKit

// Model
// -----------------------------------------------------------------------------

struct Alert {
    let type: String
    let date: String
    let description: String
    let expires: String
    let message: String
}

// Parser
// ----------------------------------------------------------------------

class AlertsParser {
    
    /**
     Parse alerts returned as json data from Weather Underground API.
     - Parameter json: Dictionary representing json data.
     - Returns: Array of alert structs.
     */
    
    func alertsFrom(json: [String: Any]?) -> [Alert]? {
        
        var alerts = [Alert]()

        guard let alertsArray = json?["alerts"] as? [[String: AnyObject]] else { return nil }
        
        for alert in alertsArray {
            if let type = alert["type"] as? String,
            let date = alert["date"] as? String,
            let des = alert["description"] as? String,
            let exp = alert["expires"] as? String,
            let mes = alert["message"] as? String {
                let alt = Alert(type: type, date: date, description: des, expires: exp, message: mes)
                alerts.append(alt)
            }
        }
        
        return alerts.count > 0 ? alerts : nil
    }
    
}

// Example
// ----------------------------------------------------------------------

let file = Bundle.main.url(forResource: "alerts", withExtension: "json")
let data = try Data(contentsOf: file!)

let json: [String: Any]?

do {
    json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
} catch {
    json = nil
    print("Error is \(error.localizedDescription)")
}

let parser = AlertsParser()
let alerts = parser.alertsFrom(json: json!)

alerts?.count
alerts?[0].type
alerts?[0].date
alerts?[0].description
alerts?[0].expires
alerts?[0].message
