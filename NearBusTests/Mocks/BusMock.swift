//
//  BusMock.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 06/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import Foundation

struct BusMock {
    static func getMockBusDict() -> [String: AnyObject] {
        let obj: [String: AnyObject] = [ "id" : 16 as AnyObject,
                    "busId" : "auh:11034:P:R:6r2" as AnyObject,
                    "name" : "City Bus 34" as AnyObject,
                    "description" : "Corniche St / Emirates Palace Hotel" as AnyObject,
                    "number" : "34" as AnyObject
        ]
        return obj
    }
    
    static func getMockBusId() -> Int {
        return 16
    }
    
    static func getMockBusName() -> String {
        return "City Bus 34"
    }
    
    static func getMockBusDescription() -> String {
        return "Corniche St / Emirates Palace Hotel"
    }
    
    static func getMockBusNumber() -> String {
        return "34"
    }
}
