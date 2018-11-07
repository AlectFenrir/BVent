//
//  AppDelegate.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 08/05/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import CoreData
import Firebase

//let primaryColor = UIColor(red: 210/255, green: 109/255, blue: 180/255, alpha: 1)
//let secondaryColor = UIColor(red: 52/255, green: 148/255, blue: 230/255, alpha: 1)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //        let defaults = UserDefaults.standard
        //        let signIn = defaults.bool(forKey: "signIn")
        //        let skip = defaults.bool(forKey: "skip")
        //        let doneChooseInterest = defaults.bool(forKey: "doneChooseInterest")
        //        let signUp = defaults.bool(forKey: "signUp")
        
        //        if signUp
        //        {
        //            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //            let nextView: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "chooseInterest")
        //
        //            window?.rootViewController = nextView
        //        }
        //
        //        if signIn
        //        {
        //            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //            let nextView: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "main") as! UITabBarController
        //
        //            window?.rootViewController = nextView
        //
        //        }
        //        if skip
        //        {
        //            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //            let nextView: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "main") as! UITabBarController
        //
        //            window?.rootViewController = nextView
        //        }
        //
        //        else if doneChooseInterest
        //        {
        //            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //
        //            let nextView: UITabBarController = mainStoryboard.instantiateViewController(withIdentifier: "main") as! UITabBarController
        //
        //            window?.rootViewController = nextView
        //        }
        //
        //        else {
        //            UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
        //            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.red
        //        }
        
        FirebaseApp.configure()
        
        Database.database().isPersistenceEnabled = true
        
//        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navigation")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch), for: .default)
        //UINavigationBar.appearance().isTranslucent = false
        
//        let authListener = Auth.auth().addStateDidChangeListener { auth, user in
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//            if user != nil {
//
//                UserService.observeUserProfile(user!.uid) { userProfile in
//                    UserService.currentUserProfile = userProfile
//                }
//                //
//                let controller = storyboard.instantiateViewController(withIdentifier: "main") as! UITabBarController
//                self.window?.rootViewController = controller
//                self.window?.makeKeyAndVisible()
//            } else {
//
//                UserService.currentUserProfile = nil
//
//                // Welcome screen
//                let controller = storyboard.instantiateViewController(withIdentifier: "welcomeViewController") as! welcomeViewController
//                self.window?.rootViewController = controller
//                self.window?.makeKeyAndVisible()
//            }
//        }
        
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "BVent_Alpha")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

