//
//  AppDelegate.swift
//  HostApp
//
//  Created by Aron Balog on 08/08/2019.
//  Copyright © 2019 Forensic. All rights reserved.
//

import UIKit
import CoreNavigation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Router.shared.register(routableType: Other.self)
        
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }



}

