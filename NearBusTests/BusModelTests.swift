//
//  BusModelTests.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 06/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import XCTest
@testable import NearBus

class BusModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBusInitializer() {
        let bus: Bus = Bus(bus: BusMock.getMockBusDict())
        XCTAssert(bus.id! == BusMock.getMockBusId())
        XCTAssert(bus.description! == BusMock.getMockBusDescription())
        XCTAssert(bus.name! == BusMock.getMockBusName())
    }
}
