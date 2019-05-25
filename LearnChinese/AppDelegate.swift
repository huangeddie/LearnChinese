//
//  AppDelegate.swift
//  LearnChinese
//
//  Created by Eddie Huang on 5/13/19.
//  Copyright © 2019 Eddie Huang. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let center = UNUserNotificationCenter.current()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound, .badge])
        { (granted, error) in
            // Enable or disable features based on authorization.
            if !granted {
                return
            }
            
            self.createNewEntryNotification()
            self.createReviewEntryNotification()
        }
        
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "launchedBefore") {
            
            let context = persistentContainer.viewContext
            
            // Clear sources
            
            let sourcesFetch = Source.fetchRequest() as NSFetchRequest<Source>
            do {
                let sources = try context.fetch(sourcesFetch)
                for source in sources {
                    context.delete(source)
                }
                
            } catch {
                fatalError("Failed to fetch entries: \(error)")
            }
            
            
            // Give some sources
            
            let names = ["Google Translate", "eChineseLearning"]
            let urls = ["googletranslate://", "https://www.echineselearning.com/resources/speak-chinese/dialogue.html"]
            
            for (name, url) in zip(names, urls) {
                let source = NSEntityDescription.insertNewObject(forEntityName: "Source", into: context) as! Source
                source.name = name
                source.url = URL(string: url)
            }
            saveContext()
            
            userDefaults.set(true, forKey: "launchedBefore")
        }
        
        
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
        
        UIApplication.shared.applicationIconBadgeNumber = 0
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
        let container = NSPersistentContainer(name: "LearnChinese")
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
    
    // MARK: - Notifications
    private func createNewEntryNotification() {
        // Notifications
        let content = UNMutableNotificationContent()
        content.title = "Time for a New Entry"
        content.subtitle = "新的中文短语"
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        //            dateComponents.weekday = 1  // Sunday
        //            dateComponents.hour = 12    // 12:00 hours
        dateComponents.second = 0
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let request = UNNotificationRequest(identifier: "new-entry",
                                            content: content, trigger: trigger)
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }
    
    private func createReviewEntryNotification() {
        // Notifications
        let content = UNMutableNotificationContent()
        content.title = "Time for review"
        content.subtitle = "复习中文"
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        dateComponents.weekday = 5  // Thursday
        dateComponents.hour = 12    // 12:00 hours
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        
        // Create the request
        let request = UNNotificationRequest(identifier: "review-entry",
                                            content: content, trigger: trigger)
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }

}

