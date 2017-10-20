//
//  TakeawayShopLIstCell.swift
//  ElmDemo
//
//  Created by zhenglanchun on 16/5/31.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

protocol TakeawayShopLIstCellDelegate {
    func clickExpandBtn(_ id :TakeawayShopLIstCell)
}

class TakeawayShopLIstCell: UITableViewCell {

    //MARK: - IB
    @IBOutlet weak var shopImg: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    
    @IBOutlet weak var shippingCosts: UILabel!
    
    @IBOutlet weak var shippingCostsTipsLab: UILabel!
    
    @IBOutlet weak var shippingSetupPriceLab: UILabel!
    
    @IBOutlet weak var timerAndDistanceLab: UILabel!
    
    @IBOutlet weak var shippingDoingsLab: UILabel!
    
    @IBOutlet weak var topSeperatorViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var expandViewHighConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var expandingContainerView: UIView!
    
    @IBOutlet weak var expandDetailsView: UIView!
    
    @IBOutlet weak var ratingView: StarsView!
    
    
    //付、票、保、蜂鸟专送 View
    @IBOutlet weak var attributesView: UIView!
    //初始值108
    @IBOutlet weak var attributesWidthConstraint: NSLayoutConstraint!
    //距离顶端的距离，当cell是第一个时，设定为0，否则为9
    @IBOutlet weak var separtorLineViewToTopConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var btnSelectStateImgView: UIImageView!
    
    var delegate: TakeawayShopLIstCellDelegate?
    
    var withDetails: Bool?
    
    //MARK: -
    var firstCell: Bool? {
        didSet {
            print("\(firstCell)")
            if firstCell == true {
                topSeperatorViewLeadingConstraint.constant = 0
                separtorLineViewToTopConstaint.constant = 0
            } else {
                topSeperatorViewLeadingConstraint.constant = 15
                separtorLineViewToTopConstaint.constant = 9
            }
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shopImg.layer.cornerRadius = 10
        btnSelectStateImgView.image = UIImage(named: "down")
    }
    
    //MARK: - 设定Cell
    func setModel(_ shopList: TakeawayHomeShoplist) {
        shopImg.image = UIImage(named: shopList.shopInfo.shopImg)
        shopName.text = shopList.shopInfo.shopName
        shippingCosts.text = "￥\(shopList.shopInfo.shippingCosts)"
        
        if shopList.shopInfo.shippingCosts == -1  {
            shippingCosts.isHidden = true
            shippingCostsTipsLab.text = "Free Delivery"
        } else {
            shippingCosts.isHidden = false
            shippingCostsTipsLab.text = "Delivery Cost"
        }
        
        ratingView.setStars(shopList.shopInfo.shopRatings)
        
        shippingSetupPriceLab.text = shopList.shopInfo.shippingGetPrice
        
        timerAndDistanceLab.text = shopList.shopInfo.deliveryTime + "mins/" + shopList.shopInfo.deliveryDistance + "meter"
        
        if shopList.shopInfo.selfAttributes.count != 0 {
            if attributesView.subviews.count > 0 {
                for attributesViewSubView in attributesView.subviews {
                    attributesViewSubView.removeFromSuperview()
                }

            }
            
            var lastLabelLocation: CGFloat = 0
            for i in 0..<shopList.shopInfo.selfAttributes.count {
                let attributesLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 1,height: 1))
                attributesLabel.setLabelBGColorWithTitle(shopList.shopInfo.selfAttributes[i].attributes)
                attributesLabel.frame = CGRect( x: 3 + lastLabelLocation, y: 3, width: attributesLabel.frame.width + 2, height: 20-6)
                attributesView.addSubview(attributesLabel)
                
                lastLabelLocation = attributesLabel.frame.origin.x + attributesLabel.frame.size.width + 3 + 2
                
            }
            attributesWidthConstraint.constant = lastLabelLocation
            
        }
        
        if withDetails == true {
            updateUI(true)
        } else {
            updateUI(false)
        }
    }
    //MARK: 设定cell扩展属性
    func setExpandingModel(_ expandingAttributes: [TakeawayHomeExtendedattributes]) {
        if expandingAttributes.count == 0 {
            return
        }
        
        if expandDetailsView.subviews.count > 0 {
            for expandSubView in expandDetailsView.subviews {
                expandSubView.removeFromSuperview()
            }
        }
        
        for  i in 0..<expandingAttributes.count  {
            let item = expandingAttributes[i] 
            let view = SpecialFontView(frame: CGRect(x: 0, y: CGFloat(i * 21), width: expandingContainerView.frame.size.width, height: 21))
            view.setViewDetails(specialLabText: item.extendedLabel, detailLabText: item.extendedDetails)
            expandDetailsView.addSubview(view)
        }
        
        shippingDoingsLab.text = "\(expandingAttributes.count)个活动"
        
        //每个扩展块高21
        let expandingHigh = expandingAttributes.count * 21
        if expandingHigh > 42 {
            expandViewHighConstraint.constant = CGFloat(expandingHigh)
        }
        layoutIfNeeded()
    
    }
    
    
    @IBAction func tapExpandBtn(_ sender: UIButton) {
        self.delegate?.clickExpandBtn(self)

    }
 
    func updateUI(_ selected: Bool) {
        if selected == true {
            btnSelectStateImgView.image = UIImage(named: "up")
        } else {
            btnSelectStateImgView.image = UIImage(named: "down")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
