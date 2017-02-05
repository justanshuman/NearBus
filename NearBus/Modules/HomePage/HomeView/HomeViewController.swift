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
    func markBusStop(marker: GMSMarker)
    func toggleNoBusStopsView(show: Bool)
    func removeAllMarkers()
    func showBusStopViewController(busStop: BusStop, location: CLLocationCoordinate2D)
    func removeObserverForLocationChange()
}


/* This class shows the map with user location and nearby bus stops. This is a dumb view and has no state. It gets all its data from ViewModel.
 */
class HomeViewController: UIViewController, IHomeViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var noBusStopsView: UIView!
    @IBOutlet weak var dummyLocationButton: UIButton!
    
    var viewModel: IHomeViewModel?
    
    private var locationManager = CLLocationManager()
    private var foregroundNotification: NSObjectProtocol?
    
    //Declaring UImage as class var and reusing the same for each marker to improve GoogleMaps performance
    private var carMarkerImage: UIImage?
    private var dummyLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 24.44072, longitude: 54.44392)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "NearBus"
        viewModel?.hookUpView()
        addSelectRadiusButton()
        foregroundNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) {
            [weak self] notification in
            self?.viewModel?.checkForAccess()
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
        carMarkerImage = imageWithImage(image: UIImage(named: "carMarker")!, scaledToSize: CGSize(width: 40, height: 60))
        dummyLocationButton.layer.cornerRadius = 5.0
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
        let camera = GMSCameraPosition.camera(withLatitude: 24.4539, longitude: 54.3773, zoom: 4)
        mapView.camera = camera
    }

    /* Adds a Radius button on right side of Navigation bar, this button can be used to change Radius in which the bus stops will be searched.
     */
    func addSelectRadiusButton() {
        let rightBarButtonItem = UIBarButtonItem(title: "Radius", style: .plain, target: self, action: #selector(radiusButtonPressed))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    /* Handler for the radius button on navigation bar
     */
    func radiusButtonPressed(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Select Radius", message: "Bus stops will be searched in this radius around your location.", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "100", style: .default) { action in
            self.viewModel?.setRadius(value: 100)
        })
        alertController.addAction(UIAlertAction(title: "500", style: .default) { action in
            self.viewModel?.setRadius(value: 500)
        })
        alertController.addAction(UIAlertAction(title: "1000", style: .default) { action in
            self.viewModel?.setRadius(value: 1000)
        })
        alertController.addAction(UIAlertAction(title: "1500", style: .default) { action in
            self.viewModel?.setRadius(value: 1500)
        })
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        present(alertController, animated: true, completion: nil)
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
        mapView.camera = GMSCameraPosition.camera(withTarget: location, zoom: 14.0)
    }
    
    /* Get the current location of user. Update the location as and when user changes his location.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let myLocation = change?[NSKeyValueChangeKey.newKey] as? CLLocation {
            viewModel?.setLocation(location: myLocation.coordinate)
        }
    }
    
    /* Show or Hide mylocation button depending on permission
     */
    func toggleMapsMyLocationButton(show: Bool) {
        mapView.settings.myLocationButton = show
    }
    
    /* Show or hide full screen loader
    */
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
    
    /* Configure and show a bus stop.
     */
    func showErrorMessage(title: String?, message: String?, actionTitle: String?, completionBlock: (() -> Void)?) {
        showAlertPopUpWith(title: title, message: message, actionTitle: actionTitle, completionHandler: {
            done in
            completionBlock?()
        })
    }
    
    /* Show or hide no bus stop view.
     */
    func toggleNoBusStopsView(show: Bool) {
        noBusStopsView.isHidden = !show
    }
    
    /* Create a bus stop marker on map.
     */
    func markBusStop(marker: GMSMarker) {
        marker.icon = carMarkerImage
        marker.map = mapView
        marker.snippet = "Tap here for more Info"
    }
    
    /* Remove all bus stop markers when user changes location.
     */
    func removeAllMarkers() {
        mapView.clear()
    }
    
    /* Button click handler for Goto Dummy location Button
     */
    @IBAction func gotoDummyLocation(sender: UIButton) {
        viewModel?.setLocation(location: dummyLocation)
    }
    
    /* Navigate to Bus Stops view
     */
    func showBusStopViewController(busStop: BusStop, location: CLLocationCoordinate2D) {
        let storyBoard = UIStoryboard(name: "BusStop", bundle:nil)
        if let busStopViewController = storyBoard.instantiateViewController(withIdentifier: "BusStopViewController") as? BusStopViewController {
            busStopViewController.viewModel = BusStopViewModel(view: busStopViewController, busStop: busStop, location: location)
            self.navigationController?.pushViewController(busStopViewController, animated: true)
        }
    }
    
    /* Remove KVO when view is deallocated.
     */
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
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        viewModel?.tappedAt(marker: marker)
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        viewModel?.tappedAt(marker: marker)
        return false
    }
}

/* Delegate callbacks for location manager.
 */
extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        viewModel?.checkForAccess()
    }
}
