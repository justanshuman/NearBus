//
//  BusRouteViewModel.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 05/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import Foundation

protocol IBusRouteViewModel {
    func hookUpView()
}

class BusRouteViewModel: IBusRouteViewModel {
    
    /* View is a weak object for BusStopView.
     */
    weak var view: IBusRouteViewController?
    var bus : Bus
    
    /* Initializer for BusRouteViewModel, takes in View and a Bus whose route is to be shown.
    */
    init(view: IBusRouteViewController, bus: Bus) {
        self.view = view
        self.bus = bus
    }
    
    func hookUpView() {
        view?.setTitle(title: bus.name ?? "")
    }
    
}
