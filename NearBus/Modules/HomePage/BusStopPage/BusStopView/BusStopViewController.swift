//
//  BusRouteViewController.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 05/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import UIKit

protocol IBusStopViewController: class {
    func setTitle(title: String)
    func toggleLoadingView(show: Bool)
    func showErrorMessage(title: String?, message: String?, actionTitle: String?, completionBlock: (() -> Void)?)
    func toggleNoBusView(show: Bool)
    func reloadData()
    func showBusRouteViewController(bus: Bus)
}

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
    
    func showErrorMessage(title: String?, message: String?, actionTitle: String?, completionBlock: (() -> Void)?) {
        showAlertPopUpWith(title: title, message: message, actionTitle: actionTitle, completionHandler: {
            done in
            completionBlock?()
        })
    }
    
    func toggleNoBusView(show: Bool) {
        noBusesViiew.isHidden = !show
    }

    func reloadData() {
        tableView.reloadData()
    }
    
    func showBusRouteViewController(bus: Bus) {
        let storyBoard = UIStoryboard(name: "BusRoute", bundle:nil)
        if let busRouteViewController = storyBoard.instantiateViewController(withIdentifier: "BusRouteViewController") as? BusRouteViewController {
            busRouteViewController.viewModel = BusRouteViewModel(view: busRouteViewController, bus: bus)
            self.navigationController?.pushViewController(busRouteViewController, animated: true)
        }
    }
}

extension BusStopViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfBuses() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! BusListTableViewCell
        cell.selectionStyle = .none
        cell.textLabel?.text = viewModel?.getBusFor(index: indexPath.row).name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectedBusAt(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
