//
//  GlobalExtension.swift
//  ElmDemo
//
//  Created by zhenglanchun on 16/6/2.
//  Copyright © 2016年 LC. All rights reserved.
//

import Foundation

extension UILabel {
    func setLabelBGColorWithTitle(_ title: String) {
        self.clipsToBounds = true
        self.layer.cornerRadius = 3
        self.text = title
        self.textAlignment = .center
        
        if title.hasPrefix("蜂鸟专送") {
            self.textColor = UIColor.white
            self.backgroundColor = develiyBGColor
            
            
        } else {
            if title.hasPrefix("付") {
                self.textColor = SpecialLabBGColor
            }
            if title.hasPrefix("票") {
                self.textColor =  firstLabBGColor
            }
            if title.hasPrefix("保") {
                self.textColor =  giftLabBGColor
            }
            
            self.layer.borderWidth = 1
            self.layer.borderColor = self.textColor.cgColor
        }
    
        self.font = UIFont.systemFont(ofSize: 11)
        self.sizeToFit()
    }
}

extension UIButton {
    func setBorderColor(defaultColor: UIColor, selectedColor: UIColor) {
        if self.isSelected == false {
            self.layer.borderColor = defaultColor.cgColor
        } else {
            self.layer.borderColor = selectedColor.cgColor
        }
    }
    
    
    func findObjectIndexOfArray(_ object: NSInteger, array: [NSInteger]) -> NSInteger? {
        if array.contains(object) {
            for i in 0..<array.count {
                if array[i] == object {
                    return i
                }
            }
            return nil
        } else {
            return nil
        }
    }
}

extension UIView {
    func setSize(_ size: CGSize) {
        var  frame = self.frame
        frame.size = size
        self.frame = frame
    }
}

extension UIViewController {
    func setleftBarButtonItem(_ imgName: String) {
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: imgName), for: UIControlState())
        leftButton.setSize((leftButton.currentImage?.size)!)
        leftButton.addTarget(self, action: #selector(leftButtonClicked), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    //MARK: - navigation left button clicked
    func leftButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - set right navigationbar right item in controller
    func setRightBarButtonItem(_ imgName: String, rightBtnClicked: Selector) {
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: imgName), for: UIControlState())
        rightButton.setSize((rightButton.currentImage?.size)!)
        rightButton.addTarget(self, action: rightBtnClicked, for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    
    //MARK: - set navigation right item in tabbarcontroller
    func setRightBarButtonItemInTabBarController(_ name: String, rightBtnClicked: Selector) {
        let rightButton = UIButton(frame: CGRect(x: 0,y: 0,width: 40,height: 30))
        rightButton.setTitle(name, for: UIControlState())
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightButton.titleLabel?.textColor = UIColor.white
        rightButton.backgroundColor = UIColor.clear
        
        rightButton.addTarget(self, action:rightBtnClicked, for: .touchUpInside)
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
}
