//
//  AppDelegate.swift
//  Chat
//
//  Created by Joshua Finch on 04/05/2017.
//  Copyright © 2017 Joshua Finch. All rights reserved.
//

import UIKit
import CoreData

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var coreData: CoreData?
    
    // MARK: - Application Lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setup()
        
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let rootViewController = mainStoryboard.instantiateInitialViewController()

        let messageImporter = MessageImporter(label: "message.importer", persistentContainer: coreData!.persistentContainer!)
        
        let chatService = ChatService()
        chatService.messageImporter = messageImporter
        
        let chatViewController = ChatViewController()
        chatViewController.chatService = chatService
        chatViewController.persistentContainer = coreData!.persistentContainer!
        
        let navigationController = UINavigationController(rootViewController: chatViewController)
        
        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
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
        
        coreData?.saveViewContext()
    }

    // MARK: - Private
    
    private func setup() {
        coreData = CoreData(name: "Model", storeType: .SQLite, loadPersistentStoresCompletionHandler: { [weak self] (success) in
            if success {
                self?.loadedPersistentStores()
            } else {
                self?.couldNotLoadPersistentStores()
            }
        })
    }
    
    private func loadedPersistentStores() {
        // Loaded core data persistent stores, safe to do other core data operations
        print("Loaded persistent stores")
    }
    
    private func couldNotLoadPersistentStores() {
        // Could not load core data persistent stores, unsafe to do other core data operations
    }
}

