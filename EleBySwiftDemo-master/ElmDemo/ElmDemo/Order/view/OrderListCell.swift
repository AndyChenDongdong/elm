//
//  OrderListCell.swift
//  ElmDemo
//
//  Created by z on 16/6/25.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell {
    
    typealias ShopButtonClicked = () -> ()
    typealias OrderButtonClicked = () -> ()

    var shopButtonClicked: ShopButtonClicked?
    var orderButtonClicked: OrderButtonClicked?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func deleteButtonAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func shopButtonAction(_ sender: AnyObject) {
        shopButtonClicked?()
    }
    
    @IBAction func orderButtonAction(_ sender: AnyObject) {
        orderButtonClicked?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
