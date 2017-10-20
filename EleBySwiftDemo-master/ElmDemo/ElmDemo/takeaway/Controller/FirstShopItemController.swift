//
//  FirstShopItemController.swift
//  ElmDemo
//
//  Created by zhenglanchun on 16/6/19.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit

let FIRSTSHOPITEMNOTIFICATION = "firstShopItemAddOrCancelNotiName"
class FirstShopItemController: UIViewController, ShopListViewDelegate {

    var listView: ShopListView!
    
    var heigh: CGFloat {
        get {
            print("max high: \(listView.currentHigh())")
           return listView.currentHigh()
        }
    }
    var contentOffset: CGPoint {
        get {
            return listView.tableView.contentOffset
        }
        set(contentOffset) {
            listView.tableView.contentOffset = contentOffset
        }
    }
    
    var model: ShopListModel!
    var leftMenuNames: [String] = []
    var groupItemCounts: [Int] = []
    
    var targetView: UIView?
    //sepcificationView
    var specificationView: SpecificationSelectedView?
    
    var boundsYOfListView: CGFloat = 204
    
    //count 
    var count: NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add observer
        NotificationCenter.default.addObserver(self, selector: #selector(boundsOfSuperViewChanged), name: NSNotification.Name(rawValue: BOUNDSCHANGEDNOTIFICATIONNAME), object: nil)
        
        loadData()
        setupUI()
        specificationView = SpecificationSelectedView(frame: view.bounds)
        specificationView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        specificationView?.alpha = 1
        specificationView?.isHidden = true
        let delayTime = DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            [unowned self] in
            self.navigationController?.view.addSubview(self.specificationView!)
        }
        
        specificationView?.cancelButtonClicked = {
            [unowned self] (sender: UIButton)in
            self.specificationView?.isHidden = true
            
            
        }
        specificationView?.confirmButtonClicked = {
            (sender: UIButton) in
            self.specificationView?.isHidden = true
            self.specificationButtonAnimation(sender)
            
        }
        
    }
    
    func loadData() {
        let filePath = Bundle.main.path(forResource: "shopListData", ofType: "json")
        let contentData = FileManager.default.contents(atPath: filePath!)
        let content = NSString(data: contentData!, encoding: String.Encoding.utf8.rawValue) as String?
        model = ShopListModel.mj_object(withKeyValues: content)
        print(model)
        
        for item in model.data {
            leftMenuNames.append(item.categories)
            groupItemCounts.append(item.shopList.count)
        }
    }
    
    func setupUI() {
        listView = ShopListView(frame: view.bounds)
        listView.delegate = self
        listView.tableView.isScrollEnabled = false
        view.addSubview(listView)
        listView.setLeftMenu(leftMenuNames, withGroupItemCount: groupItemCounts)
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            print(self.heigh)
        }
        
    }
    //MARK: - cell button clicked
    func showSpecificationView(_ sender: UIButton) {
        
        specificationView?.isHidden = false
    }
    
    //MARK: - notification observer
    func boundsOfSuperViewChanged(_ noti: Notification) {
        
        let userInof = noti.userInfo!
        let boundsY = userInof["boundsY"] as! CGFloat
        print("boundsY值：\(boundsY)")
        boundsYOfListView = boundsY
    }
    
    //MARK: - animation
    func addOrMinusButtonAnimation(_ targetButton: UIButton) {
        //放置动画未执行完前再次执行动画
        for tmpView in view.subviews {
            if targetView == tmpView {
                return
            }
        }

        print("\(UIScreen.main.bounds.size)")
        
        var rect = view.convert(CGRect.zero, from: targetButton)
        rect.size = CGSize(width: 20, height: 20)
  
        
        targetView = UIView(frame: rect)
        targetView?.backgroundColor = BUTTONBGCOLOR
        view.addSubview(targetView!)
        targetView?.layer.cornerRadius = 10
        
        let startPosition = targetView!.layer.position
        let endPosition = CGPoint(x: 0 + 23, y: UIScreen.main.bounds.size.height -  28  - boundsYOfListView)
        print(endPosition.y)
        let controlPoint = CGPoint(x: startPosition.x / 4.0, y: startPosition.y - 50)
        let keyValueName = "addCurvAnim"
        
        self.addQuadCurveAnimation(self.targetView!, startPosition: startPosition, endPosition: endPosition, controlPoint: controlPoint, keyValueName: keyValueName)
        
    }
    
    func specificationButtonAnimation(_ targetButton: UIButton) {
        
        
        let rect =  CGRect(x: targetButton.superview!.frame.origin.x + targetButton.frame.origin.x, y: targetButton.superview!.frame.origin.y , width: targetButton.frame.size.width, height: targetButton.frame.size.height)
        
        targetView = UIView(frame: rect)
        targetView?.backgroundColor = BUTTONBGCOLOR
        view.addSubview(targetView!)
        
        let value1 = targetView!.bounds.size.width
        let value2 = 30
        
        let animation = CAKeyframeAnimation(keyPath: "bounds.size.width")
        animation.duration = 0.3
        animation.values = [value1, value2]
        animation.keyTimes = [0.1,0.9]
        animation.setValue("width", forKey: "width")
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        targetView!.layer.add(animation, forKey: nil)
        
        targetView!.layer.cornerRadius = 15
        
        
        let startPosition = targetView!.layer.position
        let endPosition = CGPoint(x: 0 + 23, y: view.frame.size.height - 34)
        let controlPoint = CGPoint(x: startPosition.x / 3.0, y: startPosition.y - 50)
        let keyValueName = "scaleCurvAni"
        let timer = DispatchTime.now() + Double(Int64(0.29 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: timer) {
            [unowned self] in
            self.addQuadCurveAnimation(self.targetView!, startPosition: startPosition, endPosition: endPosition, controlPoint: controlPoint, keyValueName: keyValueName)
        }
    }
    
    func addQuadCurveAnimation(_ item: UIView, startPosition: CGPoint, endPosition: CGPoint, controlPoint: CGPoint, keyValueName: String) {
        //add BezierPath
        let bezierPath = UIBezierPath()
        bezierPath.move(to: startPosition)
        bezierPath.addQuadCurve(to: endPosition, controlPoint: controlPoint)
        
        //add CAKeyframeAnimation
        let moveAnim = CAKeyframeAnimation(keyPath: "position")
        moveAnim.path = bezierPath.cgPath;
        moveAnim.isRemovedOnCompletion = false
        moveAnim.delegate = self as? CAAnimationDelegate
        item.layer.add(moveAnim, forKey: nil)
        
        //add scale animation
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 1.0
        scaleAnim.toValue = 0.7
        
        //add group animation
        let groupAnim = CAAnimationGroup()
        groupAnim.animations = [moveAnim,scaleAnim]
        groupAnim.setValue(keyValueName, forKey: keyValueName)
        groupAnim.isRemovedOnCompletion = false
        groupAnim.delegate = self as? CAAnimationDelegate
        groupAnim.duration = 1
        item.layer.add(groupAnim, forKey: "group")
        
        //辅助线
        let shape = CAShapeLayer()
//        shape.path = bezierPath.CGPath
//        shape.fillColor = UIColor.clearColor().CGColor
//        shape.strokeColor = UIColor.orangeColor().CGColor
//        
//        view.layer.addSublayer(shape)
    }
    //MARK: - animation delegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let value = anim.value(forKey: "scaleCurvAni") as? String
        let addOrMinusButtonValue = anim.value(forKey: "addCurvAnim") as? String
        if  value == "scaleCurvAni" {
            targetView?.removeFromSuperview()
            NotificationCenter.default.post(name: Notification.Name(rawValue: FIRSTSHOPITEMNOTIFICATION), object: nil, userInfo: ["state": "add"])
        }
        if addOrMinusButtonValue == "addCurvAnim" {
            targetView?.removeFromSuperview()
            NotificationCenter.default.post(name: Notification.Name(rawValue: FIRSTSHOPITEMNOTIFICATION), object: nil, userInfo: ["state": "add"])
        }
    }
    
    //MARK: - listView delegate
    func lc_tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ShopListItemCell") as? ShopListItemCell
        if cell == nil {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: "ShopListItemCell", bundle: bundle)
            cell = nib.instantiate(withOwner: nil, options: nil)[0] as? ShopListItemCell
            cell!.selectionStyle = .none
        }
        cell?.setShoplistItem(self.model.data[indexPath.section].shopList[indexPath.row])
        cell?.itemSpecificationButtonClicked = {
            [unowned self] (sender: UIButton)in
            self.showSpecificationView(sender)
        }
        
        cell?.itemAddOrMinusButtonClicked = {
            (sender: UIButton, addState: Bool) in
            if  addState == true {
                self.count += 1
                
                self.addOrMinusButtonAnimation(sender)
                
            } else {
                self.count -= 1
                if self.count < 0 {
                    
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: FIRSTSHOPITEMNOTIFICATION), object: nil, userInfo: ["state": "minus"])
            }
            print(self.count)
        }
        
        return cell!
    }
    
    func lc_tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func lc_tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        print(indexPath.row)
        let detailVC = ShopItemDetailController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
