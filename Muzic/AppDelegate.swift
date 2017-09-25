//
//  AppDelegate.swift
//  Muzic
//
//  Created by Michael Ngo on 1/16/17.
//

import UIKit
import MuzicFramework
import CoreData
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var context: NSManagedObjectContext?
    
    var tabController: TabBarViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        tabController = TabBarViewController()
        window?.rootViewController = tabController
        UIApplication.shared.statusBarStyle = .lightContent
        createFolder()
        let dataController = DataController()
        context = dataController.managedObjectContext
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
        do {
            try self.context?.save()
        } catch {
            print("Terminate error")
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let mediaId = url.absoluteString.components(separatedBy: "//")[1]
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorited == %@", NSNumber(booleanLiteral: true))
        do {
            if let results = try context?.fetch(fetchRequest) {
                let list = List<Item>()
                for result in results {
                    list.add(key: result)
                }
                while true {
                    if list.getCurrentKey().id == mediaId { break }
                    list.next()
                }
                tabController?.playerController?.playlist = list
                tabController?.playerController?.context = context
                tabController?.present((tabController?.playerController)!, animated: true, completion: nil)
            }
        } catch {
            print("Cannot open from widget")
        }
        return true
    }

    func createFolder() {
        if !FileManager.default.fileExists(atPath: PLAYER_IMAGE_DIR_URL.path, isDirectory: nil) {
            do {
                try FileManager.default.createDirectory(at: PLAYER_IMAGE_DIR_URL, withIntermediateDirectories: false, attributes: nil)
            } catch let error {
                print(error)
            }
        }
    }

}

