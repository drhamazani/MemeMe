//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Ahmed Alhamazani on 06/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Global Variables
    var window: UIWindow?
    var memes = [Meme]()  // Create a variable as an array of Meme struct's instances.

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }


}

