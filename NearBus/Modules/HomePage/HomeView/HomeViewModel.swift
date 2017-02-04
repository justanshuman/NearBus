//
//  HomeViewModel.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 04/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

/* Protocol for HomeViewModel used by view to communicate with viewModel. Creating this protocol makes the code more testable.
 */
protocol IHomeViewModel {
    func hookUpView()
    func setLocation(location: CLLocationCoordinate2D)
    func checkForAccess()
    func tappedAt(index: Int)
    func setRadius(value: Int)
}

/* Actual implementation of HomeViewModel. This class will have all Logic and state required for HomeViewController. This will help in keeping the view (i.e. ViewController) a dumb class.
 */
class HomeViewModel: IHomeViewModel {
    
    /* View is a weak object for HomeView.
     */
    weak var view: IHomeViewController?
    
    /* setting this value will update the camera position on map
     */
    var centerLocation: CLLocationCoordinate2D? {
        didSet {
            if let centerLocation = centerLocation {
                view?.setupMapCameraCenterTo(location: centerLocation)
            }
        }
    }
    
    var radius: Int = 1000
    var nearByBusStops = [BusStop]()
    
    /* HomeViewModel should always have an associated View, hence only 1 init.
     */
    init(view: IHomeViewController) {
        self.view = view
    }
    
    /* Called when view is loaded. Do the setup of view here
     */
    func hookUpView() {
        view?.setUpMapView()
    }
    
    /* See if the app has access to user's current location
     */
    func checkForAccess() {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            view?.toggleMapsMyLocationButton(show: true)
            return
        }
        else if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.notDetermined{
            view?.toggleMapsMyLocationButton(show: false)
            /* Show popUp in case user has disabled Location permission, Pressing on Settings button will take user to App Settings
             */
            view?.showErrorMessage(title: nil, message: "NearBus does not have access to your location. To enable access, tap Settings > Location", actionTitle: "Settings", completionBlock: {
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
            return
        }
        view?.toggleMapsMyLocationButton(show: false)
    }
    
    /* set location of user
     */
    func setLocation(location: CLLocationCoordinate2D) {
        checkForAccess()
        centerLocation = location
        getNearByBusStops()
    }
    
    func getNearByBusStops() {
        guard let centerLocation = centerLocation else {
            return
        }
        
        //Reset the map state before fetching bus stops again
        view?.toggleLoadingView(show: true)
        view?.toggleNoBusStopsView(show: false)
        view?.removeAllMarkers()
        nearByBusStops = []
        
        fetchNearbyBusStops(latitude: centerLocation.latitude, longitude: centerLocation.longitude, radius: radius)
    }
    
    func fetchNearbyBusStops(latitude: Double, longitude: Double, radius: Int) {
        
        let params = ["lat": "\(latitude)",
            "lon" : "\(longitude)",
            "radius" : "\(radius)"]
        
        APIController.makeGetRequest(path: APIEndpoints.GET_NEARBY_BUS_STOPS, parameters: params, body: nil, success: {
            [weak self](response) in
            if let busStopsList = response?["JSON"] as? [AnyObject] {
                for item in busStopsList {
                    if let stop = item as? [String: AnyObject] {
                        let busStop = BusStop(busStop: stop)
                        self?.nearByBusStops.append(busStop)
                    }
                }
                if let stops = self?.nearByBusStops {
                    if stops.count > 0 {
                        self?.markBusStopsOnMap(busStops: stops)
                        self?.view?.toggleNoBusStopsView(show: false)
                    } else {
                        self?.view?.toggleNoBusStopsView(show: true)
                    }
                }
                self?.view?.toggleLoadingView(show: false)
            }
            }, failure: {
                [weak self] error in
                if let errorMessage = error?["error"] as? String {
                    self?.view?.toggleLoadingView(show: false)
                    self?.view?.showErrorMessage(title: nil, message: errorMessage, actionTitle: "Retry", completionBlock: {
                        self?.getNearByBusStops()
                    })
                }
        })
        
    }
    
    func markBusStopsOnMap(busStops: [BusStop]) {
        for stop in busStops {
            if let location = stop.location {
                view?.markBusStop(location: location, name: stop.name ?? "")
            }
        }
    }
    
    func tappedAt(index: Int) {
        view?.showErrorMessage(title: "", message: "\(nearByBusStops[index].name)", actionTitle: nil, completionBlock: nil)
    }
    
    func setRadius(value: Int) {
        radius = value
        getNearByBusStops()
    }
}
