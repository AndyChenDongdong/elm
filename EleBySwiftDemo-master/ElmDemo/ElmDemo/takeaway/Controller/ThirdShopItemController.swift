//
//  ThirdShopItemController.swift
//  ElmDemo
//
//  Created by zhenglanchun on 16/6/19.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class ThirdShopItemController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var cellHighDic = [String: CGFloat]()
    var heigh: CGFloat {
        get {
            var tmpHeigh: CGFloat = 0
            for (_,value) in cellHighDic {
                tmpHeigh += value
            }
            return tmpHeigh
        }
    }
    var contentOffset: CGPoint {
        get {
            return tableView.contentOffset
        }
        set(contentOffset) {
            tableView.contentOffset = contentOffset
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    
    func setupTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.register(UINib(nibName: "ShopSelfDetailCell", bundle: nil), forCellReuseIdentifier: "ShopSelfDetailCell")
        tableView.register(UINib(nibName: "ShopSelfContentCell", bundle: nil), forCellReuseIdentifier: "ShopSelfContentCell")
    }
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopSelfDetailCell") as? ShopSelfDetailCell
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopSelfContentCell") as? ShopSelfContentCell
            if  indexPath.section == 1 {
                cell!.showContainerView = false
            } else {
                cell!.showContainerView = true
            }
            
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            cellHighDic["\(indexPath.row)"] = 126
            return 126
        } else {
            cellHighDic["\(indexPath.row)"] = 184
            return 184
            }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    
}
