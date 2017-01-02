//
//  HttpAPI.swift
//  AutoCompleteAPI
//
//  Created by Gavin Wiggins on 1/16/16.
//  Copyright © 2016 Gavin Wiggins. All rights reserved.
//

import Foundation

protocol HttpAPIDelegate {
    func apiSessionError(_ error: Error)      // url session error
    func apiHttpError(_ code: Int)              // http response error code
    func apiJsonError(_ error: Error)           // json serialization error
    func apiSuccess(_ json: [String: Any])      // url session json dictionary
}

class HttpAPI {
    
    var delegate: HttpAPIDelegate? = nil
    
    func dataFrom(_ urlstring: String) {
        
        let url = URL(string: urlstring)!   // convert url string to NSURL
        
        let session = URLSession.shared                         // create session for http request
        session.configuration.timeoutIntervalForRequest = 15    // seconds until request timeout
        session.configuration.timeoutIntervalForResource = 30   // seconds until resource timeout
        
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            // handle url session error
            
            if let error = error {
                DispatchQueue.main.async(execute: {
                    self.delegate?.apiSessionError(error)
                })
                return
            }
            
            // handle http response error as status code
            
            if let code = (response as? HTTPURLResponse)?.statusCode {
                if code != 200 {
                    DispatchQueue.main.async(execute: {
                        self.delegate?.apiHttpError(code)
                    })
                    return
                }
            }
            
            // handle successful data then convert json to dictionary otherwise handle json conversion error
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async(execute: {
                            self.delegate?.apiSuccess(json)
                        })
                    }
                } catch {
                    DispatchQueue.main.async(execute: {
                        self.delegate?.apiJsonError(error)
                    })
                }
            }
            
        })
        
        task.resume()   // begin asynchronous url session
    }
}
