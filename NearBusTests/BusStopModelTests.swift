//
//  BusStopModelTests.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 06/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import XCTest

class BusStopModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBusStopInitializer() {
        let busStop = BusStop(busStop: BusStopMock.getMockBusStopDict())
        XCTAssert(busStop.id! == BusStopMock.getMockBusStopId())
        XCTAssert(busStop.name! == BusStopMock.getMockBusStopName())
        XCTAssert(busStop.location!.latitude == BusStopMock.getMockBusStopLocation().latitude)
        XCTAssert(busStop.location!.longitude == BusStopMock.getMockBusStopLocation().longitude)
    }
    
    
}
