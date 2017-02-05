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
    var busId: String?
    var name: String?
    var busNumber: String?
    var description: String?
    var destination: String?
    
    init(bus: [String: AnyObject]) {
        if let id = bus["id"] as? Int {
            self.id = id
        }
        if let busId = bus["busId"] as? String {
            self.busId = busId
        }
        if let name = bus["name"] as? String {
            self.name = name
        }
        if let busNumber = bus["number"] as? String {
            self.busNumber = busNumber
        }
        if let description = bus["description"] as? String {
            self.description = description
        }
        if let destination = bus["destination"] as? String {
            self.destination = destination
        }
    }
}
