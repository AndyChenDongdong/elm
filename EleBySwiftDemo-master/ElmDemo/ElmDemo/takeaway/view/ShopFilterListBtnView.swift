//
//  ShopFilterLIst.swift
//  ElmDemo
//
//  Created by zhenglanchun on 16/6/5.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit
protocol ShopFilterListBtnViewDelegate {
    func clickedFilterListBtn(_ selectedBtnInfo: [NSInteger])
}

class ShopFilterListBtnView: UIView {

    var view: UIView!
    var tmpBtn: UIButton?
    var tmpSubmitBtn: UIButton?
    
    var delegate: ShopFilterListBtnViewDelegate?
    
    var didSelectedBtnInfo: [NSInteger] = []
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var submitBtnLabel: UILabel!
    
    @IBOutlet weak var cleanBtn: UIButton!
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.tag >= 200 && sender.tag < 300{
            if tmpBtn != nil {
                if tmpBtn != sender {
                    sender.isSelected = true
                    tmpBtn?.isSelected = false
                    
                    let index = sender.findObjectIndexOfArray(tmpBtn!.tag, array: didSelectedBtnInfo)
                    if didSelectedBtnInfo.count != 0 {
                        didSelectedBtnInfo.remove(at: index!)
                    }
                    
                }
            }
            tmpBtn = sender
        }
        
        if sender.isSelected == true  {
            didSelectedBtnInfo.append(sender.tag)
        } else {
            let index = sender.findObjectIndexOfArray(sender.tag, array: didSelectedBtnInfo)
            didSelectedBtnInfo.remove(at: index!)
        }
        
        if  didSelectedBtnInfo.count == 0 {
            submitBtnLabel.text = "确定"
        } else {
            submitBtnLabel.text = "确定（\(didSelectedBtnInfo.count)）"

        }
        
        if cleanBtn.isSelected == true {
            cleanBtn.isSelected = false
        }
    }
    
    @IBAction func clean(_ sender: UIButton) {
        sender.isSelected = true
        
        if sender.tag == 400 {
            
            
            if tmpSubmitBtn != nil {
                tmpSubmitBtn?.isSelected = false
            }
            //清空
            for item in buttons {
                
                item.isSelected = false
            }
            
            didSelectedBtnInfo.removeAll()
            submitBtnLabel.text = "确定"
        } else {
            self.delegate?.clickedFilterListBtn(didSelectedBtnInfo)
        }
        
        tmpSubmitBtn = sender
        
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
        for tmpBtn in buttons {
            tmpBtn.layer.borderWidth = 1
            tmpBtn.layer.cornerRadius = 5
            tmpBtn.setBorderColor(defaultColor: FILTERLISTBUTTONBORDER_COLOR, selectedColor: FILTERLISTSELECTED_COLOR)
            if tmpBtn.tag == 401 {
                tmpBtn.backgroundColor = UIColor(red: 0/255.0, green: 220.0/255.0, blue: 119.0/255.0, alpha: 1)
            }
        }
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ShopFilterListBtnView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
