//
//  AppDelegate.swift
//  Tierodactyl
//
//  Created by Margaret Hollis (student LM) on 2/18/20.
//  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    //check for first launch
    var hasAlreadyLaunched :Bool!

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //retrieve value from local store, if value doesn't exist then false is returned
        hasAlreadyLaunched = UserDefaults.standard.bool(forKey: "hasAlreadyLaunched")
        //check first launched
        if (hasAlreadyLaunched)
        {
            hasAlreadyLaunched = true
        }else{
            UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
        }
        
        FirebaseApp.configure()
        return true
    }
    
    func sethasAlreadyLaunched(){
        hasAlreadyLaunched = true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

