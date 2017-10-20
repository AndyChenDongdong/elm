//
//  StarsView.swift
//  SwiftTestDemoBySwift
//
//  Created by z on 16/6/3.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class StarsView: UIView {
    let maxStars: CGFloat = 5.0
    
    var grayImgView: UIImageView!
    var orangeImgView: UIImageView!
    
    var maskLayer: CAShapeLayer!
    var path: UIBezierPath!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        clipsToBounds = true
        
        maskLayer = CAShapeLayer()
        path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 0, height: 13))
        maskLayer.path = path.cgPath
        maskLayer.fillColor = UIColor.white.cgColor;
        
        
        grayImgView = UIImageView(frame: CGRect(x: 0, y: (bounds.size.height - 13) / 2.0, width: 73, height: 13))
        orangeImgView = UIImageView(frame: CGRect(x: 0, y: (bounds.size.height - 13) / 2.0, width: 73, height: 13))
        
        grayImgView.contentMode = .scaleToFill
        grayImgView.image = UIImage(named: "gray")
        orangeImgView.contentMode = .scaleToFill
        orangeImgView.image = UIImage(named: "orange")
        
        addSubview(grayImgView)
        addSubview(orangeImgView)
        
        orangeImgView.layer.mask = maskLayer
    }
    
    func setStars(_ stars: CGFloat) {
        if stars > maxStars {
            return
        }
       
        var width = frame.size.width
        width =  stars/maxStars * width
        
        path =  UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: 13))
        maskLayer.path = path.cgPath
        orangeImgView.layer.mask = maskLayer
    
    }
}
