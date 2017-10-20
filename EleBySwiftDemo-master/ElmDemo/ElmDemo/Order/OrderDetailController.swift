//
//  OrderDetailController.swift
//  ElmDemo
//
//  Created by z on 16/6/25.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class OrderDetailController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单详情"
        setleftBarButtonItem("向左箭头")
        setRightBarButtonItem("电话", rightBtnClicked: #selector(rightButtonAction))
        setupTableView()
        
    }
    
    func setupTableView() {
         tableView?.register(UINib.init(nibName: "OrderDetailHeadCell", bundle: nil), forCellReuseIdentifier: "OrderDetailHeadCell")
        
        tableView?.register(UINib.init(nibName: "OrderDetailAdsCell", bundle: nil), forCellReuseIdentifier: "OrderDetailAdsCell")
        
        tableView?.register(UINib.init(nibName: "OrderDetailShopInfoCell", bundle: nil), forCellReuseIdentifier: "OrderDetailShopInfoCell")
        
        
        tableView?.register(UINib.init(nibName: "OrderDetailDeliveryInfoCell", bundle: nil), forCellReuseIdentifier: "OrderDetailDeliveryInfoCell")
        
        tableView?.register(UINib.init(nibName: "OrderDetailContentCell", bundle: nil), forCellReuseIdentifier: "OrderDetailContentCell")
        
        
    }
    
    func rightButtonAction() {
        print("rightButtonAction")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell?
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailHeadCell") as? OrderDetailHeadCell
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailAdsCell") as? OrderDetailAdsCell
            break
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailShopInfoCell") as? OrderDetailShopInfoCell
            break
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailDeliveryInfoCell") as? OrderDetailDeliveryInfoCell
            break
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailContentCell") as? OrderDetailContentCell
            break
        default:
            cell = nil
            break
        }
        cell?.selectionStyle = .none
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 133
        case 1:
            return 95
        case 2:
            return 250
        case 3:
            return 80
        case 4:
            return 244
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
