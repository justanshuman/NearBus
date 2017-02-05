//
//  BusRouteViewModel.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 05/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import Foundation
import CoreLocation

protocol IBusStopViewModel {
    func hookUpView()
    func getNumberOfBuses() -> Int
    func getBusFor(index: Int) -> Bus
    func selectedBusAt(index: Int)
}

/*Actual implementation of BusStopViewModel. This class will have all Logic and state required for BusStopView. This will help in keeping the view (i.e. ViewController) a dumb class.
 */
class BusStopViewModel: IBusStopViewModel {
    
    /* View is a weak object for BusStopView.
     */
    weak var view: IBusStopViewController?
    
    var busStop: BusStop
    var bussesList = [Bus]()
    let location: CLLocationCoordinate2D
    /* HomeViewModel should always have an associated View, hence only 1 init.
     */
    init(view: IBusStopViewController, busStop: BusStop, location: CLLocationCoordinate2D) {
        self.view = view
        self.busStop = busStop
        self.location = location
    }
    
    /* Called when view is loaded. Do the setup of view here
     */
    func hookUpView() {
        view?.setTitle(title: "Busses")
        getAllBusses()
    }
    
    /* Get busses for current bus stop
     */
    func getAllBusses() {
        guard let id = busStop.id else {
            return
        }
        fetchBusListForBusStopsWith(id: id)
    }
    
    /* Make API call to fetch busses for current bus stop
     */
    func fetchBusListForBusStopsWith(id: Int) {
        view?.toggleLoadingView(show: true)
        let url = String(format: APIEndpoints.GET_BUSSES_AT_STOP, id)
        APIController.makeGetRequest(path: url, parameters: [:], body: nil, success: {
            [weak self](response) in
            if let bussesList = response?["JSON"] as? [AnyObject] {
                for item in bussesList {
                    if let bus = item as? [String: AnyObject] {
                        let bus = Bus(bus: bus)
                        self?.bussesList.append(bus)
                    }
                }
                if let busses = self?.bussesList {
                    if busses.count > 0 {
                        self?.view?.reloadData()
                        self?.view?.toggleNoBusView(show: false)
                    } else {
                        self?.view?.toggleNoBusView(show: true)
                    }
                }
                self?.view?.toggleLoadingView(show: false)
            } else {
                self?.view?.toggleLoadingView(show: false)
                self?.view?.showErrorMessage(title: nil, message: ErrorConstants.genericErrorMessage, actionTitle: "Retry", completionBlock: {
                    self?.getAllBusses()
                })
            }
            }, failure: {
                [weak self] error in
                if let errorMessage = error?["error"] as? String {
                    self?.view?.toggleLoadingView(show: false)
                    var errortoShow = errorMessage
                    if errorMessage.compare(ErrorConstants.serverError) == .orderedSame {
                        errortoShow = ErrorConstants.busStopDataNotFound
                    }
                    self?.view?.showErrorMessage(title: nil, message: errortoShow, actionTitle: "Retry", completionBlock: {
                        self?.getAllBusses()
                    })
                }
        })
        
    }
    
    /* Returns number of busses to be shown in tableview
     */
    func getNumberOfBuses() -> Int {
        return bussesList.count
    }
    
    /* Returns Bus object to be shown at a particular index in tableview.
     */
    func getBusFor(index: Int) -> Bus {
        return bussesList[index]
    }
    
    /* Callback from view when user selects any row.
     */
    func selectedBusAt(index: Int) {
        view?.showBusRouteViewController(bus: bussesList[index], location: location)
    }
}
