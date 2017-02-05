//
//  BusListTableViewCell.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 05/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import UIKit

class BusListTableViewCell: UITableViewCell {

    @IBOutlet weak var busImageView: UIImageView!
    @IBOutlet weak var busNumberLabel: UILabel!
    @IBOutlet weak var busNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(number: String, name: String) {
        busNumberLabel.text = "Bus Number: \(number)"
        busNameLabel.text = "Bus Name: \(name)"
    }
    
}
