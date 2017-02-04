//
//  BusStop.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 04/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import Foundation
import CoreLocation

struct BusStop {
    var id: Int?
    var busStopId: String?
    var name: String?
    var location: CLLocationCoordinate2D?
    
    init(busStop: [String: AnyObject]) {
        if let id = busStop["id"] as? Int {
            self.id = id
        }
        if let busStopId = busStop["busStopId"] as? String {
            self.busStopId = busStopId
        }
        if let name = busStop["name"] as? String {
            self.name = name
        }
        if let location = busStop["location"] as? [String: AnyObject] {
            if let coordinates = location["coordinates"] as? [Double], coordinates.count == 2 {
                self.location = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
            }
        }
    }
}
