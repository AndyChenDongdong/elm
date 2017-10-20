//
//  SpecificationSelectedView.swift
//  ElmDemo
//
//  Created by z on 16/6/23.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class SpecificationSelectedView: UIView {
    typealias SelectedViewCancelButtonClicked = (UIButton) -> ()
    typealias SelectedViewConfirmButtonClicked = (UIButton) -> ()
    var cancelButtonClicked: SelectedViewCancelButtonClicked?
    var confirmButtonClicked: SelectedViewConfirmButtonClicked?
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        cancelButtonClicked?(sender)
    }
    
    @IBAction func resultButtonAction(_ sender: UIButton) {
        confirmButtonClicked?(sender)
    }
    
    
    func  xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "\(type(of: self))", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }


    
}
