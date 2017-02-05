//
//  BusRouteViewController.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 05/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import UIKit
import GoogleMaps

/* Protocol for BusRouteViewController used by viewModel to control the view. Creating this protocol makes the code more testable.
 */
protocol IBusRouteViewController: class {
    func setTitle(title: String)
    func toggleLoadingView(show: Bool)
    func showErrorMessage(title: String?, message: String?, actionTitle: String?, completionBlock: (() -> Void)?)
    func toggleRouteNotFoundView(show: Bool)
    func goBack()
    func setupMapCameraCenterTo(location: CLLocationCoordinate2D)
    func plotRouteOnMap(points: [CLLocationCoordinate2D])
    func setUpBusInfo(number: String, name: String, description: String, destination: String)
}

/* This class shows the details of the selected bus along with map that has route for the bus marked on it.
 */
class BusRouteViewController: UIViewController, IBusRouteViewController {

    @IBOutlet weak var busNumberLabel: UILabel!
    @IBOutlet weak var busNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var routeNotFoundView: UIView!
    var viewModel: IBusRouteViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Removing text from back button.
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
        viewModel?.hookUpView()
        mapView.isMyLocationEnabled = true
    }
    
    /* Print didReceiveMemoryWarning, print works only in DEBUG mode.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("**didReceiveMemoryWarning in BusRouteViewController**")
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    /* Show or hide full screen loader.
     */
    func toggleLoadingView(show: Bool) {
        if show {
            loadingView.show()
        } else {
            loadingView.hide()
        }
    }
    
    /* Configure and show error message popup.
     */
    func showErrorMessage(title: String?, message: String?, actionTitle: String?, completionBlock: (() -> Void)?) {
        showAlertPopUpWith(title: title, message: message, actionTitle: actionTitle, completionHandler: {
            done in
            completionBlock?()
        })
    }
    
    /* Show or hide Route not found view.
     */
    func toggleRouteNotFoundView(show: Bool) {
        routeNotFoundView.isHidden = !show
    }

    /* Pop route view.
     */
    func goBack() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    /* Change the position of camera of the map. This is handled by ViewModel.
     */
    func setupMapCameraCenterTo(location: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition.camera(withTarget: location, zoom: 13.5)
    }
    
    /* If we pass a list of coordinates, this function plots the route on map.
     */
    func plotRouteOnMap(points: [CLLocationCoordinate2D]) {
        let path = GMSMutablePath()
        for point in points {
            path.add(point)
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.geodesic = true
        polyline.strokeColor = .blue
        polyline.map = mapView
    }
    
    func setUpBusInfo(number: String, name: String, description: String, destination: String) {
        busNumberLabel.text = "Bus Number: \(number)"
        busNameLabel.text = "Bus Name: \(name)"
        descriptionLabel.text = "Description: \(description)"
        destinationLabel.text = "Destination: \(destination)"
    }
}
