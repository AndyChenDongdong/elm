//
//  TakeawayViewController.swift
//  ElmDemo
//
//  Created by zhenglanchun on 16/5/29.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

import Parse
class TakeawayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TakeawayShopLIstCellDelegate, TakeawayClassificationCellDelegate {
   
    let contentJSON:String = ""
    
    
    
    
    
    
    
    
    
    var shopList : [String:Any] = ["shopList":""]
    var shopInfoDictionary : [String:Any] = ["shopName": "", "shopRating": ""]
    
    
    //holding the information for the shopList
    var shopInforDictionaryArray :[Any] = []
    
    
    var shopInfoDictionaryArrayDictionary :[String:Any] = [:]
    
    
    var shopListDictionary = [String:Any]()
    var shopObjects = Array<PFObject>()
    
    
    func loadThePFObjectIntoString(){
    for shopObject in shopObjects {
    
    let shopName = shopObject.value(forKeyPath: "shopName") as? String
    let shopRating = shopObject.value(forKeyPath: "shopRating") as? String
    shopInfoDictionary.updateValue(shopName!,forKey: "shopName")
    shopInfoDictionary.updateValue(shopRating!, forKey: "shopRating")
    shopInforDictionaryArray.append(shopInfoDictionary)
    shopInfoDictionaryArrayDictionary["shopInfo"] = shopInforDictionaryArray
    
    shopListDictionary["shopList"] = shopInfoDictionaryArrayDictionary
    
        }}
    
    
    
    
    func transferStringToJSon(){
        if let json = try? JSONSerialization.data(withJSONObject: shopListDictionary, options: [])
        {
            if let contentJSON = String(data: json, encoding: String.Encoding.utf8)
            {
                // here `content` is the JSON data decoded as a String
                print(contentJSON)
            }
            
            // here `json` is your JSON data
        }
    }

    
    func loadTheDataFromParse(){
        
        
        
        let query:PFQuery = PFQuery(className: "ShopList")
        
        // let latitude = 33.0
        // let longtitude = -122.0
        query.whereKeyExists("shopImg")
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
    
    
    
    
    
    
    
  




/////////////////////////////
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var lastY: CGFloat = 0.0
    var model: TakeawayHomeModel!
    var selectIndexInfo: [Int] = []
    
    override func viewDidLoad() {
        
       
        super.viewDidLoad()
        
       
        
        
       


               
      //  loadTheDataFromParse()
        
        
          ////////

        self.automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsetsMake(44 - 8, 0, 0, 0)
        searchBar.barTintColor = NAVBG_COLOR
        //load data
        
        
        let filePath = Bundle.main.path(forResource: "TakeawayHome", ofType: "json")
        let contentData = FileManager.default.contents(atPath: filePath!)
        let content = NSString(data:contentData!, encoding: String.Encoding.utf8.rawValue) as String?
        // model = TakeawayHomeModel.mj_object(withKeyValues: content)
        //  print(model)
        
    
        model = TakeawayHomeModel.mj_object(withKeyValues: content)
        print(model)
        
       
        

        
 /*
        
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackground { (sucess, error) in
            print("Object has been saved")
        }
 
 */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitleView()
    //     loadTheDataFromParse()
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.navigationItem.titleView = nil
    }
    
    func leftClicked()  {
        print("left")
            }
    
    func titleBtnClick() {
        print("titleBtn clicked")
    }
    
    func setupTitleView() {
        let titleViewBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
        
        titleViewBtn.setTitle("农光里", for: UIControlState())
        titleViewBtn.setImage(UIImage(named: "定位"), for: UIControlState())
        titleViewBtn.setTitleColor(NAVIGATIONTITLEH_COLOR, for: .highlighted)
        titleViewBtn.setTitleColor(UIColor.white, for: UIControlState())
        titleViewBtn.addTarget(self, action: #selector(TakeawayViewController.titleBtnClick), for: .touchUpInside)
        tabBarController?.navigationItem.titleView = titleViewBtn

    }
    
    //MARK: - search button clicked
    @IBAction func searchBtnClick(_ sender: UIButton) {
        let searchVC = TakeawaySearchController.init()
        self.navigationController!.pushViewController(searchVC, animated: true)
    }
    
    
    //MARK: - TakeawayClassificationCellDelegate
    func shopCategoryItemSelected(_ currentTag: Int) {
        print("selectedItem: \(currentTag)")
        
        switch currentTag {
        case 100:
            let filterController = ShopFilterController()
            filterController.title = "Food"
            navigationController?.pushViewController(filterController, animated: true)
            break
        case 101:
            let filterController = ShopFilterController()
            filterController.title = "Recommended Delicacy"
            navigationController?.pushViewController(filterController, animated: true)
            break
        case 102:
            let webVC = CommonWebController()
            navigationController?.pushViewController(webVC, animated: true)
            webVC.title = "Booked Breakfast"
            break
            
        case 103:
            let filterController = ShopFilterController()
            filterController.title = "蜂鸟专送"
            navigationController?.pushViewController(filterController, animated: true)
            break
            
        case 104:
            let filterController = ShopFilterController()
            filterController.title = "Supermarket&Convenience stores"
            navigationController?.pushViewController(filterController, animated: true)
            break
            
        case 105:
            let filterController = ShopFilterController()
            filterController.title = "Dessert&Drink"
            navigationController?.pushViewController(filterController, animated: true)
            break
            
        case 106:
            let filterController = ShopFilterController()
            filterController.title = "Vegetable"
            navigationController?.pushViewController(filterController, animated: true)
            break
            
        case 107:
            let filterController = ShopFilterController()
            filterController.title = "Flower&Cake"
            navigationController?.pushViewController(filterController, animated: true)
            break
        default:break
        }
    }
    

    
    //MARK: - TakeawayShopListCellDelegate
    func clickExpandBtn(_ id: TakeawayShopLIstCell) {
        let indexPathRow = id.tag - 100
        
        if model.shopList[indexPathRow].extendedAttributes.count >= 2 {
            
            if selectIndexInfo.contains(indexPathRow) == true {
                let index = selectIndexInfo.index(of: indexPathRow)
                selectIndexInfo.remove(at: index!)
            } else {
                selectIndexInfo.append(indexPathRow)
            }
            let indexPath = IndexPath(row: indexPathRow, section: 2)
            tableView.reloadRows(at: [indexPath], with: .none)
        }

    }
    
    //MARK: - tableView delegate didSelectRowAtIndexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TakeawayShopItemListController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - tableView dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }
        return model.shopList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "TakeawayClassificationCell") as? TakeawayClassificationCell
            if cell == nil {
               
                let bundle = Bundle(for: type(of: self))
                let nib = UINib(nibName: "TakeawayClassificationCell", bundle: bundle)
                cell = nib.instantiate(withOwner: nil, options: nil)[0] as? TakeawayClassificationCell
                cell!.selectionStyle = .none
            }
            cell!.delegate = self
            
            return cell!
        } else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "TakeawaySalesCell")
            if cell == nil {
                let bundle = Bundle(for: type(of: self))
                let nib = UINib(nibName: "TakeawaySalesCell", bundle: bundle)
                cell = nib.instantiate(withOwner: nil, options: nil)[0] as! TakeawaySalesCell
                cell!.selectionStyle = .none
            }
            return cell!
        } else {
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
            
            cell.setModel(model.shopList[indexPath.row])
            cell.setExpandingModel(model.shopList[indexPath.row].extendedAttributes)
            
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 274
        } else if indexPath.section == 1 {
            return 189
        } else {
            
            var high = model.shopList[indexPath.row].extendedAttributes.count * 21 + 90
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
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    //MARK: - UIScrollView delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            
            lastY = scrollView.contentOffset.y
        }
        
    }
    
    //MARK
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            if scrollView.contentOffset.y < -100 {
                topConstraint.constant = 64 - 8
                return
            } else if scrollView.contentOffset.y >= -64 {
                topConstraint.constant = 20
                return
            }
            
            //- 108 - (-44) = -64
            // delt = last = -108
            
            //topConstraint -64 -> -20
            let y = scrollView.contentOffset.y
            //
            let delt =  y - lastY
            print("delt: \(delt)")
            
            if  delt < 44 - 8 {
                topConstraint.constant = 64 - 8  - delt
            } else {
                topConstraint.constant = 20
            }
            
            if topConstraint.constant >= 64 - 8 {
                topConstraint.constant = 64 - 8
            }
            
            self.view.setNeedsLayout()
            
            
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

}
