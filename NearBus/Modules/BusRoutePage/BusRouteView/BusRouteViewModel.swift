//
//  BusRouteViewModel.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 05/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import Foundation
import CoreLocation

protocol IBusRouteViewModel {
    func hookUpView()
}

/* Actual implementation of BusRouteViewModel. This class will have all Logic and state required for BusRouteView. This will help in keeping the view (i.e. ViewController) a dumb class.
 */
class BusRouteViewModel: IBusRouteViewModel {
    
    /* View is a weak object for BusStopView.
     */
    weak var view: IBusRouteViewController?
    var bus : Bus
    let location: CLLocationCoordinate2D
    
    /* Initializer for BusRouteViewModel, takes in View and a Bus whose route is to be shown.
    */
    init(view: IBusRouteViewController, bus: Bus, location: CLLocationCoordinate2D) {
        self.view = view
        self.bus = bus
        self.location = location
    }
    
    /* Callback to viewmodel when view is loaded. View is setup here.
    */
    func hookUpView() {
        //view?.setTitle(title: bus.name ?? "")
        view?.setTitle(title: "Bus Route")
        getBusRoute()
        view?.setupMapCameraCenterTo(location: location)
    }
    
    /* Get route for selected bus from local storage if they exist, else make API call to fetch them.
     */
    func getBusRoute() {
        guard let busId = bus.id else {
            return
        }
        if let points = getRouteForBusFromMemory(busId: busId) {
            showBusRoute(points: points)
        } else {
            fetchBusRouteForBusWith(id: busId)
        }
    }
    
    /* Save CLLocationCoordinate2D points for the busId in UserDefaults, so that they can be reused later.
     */
    func saveRouteForBusInMemory(busId: Int, points: [CLLocationCoordinate2D]) {
        var routes = [[Double]]()
        for point in points {
            let item = [point.longitude, point.latitude]
            routes.append(item)
        }
        UserDefaults.standard.set(routes, forKey: "BusId-\(busId)")
    }
    
    /* Get the CLLocationCoordinate2D points for the busId if it exits in UserDefaults else, return nil.
     */
    func getRouteForBusFromMemory(busId: Int) -> [CLLocationCoordinate2D]? {
        guard let routes = UserDefaults.standard.object(forKey: "BusId-\(busId)") as? [[Double]] else {
            return nil
        }
        var points = [CLLocationCoordinate2D]()
        for item in routes {
            if item.count == 2 {
                let point2D = CLLocationCoordinate2D(latitude: item[1], longitude: item[0])
                points.append(point2D)
            }
        }
        return points
    }
    
    /* Make API call to fetch bus Route
    */
    func fetchBusRouteForBusWith(id: Int) {
        view?.toggleLoadingView(show: true)
        let url = String(format: APIEndpoints.GET_BUS_ROUTE, id)
        APIController.makeGetRequest(path: url, parameters: [:], body: nil, success: {
            [weak self](response) in
            if let route = response {
                let busRoute = Route(route: route)
                self?.saveRouteForBusInMemory(busId: id, points: busRoute.points)
                self?.showBusRoute(points: busRoute.points)
            } else {
                self?.view?.showErrorMessage(title: nil, message: ErrorConstants.genericErrorMessage, actionTitle: "Retry", completionBlock: {
                    self?.getBusRoute()
                })
            }
            self?.view?.toggleLoadingView(show: false)
            }, failure: {
                [weak self] error in
                if let errorMessage = error?["error"] as? String {
                    self?.view?.toggleLoadingView(show: false)
                    var errortoShow = errorMessage
                    if errorMessage.compare(ErrorConstants.serverError) == .orderedSame {
                        errortoShow = ErrorConstants.routeNotFoundError
                    }
                    self?.view?.showErrorMessage(title: nil, message: errortoShow, actionTitle: "Go Back", completionBlock: {
                        self?.view?.goBack()
                    })
                }
        })
    }
    
    /* Plot the bus Route on map.
     */
    func showBusRoute(points: [CLLocationCoordinate2D]) {
        view?.plotRouteOnMap(points: points)
        view?.setUpBusInfo(number: bus.busNumber ?? "-", name: bus.name ?? "-", description: bus.description ?? "-", destination: bus.destination ?? "-")
        if points.count > 0 {
            view?.setupMapCameraCenterTo(location: points[0])
            view?.toggleRouteNotFoundView(show: false)
        } else {
            view?.toggleRouteNotFoundView(show: true)
        }
    }
}
