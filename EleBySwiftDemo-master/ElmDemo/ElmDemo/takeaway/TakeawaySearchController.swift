//
//  TakeawaySearchController.swift
//  ElmDemo
//
//  Created by z on 16/5/30.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit
import Parse
class TakeawaySearchController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "搜索"
        setleftBarButtonItem("向左箭头")
        
        let testObject = PFObject(className: "TestObject")
        
        testObject["foo"] = "lol"
        testObject.saveInBackground { (success, error) -> Void in
            print("Object has been saved.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
