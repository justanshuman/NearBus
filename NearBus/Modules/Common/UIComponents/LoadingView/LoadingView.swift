//
//  LoadingView.swift
//  NearBus
//
//  Created by Anshuman Srivastava on 04/02/17.
//  Copyright © 2017 wockito. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        if let view = loadViewFromNib() {
            contentView = view
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LoadingView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
    
    func show(){
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        self.isUserInteractionEnabled = true
        self.isHidden = false
    }
    func hide(){
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
        self.isUserInteractionEnabled = false
        self.isHidden = true
    }
}
