//
//  LCDynamicItem.swift
//  ElmDemo
//
//  Created by zhenglanchun on 16/6/19.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class LCDynamicItem: NSObject, UIDynamicItem {
    //MARK: UIDynamicItem protocol
    var center: CGPoint = CGPoint.zero
    var transform: CGAffineTransform = CGAffineTransform.identity
    var bounds: CGRect
    override init() {
        self.bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
    }
}
