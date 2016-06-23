//
//  HttpAPI.swift
//  AutoCompleteAPI
//
//  Created by Gavin Wiggins on 1/16/16.
//  Copyright © 2016 Gavin Wiggins. All rights reserved.
//

import Foundation

protocol HttpAPIDelegate {
    // Delegate methods for url session errors and success
    func apiError(error: NSError)   // NSError from url session
    func apiHttpError(code: Int)    // http response error
    func apiSuccess(data: NSData)   // data from successful url session
}

class HttpAPI {
    
    var delegate: HttpAPIDelegate? = nil    // create delegate property
    
    func dataFrom(url: NSURL) {
        /* 
        Method to download data from a specified url using asynchronous NSURLSession.
        Data, http response codes, and errors returned from the session should update the 
        user interface on the main thread.
        */
                
        let session = NSURLSession.sharedSession()              // create session for http
        session.configuration.timeoutIntervalForRequest = 15    // seconds until request timeout
        session.configuration.timeoutIntervalForResource = 30   // seconds until resource timeout
        
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if let error = error {
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.apiError(error)  // call delegate method to handle session error
                })
                return
            }
            
            if let httpResponse = (response as? NSHTTPURLResponse)?.statusCode {
                if httpResponse != 200 {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.delegate?.apiHttpError(httpResponse)   // call delegate method to handle http response error

                    })
                    return
                }
            }
            
            if let data = data {
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.apiSuccess(data) // call delegate method to handle data from successful http get request
                })
            }
        }
        
        task.resume()   // begin the http get request
    }
    
}

