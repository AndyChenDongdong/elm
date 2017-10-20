//
//  ShopItemDetailController.swift
//  ElmDemo
//
//  Created by z on 16/6/24.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

class ShopItemDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    let DISTANCETOTOP: CGFloat = -24 - 88
    let DEFAULTHIGH: CGFloat = 300 + 88
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imgHighConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shopName: UILabel!
    
    
    
    var navBGView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setleftBarButtonItem("向左箭头")
        navBGView = navigationController?.navigationBar.subviews[0]
        self.automaticallyAdjustsScrollViewInsets = false
        setupTableView()
        
        
        let titleView = UIView(frame: CGRect(x: 0,y: 0,width: 50,height: 44))
        let titleLab = UILabel(frame: CGRect(x: 0,y: 0, width: 30,height: 21))
        titleLab.text = "ceshi"
        titleLab.backgroundColor = UIColor.white
        titleLab.textColor = UIColor.blue
        titleView.addSubview(titleLab)
        
        titleView.backgroundColor = UIColor.orange
       
        tabBarController?.navigationItem.titleView = titleView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBGView?.alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navBGView?.alpha = 0
    }
    
    func setupTableView() {
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(388, 0, 0, 0)
        tableView.contentInset = UIEdgeInsetsMake(388, 0, 0, 0)
    }
    

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if  scrollView == tableView {
            let offsetY = scrollView.contentOffset.y
            print(offsetY)
            let delt = -(DEFAULTHIGH + offsetY)
            print("location: \(offsetY) delt: \(delt) constant: \(imgHighConstraint.constant) ")
            
            if offsetY < -20 - 88 {
                imgHighConstraint.constant = DEFAULTHIGH - 88 + delt
                let alphaDelt = (offsetY + DEFAULTHIGH ) / (DEFAULTHIGH + DISTANCETOTOP)
                if  navBGView != nil {
                    navBGView!.alpha = alphaDelt
                }
                
                if  offsetY >= -64 - 88 && offsetY < -15 - 88 {
                    navigationItem.title = shopName.text
                    
                } else if offsetY < -64 {
                    navigationItem.title = ""
                }
                
            } else {
                navigationItem.title = shopName.text
                imgHighConstraint.constant = 15;
                navBGView?.alpha = 1
            }
        
        }
    }
    //MARK: - tableview delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "infoCell")
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.textLabel?.text =  "商品简介"
            } else {
                cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
                cell.textLabel?.text = "7个切片"
            }
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = "商品评价"
                return cell
            } else {
                var cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as? ShopItemDetailCell
                if cell == nil {
                    let bundle = Bundle(for: type(of: self))
                    let nib = UINib(nibName: "ShopItemDetailCell", bundle: bundle)
                    cell = nib.instantiate(withOwner: nil, options: nil)[0] as? ShopItemDetailCell
                    cell!.selectionStyle = .none
                }
                
                if indexPath.row == 1 {
                    cell?.firstCellFlag = true
                } else {
                    cell?.firstCellFlag = false
                }
                
                return cell!
            }
           
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  indexPath.section == 0 {
            return 44
        } else {
            if indexPath.row == 0 {
                return 44
            }
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
