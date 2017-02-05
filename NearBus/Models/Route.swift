//
//  Route.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 05/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import Foundation
import CoreLocation

struct Route {
    var id: Int?
    var busName: String?
    var busDescription: String?
    var busNumber: String?
    var destination: String?
    var points = [CLLocationCoordinate2D]()
    
    init(route: [String: AnyObject]) {
        
        if let id = route["id"] as? Int {
            self.id = id
        }
        if let bus = route["bus"] as? [String: AnyObject] {
            if let name = bus["name"] as? String {
                self.busName = name
            }
            if let description = bus["description"] as? String {
                self.busDescription = description
            }
            if let number = bus["number"] as? String {
                self.busNumber = number
            }
            if let destination = bus["destination"] as? String {
                self.destination = destination
            }
        }
        if let points = route["points"] as? [AnyObject] {
            for point in points {
                if let temp = point as? [Double], temp.count == 2 {
                    let point2D = CLLocationCoordinate2D(latitude: temp[1], longitude: temp[0])
                    self.points.append(point2D)
                }
            }
        }
    }
}
