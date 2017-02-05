//
//  HomeViewModelTests.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 06/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import XCTest
import CoreLocation

@testable import NearBus
class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var viewController: HomeViewController!
    
    override func setUp() {
        super.setUp()
        let storyBoard = UIStoryboard(name: "HomePage", bundle:nil)
        if let homeViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            viewModel = HomeViewModel(view: homeViewController as IHomeViewController)
            homeViewController.viewModel = viewModel
            viewController = homeViewController
            let _ = viewController.view
        }
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSetLocation() {
        let location = CLLocationCoordinate2D(latitude: 22.22, longitude: 22.22)
        viewModel.setLocation(location: location)
        XCTAssert(location.latitude == viewModel.centerLocation?.latitude)
        
    }
}
