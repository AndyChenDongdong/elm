//
//  ShopFilterSortView.swift
//  ElmDemo
//
//  Created by zhenglanchun on 16/6/4.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit
protocol ShopFilterSortViewDelegate {
    func didSelectSortItem(_ currentIndex: Int)
}

class ShopFilterSortView: UIView, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var names = ["智能排序","距离最近","销量最高","起送价最低","配送速度最快","评分最高"]
    var delegate: ShopFilterSortViewDelegate?
    
    //last select cell
    var lastCell: UITableViewCell?
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("不支持XIB创建")
    }
    
    func setupUI() {
        tableView = UITableView(frame: bounds)
        tableView.delegate = self
        tableView.dataSource = self
    
        addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectSortItem(indexPath.row)
        if lastCell != nil {
            lastCell?.accessoryType = .none
        }
    
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    
        
        lastCell = cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "sortCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "sortCell")
        }
        cell?.imageView?.image = UIImage(named: names[indexPath.row])
        cell?.textLabel?.text = names[indexPath.row]
        
        return cell!
    }
        

    
}
