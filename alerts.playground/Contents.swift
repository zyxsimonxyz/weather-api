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

extension Alert {
    
    /// Initialize Alert model from JSON data.
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract values from json data
        guard let type = json["type"] as? String else { return nil }
        guard let date = json["date"] as? String else { return nil }
        guard let desc = json["description"] as? String else { return nil }
        guard let expr = json["expires"] as? String else { return nil }
        guard let mess = json["message"] as? String else { return nil }
        
        // set struct properties
        self.type = type
        self.date = date
        self.description = desc
        self.expires = expr
        self.message = mess
    }
    
    /// An array of Alert structs from JSON data.
    /// - parameter json: JSON data
    
    static func alertArray(json: [String: Any]) -> [Alert]? {
        guard let alertArray = json["alerts"] as? [[String: Any]] else { return nil }
        let alerts = alertArray.flatMap{ Alert(json: $0) }
        return alerts
    }
    
}

// Example
// -----------------------------------------------------------------------------

let file = Bundle.main.url(forResource: "alerts", withExtension: "json")
let data = try Data(contentsOf: file!)

let json: [String: Any]?

do {
    json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
} catch {
    json = nil
    print("Error is \(error.localizedDescription)")
}

let alerts = Alert.alertArray(json: json!)

alerts?.count
alerts?[0].type
alerts?[0].date
alerts?[0].description
alerts?[0].expires
alerts?[0].message

