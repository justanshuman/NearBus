//
//  BusRouteViewController.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 05/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import UIKit
import CoreLocation

/* Protocol for BusStopViewController used by viewModel to control the view. Creating this protocol makes the code more testable.
 */
protocol IBusStopViewController: class {
    func setTitle(title: String)
    func toggleLoadingView(show: Bool)
    func showErrorMessage(title: String?, message: String?, actionTitle: String?, completionBlock: (() -> Void)?)
    func toggleNoBusView(show: Bool)
    func reloadData()
    func showBusRouteViewController(bus: Bus, location: CLLocationCoordinate2D)
}

/* This class shows the list of buses at the selected bus stop.
 */
class BusStopViewController: UIViewController, IBusStopViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var noBusesViiew: UIView!
    
    var viewModel: IBusStopViewModel?
    
    let cellReuseIdentifier = "BusListTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "BusListTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        //Removing text from back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
        tableView.tableFooterView = UIView()
        viewModel?.hookUpView()
    }
    
    /* Set title on navigation bar
     */
    func setTitle(title: String) {
        self.title = title
    }

    /* Print didReceiveMemoryWarning, print works only in DEBUG mode.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("**didReceiveMemoryWarning in BusStopViewController**")
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
    
    /* Configure and show error message popup.
     */
    func showErrorMessage(title: String?, message: String?, actionTitle: String?, completionBlock: (() -> Void)?) {
        showAlertPopUpWith(title: title, message: message, actionTitle: actionTitle, completionHandler: {
            done in
            completionBlock?()
        })
    }
    
    /* Show or hide No bus found view
     */
    func toggleNoBusView(show: Bool) {
        noBusesViiew.isHidden = !show
    }

    /* Refresh tableview data
     */
    func reloadData() {
        tableView.reloadData()
    }
    
    /* Navigate to Bus Route view controller
     */
    func showBusRouteViewController(bus: Bus, location: CLLocationCoordinate2D) {
        let storyBoard = UIStoryboard(name: "BusRoute", bundle:nil)
        if let busRouteViewController = storyBoard.instantiateViewController(withIdentifier: "BusRouteViewController") as? BusRouteViewController {
            busRouteViewController.viewModel = BusRouteViewModel(view: busRouteViewController, bus: bus, location: location)
            self.navigationController?.pushViewController(busRouteViewController, animated: true)
        }
    }
}

//Mark: TableView methods
extension BusStopViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfBuses() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! BusListTableViewCell
        cell.selectionStyle = .none
        cell.setup(number: "\(viewModel?.getBusFor(index: indexPath.row).busNumber ?? "")", name: "\(viewModel?.getBusFor(index: indexPath.row).name ?? "")")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectedBusAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        view.backgroundColor = UIColor(red: 242, green: 242, blue: 242)
        let label: UILabel = UILabel(frame: CGRect(x: 10, y: 13,width: UIScreen.main.bounds.width - 10, height: 18))
        label.textColor = UIColor.darkGray
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "SELECT BUS"
        view.addSubview(label)
        return view
    }
}
