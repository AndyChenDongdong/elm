//
//  ShopFilterController.swift
//  ElmDemo
//
//  Created by zhenglanchun on 16/6/4.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit
import Parse

class ShopFilterController: UIViewController, LCFileterButtonDelegate, ShopFilterListViewDelegate, ShopFilterSortViewDelegate, ShopFilterListBtnViewDelegate, UITableViewDelegate, UITableViewDataSource, TakeawayShopLIstCellDelegate {
    
    
    var shopList : [String:Any] = ["shopInfor":""]
    var shopInfoDictionary : [String:Any] = ["shopName": "", "shopRating": ""]
    
    
    //holding the information for the shopList
    var shopInforDictionaryArray :[Any] = []
    
    
    var shopInfoDictionaryArrayDictionary :[String:Any] = [:]
    
    
    var shopListDictionary = [String:Any]()
    var shopObjects = Array<PFObject>(){
        didSet {
            
            // Do any execution that needs to wait for places array here.
        }
    }
    
    @IBOutlet weak var image: UIImageView!
    
    func loadThePFObjectIntoString(){
        for shopObject in shopObjects {
            
            let shopName = shopObject.value(forKeyPath: "shopName") as? String
            let shopRating = shopObject.value(forKeyPath: "shopRating") as? String
            shopInfoDictionary.updateValue(shopName!,forKey: "shopName")
            shopInfoDictionary.updateValue(shopRating!, forKey: "shopRating")
            shopInforDictionaryArray.append(shopInfoDictionary)
            shopInfoDictionaryArrayDictionary["shopInfo"] = shopInforDictionaryArray
            
            shopListDictionary["shopList"] = shopInfoDictionaryArrayDictionary
            
        }
    }
    
    
    
    
    func transferStringToJSon(){
        if let json = try? JSONSerialization.data(withJSONObject: shopListDictionary, options: [])
        {
            if let content = String(data: json, encoding: String.Encoding.utf8)
            {
                // here `content` is the JSON data decoded as a String
                print(content)
            }
            
            // here `json` is your JSON data
        }
    }
    
    func loadTheDataFromParse(){
        
        
        
        let query:PFQuery = PFQuery(className: "ShopPhoto")
        
        // let latitude = 33.0
        // let longtitude = -122.0
        query.whereKeyExists("imageFile")
        // query.whereKey("bikeLocation", equalTo: PFGeoPoint(latitude: latitude,longitude: longtitude))
        
        
        query.findObjectsInBackground
            {
                (objects: [PFObject]?, error: Error?) -> Void in
                
                if error == nil
                {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let unwrappedObjects = objects {
                        
                        for object in unwrappedObjects {
                            
                            self.shopObjects.append(object)
                            
                            
                            
                            
                        }
                        /*                          //self.shops.append(object)
                         if let unwrappedObjects = objects {
                         
                         for object in unwrappedObjects {
                         
                         if let peopleFromParse = object as? JSON {
                         
                         for name in peopleFromParse.keys {
                         if let personJSON = peopleFromParse[name] as? JSON,
                         
                         let person = Person(json: personJSON) {
                         peopleDictionary[name] = person
                         }
                         }
                         }
                         }
                         }
                         */
                        
                        
                    }
                    else
                    {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.localizedDescription)")
                    }
                    
                    self.loadThePFObjectIntoString()
                    self.transferStringToJSon()
                    
                    
                }
        
    
    
    
    
        }
    }
    
    /////
    
    var filterView: ShopFilterListView?
    var filterSortView: ShopFilterSortView!
    var filterListView: ShopFilterListBtnView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var segmentBtns: [LCFileterButton]!
    
    var model: TakeawayFilterModel!
    var datas: TakeawayHomeModel!
    var tmpLeftBtn: UIButton?
    var selectIndexInfo: [Int] = []
        
    
    
    ////////
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTheDataFromParse()
        loadThePFObjectIntoString()
        transferStringToJSon()
        
        
        
        /*
        let testObject = PFObject(className: "TestObject")
        
        testObject["foo"] = "lol"
        testObject.saveInBackground { (success, error) -> Void in
            print("Object has been saved.")
        }
        
 */
        

        for tmpBtn in segmentBtns {
            tmpBtn.delegate = self
        }
        //navigationItem leftBarButtonItem
        setleftBarButtonItem("向左箭头")
        
        
        
        //左
        filterView = ShopFilterListView(frame: CGRect(x: 0, y: 64+44+1, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 64 - 44 - 1 - 100))
        filterView?.isHidden = true
        filterView!.delegate = self
        view.addSubview(filterView!)
        
        let filePath = Bundle.main.path(forResource: "TakeawayFilter", ofType: "json")
        let contentData = FileManager.default.contents(atPath: filePath!)
        let content = NSString(data: contentData!, encoding: String.Encoding.utf8.rawValue) as String?
        model = TakeawayFilterModel.mj_object(withKeyValues: content)
        filterView?.setFilterViewModel(model)
        
        //中
        filterSortView = ShopFilterSortView(frame: CGRect(x: 0, y: 64+44+1, width: UIScreen.main.bounds.size.width, height: 44 * 6))
        filterSortView.delegate = self
        filterSortView.isHidden = true
        view.addSubview(filterSortView)
        
        //右
        filterListView = ShopFilterListBtnView(frame: CGRect(x: 0, y: 64+44+1, width: UIScreen.main.bounds.size.width, height: 340))
        filterListView.delegate = self
        filterListView.isHidden = true
        view.addSubview(filterListView)
        
        let dataFilePath = Bundle.main.path(forResource: "TakeawayHome", ofType: "json")
        let data = FileManager.default.contents(atPath: dataFilePath!)
        let contentStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
        datas = TakeawayHomeModel.mj_object(withKeyValues: contentStr)
        print(datas)
    
    }
    
    //MARK: - filter view delegate
    
    func didSelectedShopItem(_ shopInfo: Categorydetails) {
        filterView?.isHidden = true
        
        for item  in segmentBtns {
            if item.tag == 100 {
                tmpLeftBtn?.isSelected = false
                item.updateUI(tmpLeftBtn!)
                break
            }
        }
        
        print("选中商品： \(shopInfo.shopItemName)")
    }
    
    
    //MARK: ShopFilterListBtnViewDelegate
    func clickedFilterListBtn(_ selectedBtnInfo: [NSInteger]) {
        filterListView.isHidden = true
        
        for item  in segmentBtns {
            if item.tag == 102 {
                tmpLeftBtn?.isSelected = false
                item.updateUI(tmpLeftBtn!)
                break
            }
        }
        
        print("筛选方式：\(selectedBtnInfo)")
    }
    
    //MARK: ShopFilterSortViewDelegate
    func didSelectSortItem(_ currentIndex: Int) {
        
        filterSortView.isHidden = true
        
        for item  in segmentBtns {
            if item.tag == 101 {
                tmpLeftBtn?.isSelected = false
                item.updateUI(tmpLeftBtn!)
                break
            }
        }
        
        print("排序方式：\(currentIndex)")
    }
    
    //MARK: LCFileterButtonDelegate 
    func tapButtonWithCurrentTag(_ currentBtn: UIButton, currentTag: Int) {
        
        if currentBtn.isSelected == true {
            showFilterListView(currentTag)
        } else {
            hideFilterListView(currentTag)
        }
        
        if tmpLeftBtn == currentBtn {
            //hideFilterListView(currentTag)
            return
        }
        
        if tmpLeftBtn != nil {
            tmpLeftBtn?.isSelected = false
            for item  in segmentBtns {
                if item.tag == tmpLeftBtn?.tag
                {
                    item.updateUI(tmpLeftBtn!)
                    break
                }
            }
        }
        tmpLeftBtn = currentBtn
        tmpLeftBtn?.tag = currentTag
    }
    
    //MARK: - TakeawayShopListCellDelegate
    func clickExpandBtn(_ id: TakeawayShopLIstCell) {
        let indexPathRow = id.tag - 100
        
        if datas.shopList[indexPathRow].extendedAttributes.count >= 2 {
            
            if selectIndexInfo.contains(indexPathRow) == true {
                let index = selectIndexInfo.index(of: indexPathRow)
                selectIndexInfo.remove(at: index!)
                
            } else {
                selectIndexInfo.append(indexPathRow)
                
            }
            let indexPath = IndexPath(row: indexPathRow, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
    }
    
    //MARK: - uitableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.shopList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TakeawayShopLIstCell! = tableView.dequeueReusableCell(withIdentifier: "TakeawayShopLIstCell") as? TakeawayShopLIstCell
        if cell == nil {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "TakeawayShopLIstCell", bundle: bundle)
            cell = nib.instantiate(withOwner: nil, options: nil)[0] as! TakeawayShopLIstCell
            cell.selectionStyle = .none
            
        }
        if indexPath.row == 0 {
            cell.firstCell = true
        } else {
            cell.firstCell = false
        }
        cell.tag = indexPath.row + 100
        
        cell.delegate = self
        if selectIndexInfo.count > 0 {
            if selectIndexInfo.contains(indexPath.row) {
                cell.withDetails = true
            } else {
                cell.withDetails = false
            }
        }
        cell.setModel(datas.shopList[indexPath.row])
        cell.setExpandingModel(datas.shopList[indexPath.row].extendedAttributes)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var high = datas.shopList[indexPath.row].extendedAttributes.count * 21 + 90
        if high > 21 * 2 + 90  {
            if selectIndexInfo.contains(indexPath.row) != true {
                high =  21 * 2 + 90
            }
            if indexPath.row == 0 {
                high = high - 9
            }
            return CGFloat(high)
        }
        if indexPath.row == 0 {
            high = high - 9
        }
        return CGFloat(high)
    }
    
    
    
    //MARK: - private help func
    func showFilterListView(_ viewTag: Int ) {
        if viewTag == 100 {
            filterView?.isHidden = false
            filterSortView.isHidden = true
            filterListView.isHidden = true
        } else if viewTag == 101 {
            filterView?.isHidden = true
            filterSortView.isHidden = false
            filterListView.isHidden = true
        } else {
            filterView?.isHidden = true
            filterSortView.isHidden = true
            filterListView.isHidden = false
        }
    }
    
    func hideFilterListView(_ viewTag: Int ) {
        //hide lastView
        if viewTag == 100 {
            filterView?.isHidden = true
        } else if viewTag == 101 {
            filterSortView.isHidden = true
        } else {
            filterListView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
