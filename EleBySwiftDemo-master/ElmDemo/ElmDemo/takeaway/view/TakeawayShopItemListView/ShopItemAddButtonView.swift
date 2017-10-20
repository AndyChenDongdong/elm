//
//  ShopItemAddButtonView.swift
//  TmpListDemo
//
//  Created by zhenglanchun on 16/6/21.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class ShopItemAddButtonView: UIView {

    typealias AddButtonClicked = (UIButton, _ add :Bool) -> ()
    typealias SpecificationButtonClicked = (UIButton) -> ()
    
    var addBtnClicked: AddButtonClicked?
    var specificationBtnClicked: SpecificationButtonClicked?
    
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    var isSpecificationButtonShow: Bool {
        get {
            return self.isSpecificationButtonShow
        }
        set(isSpecificationButtonShow) {
            if  isSpecificationButtonShow == true {
                self.containerView.isHidden = false
            } else {
                self.containerView.isHidden = true
            }
            
        }
    }
    
    var view: UIView!
    
    let DISTANCE: CGFloat = 62
    let DURATION: Double = 0.5
    
    var count: NSInteger = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       xibSetup()
    }
    
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        let positionX = addButton.layer.position.x
        if sender.tag == 100 { //minus button click
            count -= 1
            if count == 0 {
                countLabel.isHidden = true
                addCoreAnimation(flag: false, positionX: positionX)
            }
            addBtnClicked?(sender, false)
        } else {
            count += 1
            if minusButton.isHidden == true {
                
                addCoreAnimation(flag: true, positionX: positionX)
                
                let delayTime = DispatchTime.now() + Double(Int64(DURATION/2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    if self.count == 1 {
                        self.countLabel.isHidden = false
                    }
                }
            }
            minusButton.isHidden = false
            addBtnClicked?(sender, true)
        }
        countLabel.text = "\(count)"
        
        
    }
    
    
    @IBAction func specificationButtonClicked(_ sender: UIButton) {
        self.specificationBtnClicked?(sender)
    }
    
    
    //MARK: minusButton's animation delegate
     func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let value = anim.value(forKey: "minus") as? String
        if "minusAnimation" == value {
            
            if count == 0 {
                countLabel.isHidden = true
                minusButton.isHidden = true
            }
        }
        
    }
    
    //MARK: add coreAnimation
    fileprivate func addCoreAnimation(flag add: Bool, positionX: CGFloat) {
        
        var rFromValue: Double!
        var rToValue: Double!
        var dFromValue: CGFloat!
        var dToValue: CGFloat!
        
        var value: String!
        var key: String!
        
        if add == true {
            rFromValue = .pi/2
            rToValue = 0
            dFromValue = positionX
            dToValue = positionX - DISTANCE
            value = "addAnimation"
            key = "add"
            
        } else {
            rFromValue = 0
            rToValue = .pi/2
            dFromValue = positionX - DISTANCE
            dToValue = positionX
            value = "minusAnimation"
            key = "minus"
            
        }
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = rFromValue;
        rotate.toValue = rToValue
        
        let distanceShift = CABasicAnimation(keyPath: "position.x")
        distanceShift.fromValue = dFromValue
        distanceShift.toValue = dToValue
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = DURATION
        groupAnimation.repeatCount = 1
        groupAnimation.animations = [rotate,distanceShift]
        
        groupAnimation.delegate = self as? CAAnimationDelegate
        groupAnimation.setValue(value, forKey: key)
        
        minusButton.layer.add(groupAnimation, forKey: nil)
        //update model layer
        minusButton.layer.position.x = dToValue
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
