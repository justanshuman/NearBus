//
//  Extensions.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 04/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertPopUpWith(title: String?, message: String?, actionTitle: String? = "Ok", completionHandler: ((_ action : UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: completionHandler))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red) / 255
        let newGreen = CGFloat(green) / 255
        let newBlue = CGFloat(blue) / 255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1)
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
