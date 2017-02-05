//
//  BusStopMock.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 06/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import Foundation
import CoreLocation

struct BusStopMock {
    
    static func getMockBusStopDict() -> [String: AnyObject] {
        let location: [String: AnyObject] = [ "type" : "Point" as AnyObject,
                                              "coordinates" : [54.44392, 24.4403] as AnyObject
        ]
        let obj: [String: AnyObject] = [ "id" : getMockBusStopId() as AnyObject,
                                         "busStopId" : "1000480-0-A" as AnyObject,
                                         "name" : getMockBusStopName() as AnyObject,
                                         "location": location as AnyObject
        ]
        return obj
    }
    
    static func getMockBusStopLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 24.4403, longitude: 54.44392)
    }
    
    static func getMockBusStopId() -> Int {
        return 16
    }
    
    static func getMockBusStopName() -> String {
        return "Masjid Mansoor Bin Zayed"
    }
}
