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
}

class BusRouteViewController: UIViewController, IBusRouteViewController {

    
    var viewModel: IBusRouteViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Removing text from back button
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
        viewModel?.hookUpView()
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
    

}
