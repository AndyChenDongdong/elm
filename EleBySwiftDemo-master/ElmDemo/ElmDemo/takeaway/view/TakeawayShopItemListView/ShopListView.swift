//
//  ShopListView.swift
//  LCShopListDemo
//
//  Created by z on 16/6/21.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit
@objc protocol ShopListViewDelegate {
    func lc_tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    func lc_tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    func lc_tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
}

let SHOPLISTVIEWADDBUTTONNOTIFICATIONNAME = "ShopListViewAddButtonNotificationName"

class ShopListView: UIView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    let TITLESELECTEDCOLOR = UIColor.blue
    let BGCOLOR = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
    
    var tableView: UITableView!
    weak var delegate: ShopListViewDelegate?
    
    func currentHigh() -> CGFloat {
        
        return getCurrentHigh( leftMenuNames.count )
    }
    
    var view: UIView!
    var scrollView: UIScrollView!
    
    var leftMenuButtons: Array<UIButton>!
    var leftMenuNames: Array<String>!
    var groupItems: Array<Int>!
    var allSectionHeightDatas: Array<CGFloat>!
    var sectionHeaderHeight: CGFloat!
//    var rowHeight: CGFloat!
    //MARK: life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        initData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        initData()
    }

    func  setupUI() {
        view = UIView()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
        scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: view.frame.size.width * 0.2, height: view.frame.size.height))
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = scrollView.frame.size
        scrollView.delegate = self
        scrollView.backgroundColor = BGCOLOR
        view.addSubview(scrollView)
    
        tableView = UITableView(frame: CGRect(x: view.frame.size.width * 0.2,y: 0,width: view.frame.size.width * 0.8, height: view.frame.size.height), style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.backgroundColor = UIColor.lightGray
    }
    
    func initData() {
        leftMenuButtons = []
        leftMenuNames = []
        allSectionHeightDatas = []
        groupItems = []
    }
    
    //MARK: public set left menu and tableView
    func setLeftMenu(_ menuData: Array<String>, withGroupItemCount groupItemsArray: Array<Int>) {
        leftMenuNames = menuData
        groupItems = groupItemsArray
        
        weak var weakSelf = self
        let delayTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            //update frame
            weakSelf!.scrollView.frame = CGRect(x: 0,y: 0,width: weakSelf!.view.frame.size.width * 0.2, height: weakSelf!.view.frame.size.height)
            weakSelf!.scrollView.contentSize = weakSelf!.scrollView.frame.size
            weakSelf!.tableView.frame = CGRect(x: weakSelf!.view.frame.size.width * 0.2,y: 0,width: weakSelf!.view.frame.size.width * 0.8, height: weakSelf!.view.frame.size.height)
            
            for i in 0..<menuData.count {
                weakSelf!.scrollView.contentSize = CGSize(width: weakSelf!.scrollView.frame.size.width, height: (CGFloat)(menuData.count * 40));
               let tmpBtn = UIButton(frame: CGRect(x: 0, y: 40 * CGFloat(i), width: weakSelf!.scrollView.frame.size.width, height: 40))
                tmpBtn.setTitle(menuData[i], for: UIControlState())
                tmpBtn.setTitleColor(UIColor.black, for: UIControlState())
                tmpBtn.setTitleColor(weakSelf!.TITLESELECTEDCOLOR, for: .selected)
                
                tmpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
                tmpBtn.titleLabel?.numberOfLines = 2;
                tmpBtn.titleLabel?.textAlignment = .center
                tmpBtn.tag = i + 100
                tmpBtn.addTarget(weakSelf, action: #selector(weakSelf!.btnClicked(_:)), for: .touchUpInside)
                
                if i == 0   {
                    tmpBtn.isSelected = true
                }
                weakSelf!.leftMenuButtons.append(tmpBtn)
                weakSelf!.scrollView.addSubview(tmpBtn)
                
//                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//                let rect1 = weakSelf!.tableView.rectForRowAtIndexPath(indexPath)
//                weakSelf!.rowHeight = rect1.size.height;
            }
            weakSelf!.tableView.reloadData()
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            for i in 0..<weakSelf!.leftMenuButtons.count {
                let frame = weakSelf!.tableView.rect(forSection: i)
                let sectionH = frame.origin.y + frame.size.height;
                weakSelf!.allSectionHeightDatas.append(sectionH)
            }
        }
        
    }
    //MARK: menu button clicked
    func btnClicked(_ sender: UIButton) {
        let index = sender.tag - 100
        print(index)
        let high = getCurrentHigh(index)
        print("high: \(high)")
        tableView.setContentOffset(CGPoint(x: 0, y: high), animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: SHOPLISTVIEWADDBUTTONNOTIFICATIONNAME), object: nil, userInfo: nil)
    }
    
    func getCurrentHigh(_ index: Int) -> CGFloat{
        if index == 0 {
            return 0
        }
        var high:CGFloat = 0
        for i in 0..<index {
            let rect = tableView.rect(forSection: i)
            high += rect.size.height
        }
       
        return high
    }
    
    //MARK: scrollView delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let locationY = scrollView.contentOffset.y
            let index = getSectionIndexFromLocation(locationY)
            
            for i in 0..<leftMenuButtons.count {
                let tmpBtn = leftMenuButtons[i]
                tmpBtn.isSelected = false
                tmpBtn.backgroundColor = BGCOLOR
            }
            
            if leftMenuButtons.count != 0 {
                let tmpBtn = leftMenuButtons[index]
                tmpBtn.isSelected = true
                tmpBtn.backgroundColor = UIColor.white
            }
        }
    }
    
    func getSectionIndexFromLocation(_ locationY: CGFloat) -> Int{
        for h in allSectionHeightDatas {
            if locationY < h {
                return allSectionHeightDatas.index(of: h)!
            }
        }
        return 0
    }
    
    //MARK: tableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if leftMenuButtons.count == 0 {
            return 0
        }
        return leftMenuButtons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groupItems.count == 0 {
            return 0
        }
        return groupItems[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       return (delegate?.lc_tableView(tableView, cellForRowAtIndexPath: indexPath))!
    
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if leftMenuNames.count == 0 {
            return ""
        }
        return leftMenuNames[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.lc_tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (delegate?.lc_tableView(tableView, heightForRowAtIndexPath: indexPath))!
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = SEPARATOR_COLOR
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
}
