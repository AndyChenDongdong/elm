//
//  AppDelegate.swift
//  ElmDemo
//
//  Created by zhenglanchun on 16/5/29.
//  Copyright © 2016年 LC. All rights reserved.
//

import UIKit
import Parse


@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame:UIScreen.main.bounds)
        
        let takeawayVC = TakeawayViewController()
        let orederVC = OrderController()
        let exploreVC = ExploreController()
        let mineVC = MineController()
        let controllers = [takeawayVC, orederVC, exploreVC, mineVC]
        
        let tabbarVC = UITabBarController.init()
        tabbarVC.viewControllers = controllers
        
        let nav = UINavigationController.init(rootViewController: tabbarVC)
        nav.navigationBar.barTintColor = NAVBG_COLOR
        //统一设定 navigation title颜色
        let navigationBarApperace = UINavigationBar.appearance()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        navigationBarApperace.titleTextAttributes = titleDict as? [String: AnyObject]
        
        takeawayVC.tabBarItem = UITabBarItem(
            title: "Delivery",
            image: UIImage(named: "外卖-边框"),
            selectedImage: UIImage(named: "外卖-填充")
        )
        
        orederVC.tabBarItem = UITabBarItem(
            title: "Order",
            image: UIImage(named: "订单-边框"),
            selectedImage: UIImage(named: "订单-填充")
        )
        
        exploreVC.tabBarItem = UITabBarItem(
            title: "Finding",
            image: UIImage(named: "发现-边框"),
            selectedImage: UIImage(named: "发现-填充")
        )
        mineVC.tabBarItem = UITabBarItem(
            title: "Me",
            image: UIImage(named: "我的-边框"),
            selectedImage: UIImage(named: "我的-填充")
        )

        window?.rootViewController = nav;
        window?.makeKeyAndVisible()
        
        
        //parse 分割线
        
        
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        Parse.enableLocalDatastore()
               let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
                ParseMutableClientConfiguration.applicationId = "fooddeliveryappcdd"
                ParseMutableClientConfiguration.clientKey = "ab226688"
                ParseMutableClientConfiguration.server = "https://fooddeliveryappcdd.herokuapp.com/parse"
        })
        
        Parse.initialize(with: parseConfiguration)
        
        
        // ****************************************************************************
        // Uncomment and fill in with your Parse credentials:
        // Parse.setApplicationId("your_application_id", clientKey: "your_client_key")
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************
        
        PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.getPublicReadAccess = true
        
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
        
        if application.applicationState != UIApplicationState.background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.responds(to: #selector(getter: UIApplication.backgroundRefreshStatus))
            let oldPushHandlerOnly = !self.responds(to: #selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsKey.remoteNotification] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpened(launchOptions: launchOptions)
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

