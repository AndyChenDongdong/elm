//
//  SecondShopItemController.swift
//  ElmDemo
//
//  Created by zhenglanchun on 16/6/19.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class SecondShopItemController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
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

    
    var cellHighDic = [String: CGFloat]()
    
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
        
        tableView.register(UINib(nibName: "EvaluationHeadCell", bundle: nil), forCellReuseIdentifier: "EvaluationHeadCell")
        //EvaluationContentCell
        tableView.register(UINib(nibName: "EvaluationContentCell", bundle: nil), forCellReuseIdentifier: "EvaluationContentCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluationHeadCell") as? EvaluationHeadCell
            cell?.selectionStyle = .none
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluationContentCell") as? EvaluationContentCell
            cell!.memo.text = "\(indexPath.row)"
            cell?.selectionStyle = .none
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            cellHighDic["section\(indexPath.row)"] = 100
            return 100
        } else {
            cellHighDic["\(indexPath.row)"] = 90
            return 90;
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 0 {
            cellHighDic["footer\(section)"] = 20
            return 20
        } else {
            return 0
        }
        
    }
    

    
    
}

