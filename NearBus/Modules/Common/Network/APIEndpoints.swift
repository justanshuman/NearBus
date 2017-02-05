//
//  APIEndpoints.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 04/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import Foundation

/* This class has all API endpoint URLs.
 */
struct APIEndpoints {
    static let BASE_URL                         =     "http://54.255.135.90/"
    
    //HomePage APIs
    static let GET_NEARBY_BUS_STOPS             =     "busservice/api/v1/bus-stops/radius"
    
    //BusStop APIs
    static let GET_BUSSES_AT_STOP               =      "busservice/api/v1/bus-stops/%d/buses"
    
    //BusRoute APIs
    static let GET_BUS_ROUTE                    =      "busservice/api/v1/buses/%d/route"
}
