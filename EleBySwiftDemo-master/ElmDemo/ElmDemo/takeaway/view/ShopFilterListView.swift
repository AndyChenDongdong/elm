//
//  ShopFilterListView.swift
//  SwiftTestDemoBySwift
//
//  Created by z on 16/6/3.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

let SHOPFILTERCELLBG_COLOR = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1)

protocol ShopFilterListViewDelegate {
    func didSelectedShopItem(_ shopInfo: Categorydetails)
}

class ShopFilterListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var leftTableView: UITableView?
    var rightTableView: UITableView?
    
    var cellColorInfo: [NSInteger] = []
    var lastSelectedCell: ShopFilterListCell?
    
    var data: TakeawayFilterModel = TakeawayFilterModel()
    var detailData: [Int] = []
    
    var delegate: ShopFilterListViewDelegate?
    
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
        
        let tableViewFrame = frame
        leftTableView = UITableView()
        leftTableView?.frame = CGRect(x: 0, y: 0, width: tableViewFrame.size.width/2, height: tableViewFrame.size.height)
        leftTableView?.delegate = self
        leftTableView?.dataSource = self
        leftTableView?.separatorStyle = .none
        addSubview(leftTableView!)
        
        rightTableView = UITableView()
        rightTableView?.frame = CGRect(x: tableViewFrame.size.width/2, y: 0, width: tableViewFrame.size.width/2, height: tableViewFrame.size.height)
        rightTableView?.delegate = self
        rightTableView?.dataSource = self
        rightTableView?.separatorStyle = .none
        addSubview(rightTableView!)
        
    }
    
    //MARK: - public set model data
    func setFilterViewModel(_ modelData: TakeawayFilterModel) {
        data = modelData
        
        for item in modelData.categoryAllInfo {
            
            detailData.append(item.categoryDetails.count)
        }
        
        leftTableView?.reloadData()
        rightTableView?.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == leftTableView {
            let cell = tableView.cellForRow(at: indexPath) as! ShopFilterListCell
            let indexPathRow = cell.tag
            if cellColorInfo.contains(indexPathRow) == false {
                
                if let lastCell = lastSelectedCell {
                    lastCell.setBGColorWithSelectedState(false)
                    if  cellColorInfo.count > 0 {
                        if let index = findObjectIndexOfArray(lastCell.tag) {
                            cellColorInfo.remove(at: index)
                        }
                    }
                }
                cellColorInfo.append(indexPathRow)
                cell.setBGColorWithSelectedState(true)
            }
            lastSelectedCell = cell
            
            rightTableView?.reloadData()
        } else {
            //MARK: - delegate
            if cellColorInfo.count > 0 {
                let index = cellColorInfo[0] - 100
                
                self.delegate?.didSelectedShopItem(data.categoryAllInfo[index].categoryDetails[indexPath.row])
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            if let info = data.categoryAllInfo {
                return info.count
            }
            return 0
        } else {
            if nil  != data.categoryAllInfo {
                var index: NSInteger = 0
                if cellColorInfo.count > 0 {
                    index = cellColorInfo[0] - 100
                    return detailData[index]
                }
                return detailData[0]
            }
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView {
            var cell = tableView.dequeueReusableCell(withIdentifier: "leftTableViewCell") as? ShopFilterListCell
            if cell == nil {
                
                let bundle = Bundle(for: type(of: self))
                let nib = UINib(nibName: "ShopFilterListCell", bundle: bundle)
                cell = nib.instantiate(withOwner: nil, options: nil)[0] as? ShopFilterListCell
                cell!.selectionStyle = .none
            }
            cell!.tag = indexPath.row + 100
            
            cell?.setModel(data.categoryAllInfo[indexPath.row])
            
            return cell!

        } else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "rightTableViewCell")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "rightTableViewCell")
                cell?.selectionStyle = .none
            }
            
            if let info = data.categoryAllInfo {
                var index: NSInteger = 0
                if cellColorInfo.count > 0 {
                    index = cellColorInfo[0] - 100
                }
                cell?.textLabel?.text = info[index].categoryDetails[indexPath.row].shopItemName
                cell?.detailTextLabel?.text = info[index].categoryDetails[indexPath.row].shopItemCount
                cell!.tag = indexPath.row + 1000
            } else {
                cell?.textLabel?.text = ""
                cell?.detailTextLabel?.text = ""
                cell!.tag = indexPath.row + 1000
            }
            
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 11)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 11)
            return cell!
        }
    }
    
    //MARK: - private
    func findObjectIndexOfArray(_ object: NSInteger) -> NSInteger? {
        if cellColorInfo.contains(object) {
            for i in 0..<cellColorInfo.count {
                if cellColorInfo[i] == object {
                    return i
                }
            }
            return nil
        } else {
            return nil
        }
    }
    
    
}
