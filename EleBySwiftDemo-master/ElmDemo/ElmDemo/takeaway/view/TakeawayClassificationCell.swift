//
//  TakeawayClassificationCell.swift
//  ElmDemo
//
//  Created by z on 16/5/30.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

protocol TakeawayClassificationCellDelegate {
    func shopCategoryItemSelected(_ currentTag: Int)
}


class TakeawayClassificationCell: UITableViewCell, ClassifiedItemViewDelegate {

    @IBOutlet weak var circleLoopView: LCCircleLoopView!
    
    var delegate: TakeawayClassificationCellDelegate?
    
    @IBOutlet var shopCategoryItems: [ClassifiedItemView]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let delayTime = DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        for item in shopCategoryItems {
            item.delegate = self
        }
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.circleLoopView.setImgNames(imgNamesArray: ["lunbo1", "lunbo2", "lunbo3","lunbo4","lunbo5","lunbo6","lunbo7" ])
        }
    }
    
    //MARK: - ClassifiedItemViewDelegate
    func clickedButton(_ currentTag: Int) {
        
        self.delegate?.shopCategoryItemSelected(currentTag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
