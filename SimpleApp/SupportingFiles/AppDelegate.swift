//
//  AppDelegate.swift
//  SimpleApp
//
//  Created by Юрий Альт on 20.06.2023.
//

import UIKit
import netfox

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Database FilePath : ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found")
        
        startNetfoxNetworkDebugger()
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewController = MainViewController()
        let searchService = SearchService()
        let mainViewPresenter = MainViewPresenter(view: mainViewController, searchService: searchService)
        mainViewController.presenter = mainViewPresenter
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        return true
    }

    private func startNetfoxNetworkDebugger() {
        NFX.sharedInstance().start()
    }
}

