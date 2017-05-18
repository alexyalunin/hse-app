//
//  AppDelegate.swift
//  HSEapp
//
//  Created by Alexander on 22/01/2017.
//  Copyright © 2017 Alexander. All rights reserved.
//

import UIKit

var hseColor = UIColor(red: 0/255.0, green: 71/255.0, blue: 136/255.0, alpha: 1.0)
var hseColorPassive = UIColor.black.withAlphaComponent(0.5)
var headerColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1.0)

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: TabBar
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().tintColor = hseColor
        UITabBar.appearance().unselectedItemTintColor = .gray
        
        // MARK: NavBar
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = hseColor
        UINavigationBar.appearance().tintColor = .white
        
        // MARK: StatusBar
        UIApplication.shared.statusBarView?.backgroundColor = hseColor
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

