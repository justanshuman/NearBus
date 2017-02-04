//
//  APIController.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 04/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import UIKit

public typealias CompletionBlock = (_ response: Dictionary<String, AnyObject>?) -> Void


/* This class acts as the network layer for the app. Only GET calls handled here for simplicity. This class can be used to handle Sessions/cookies/access tokens etc. 
    More functions can be added to Upload data, download images etc.
 */

class APIController {
    
    /* This function is used to make any GET call throughout the app. It can be modified to make POST/PUT etc.
 */
    static func makeGetRequest(path: String, header: Dictionary<String, String>? = nil, parameters: Dictionary<String, String>?, body: AnyObject?, success: CompletionBlock?, failure: CompletionBlock?) {
        
//        if let reachability = try? Reachability.reachabilityForInternetConnection() {
//            if reachability.isReachable() {
//                isNetworkReachable = true
//            } else {
//                if isNetworkReachable {
//                    isNetworkReachable = false
//                    showNetworkUnreachable("GET", path: path, parameters: parameters, body: body, success: success, failure: failure)
//                }
//                return nil
//            }
//        }
        
        let targetURL: String = APIEndpoints.BASE_URL + path
        var queryString = targetURL.range(of: "?") != nil ? "&" : "?"
        if let params = parameters {
            for (key, value) in params {
                queryString += key + "=" + value + "&"
            }
        }
        
        if let encodedString = queryString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            queryString = encodedString
        }
        
        if let url = URL(string: targetURL.appending(queryString)) {
            var request = URLRequest(url: url)
            let session = URLSession.shared
            request.httpMethod = "GET"
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            if let header = header {
                for (key, value) in header {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            if request.value(forHTTPHeaderField: "Accept") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Accept")
            }
            
            if let b = body {
                request.httpBody = try? JSONSerialization.data(withJSONObject: b, options: [])
            }
            request.timeoutInterval = 60
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
                
                DispatchQueue.main.async(execute: { () -> Void in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
                
                if error != nil {
                    DispatchQueue.main.async(execute: { () -> Void in
                        failure?(["error": ErrorConstants.genericErrorMessage as AnyObject])
                    })
                } else if let d = data {
                    do {
                        let jsonObject: Any = try JSONSerialization.jsonObject(with: d, options: .mutableContainers)
                        
                        if let jsonArray = jsonObject as? Array<AnyObject> {
                            let dictionary = ["JSON": jsonArray]
                            DispatchQueue.main.async(execute: { () -> Void in
                                success?(dictionary as [String: AnyObject])
                            })
                        } else if let jsonDictionary = jsonObject as? Dictionary<String, AnyObject> {
                            DispatchQueue.main.async(execute: { () -> Void in
                                success?(jsonDictionary)
                            })
                        }
                    } catch _ as NSError {
                        DispatchQueue.main.async(execute: { () -> Void in
                            failure?(["error": ErrorConstants.genericErrorMessage as AnyObject])
                        })
                        
                    } catch {
                        DispatchQueue.main.async(execute: { () -> Void in
                            failure?(["error": ErrorConstants.genericErrorMessage as AnyObject])
                        })
                        
                    }
                }
            })
            DispatchQueue.main.async(execute: { () -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            task.resume()
        }
    }
}
