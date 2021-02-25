//
//  AppDelegate.swift
//  CashFlowiOS
//
//  Created by Muhammad Ali on 16/02/2021.
//

import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let _ = LocalData.getUser() else {
            let vv = SignIn(nibName: "SignIn", bundle: nil)
            window?.rootViewController = vv
            window?.makeKeyAndVisible()
            return true
        }
        
        let vv = BusinessTypeVC(nibName: "BusinessTypeVC", bundle: nil)
        window?.rootViewController = UINavigationController(rootViewController: vv)
        window?.makeKeyAndVisible()
        return true
    }

    

}

