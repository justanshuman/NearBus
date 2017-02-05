//
//  BusRouteViewController.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 05/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import UIKit

protocol IBusRouteViewController: class {
    func setTitle(title: String)
    func toggleLoadingView(show: Bool)
    func showErrorMessage(title: String?, message: String?, actionTitle: String?, completionBlock: (() -> Void)?)
    func toggleNoBusView(show: Bool)
    func reloadData()
}

class BusRouteViewController: UIViewController, IBusRouteViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var noBusesViiew: UIView!
    
    var viewModel: IBusRouteViewModel?
    
    let cellReuseIdentifier = "BusListTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "BusListTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
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
        print("**didReceiveMemoryWarning in BusRouteViewController**")
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
}

extension BusRouteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfBuses() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! BusListTableViewCell
        cell.selectionStyle = .none
        cell.textLabel?.text = viewModel?.getBusFor(index: indexPath.row).name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
