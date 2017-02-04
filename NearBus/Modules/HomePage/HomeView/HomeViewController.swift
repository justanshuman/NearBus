//
//  HomeViewController.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 04/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import UIKit
import GoogleMaps

/* Protocol for HomeViewController used by viewModel to control the view. Creating this protocol makes the code more testable.
 */
protocol IHomeViewController: class {
    func setUpMapView()
    func setupMapCameraCenterTo(location: CLLocationCoordinate2D)
    func toggleMapsMyLocationButton(show: Bool)
    func toggleLoadingView(show: Bool)
    func showErrorMessage(title: String?, message: String?, actionTitle: String?, completionBlock: (() -> Void)?)
    func markBusStop(location: CLLocationCoordinate2D, name: String)
}


/* This class shows the map with user location and nearby bus stops. This is a dumb view and has no state. It gets all its data from ViewModel.
 */
class HomeViewController: UIViewController, IHomeViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var loadingView: LoadingView!
    
    var viewModel: IHomeViewModel?
    
    private var locationManager = CLLocationManager()
    private var foregroundNotification: NSObjectProtocol?
    var busStopMarkers = [GMSMarker]()
    
    //Declaring UImage as class var and reusing the same for each marker to improve GoogleMaps performance
    private var carMarkerImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "NearBus"
        viewModel?.hookUpView()
        foregroundNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) {
            [weak self] notification in
            self?.viewModel?.checkForAccess()
        }
        carMarkerImage = imageWithImage(image: UIImage(named: "carMarker")!, scaledToSize: CGSize(width: 30, height: 50))
    }
    
    /* Resize the car marker image, used because of huge size of dummy asset used as marker.
     */
    func imageWithImage(image:UIImage, scaledToSize newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /* Setup the view to show google map
     */
    func setUpMapView() {
        locationManager.delegate = self
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        locationManager.requestWhenInUseAuthorization()
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.new, context: nil)
        let camera = GMSCameraPosition.camera(withLatitude: 28.6139, longitude: 77.2090, zoom: 4)
        mapView.camera = camera
    }

    /* Print didReceiveMemoryWarning, print works only in DEBUG mode.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("**didReceiveMemoryWarning in HomeViewController**")
    }
    
    /* Change the position of camera of the map. This is handled by ViewModel
     */
    func setupMapCameraCenterTo(location: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition.camera(withTarget: location, zoom: 15.0)
    }
    
    /* Get the current location of user and stop listening for location changes once map is loaded.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let viewModel = viewModel else {
            return
        }
        
        if let myLocation = change?[NSKeyValueChangeKey.newKey] as? CLLocation {
            viewModel.setLocation(location: myLocation.coordinate)
            removeObserverForLocationChange()
        }
    }
    
    /* Show or Hide mylocation button depending on permission
     */
    func toggleMapsMyLocationButton(show: Bool) {
        mapView.settings.myLocationButton = show
    }
    
    func toggleLoadingView(show: Bool) {
        if show {
            loadingView.show()
        } else {
            loadingView.hide()
        }
    }
    
    /* Stop monitring user location after his initial location is obtained.
     */
    func removeObserverForLocationChange() {
        mapView.removeObserver(self, forKeyPath: "myLocation", context: nil)
    }
    
    func showErrorMessage(title: String?, message: String?, actionTitle: String?, completionBlock: (() -> Void)?) {
        showAlertPopUpWith(title: title, message: message, actionTitle: actionTitle, completionHandler: {
            done in
            completionBlock?()
        })
    }
    
    func markBusStop(location: CLLocationCoordinate2D, name: String) {
        let position = location
        let marker = GMSMarker(position: position)
        busStopMarkers.append(marker)
        marker.title = "\(name)"
        marker.icon = carMarkerImage
        marker.map = mapView
    }
    
    deinit {
        removeObserverForLocationChange()
        if let foregroundNotification = foregroundNotification {
            NotificationCenter.default.removeObserver(foregroundNotification)
        }
    }
}


/* Delegate callbacks for maps view.
 */
extension HomeViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        viewModel?.checkForAccess()
    }
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        if let index = busStopMarkers.index(where: { $0 == marker }) {
//            viewModel?.tappedAt(index: index)
//        }
//    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let index = busStopMarkers.index(where: { $0 == marker }) {
            viewModel?.tappedAt(index: index)
        }
        return false
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        viewModel?.checkForAccess()
    }
}
