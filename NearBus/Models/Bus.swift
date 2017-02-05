//
//  Bus.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 05/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import Foundation
import CoreLocation

struct Bus {
    var id: Int?
    var busStopId: String?
    var name: String?
    var location: CLLocationCoordinate2D?
    
    init(bus: [String: AnyObject]) {
        if let id = bus["id"] as? Int {
            self.id = id
        }
        if let busStopId = bus["busStopId"] as? String {
            self.busStopId = busStopId
        }
        if let name = bus["name"] as? String {
            self.name = name
        }
        if let location = bus["location"] as? [String: AnyObject] {
            if let coordinates = location["coordinates"] as? [Double], coordinates.count == 2 {
                self.location = CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
            }
        }
    }
}
