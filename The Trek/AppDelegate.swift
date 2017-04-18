//
//  AppDelegate.swift
//  The Trek
//
//  Created by Jordan Lunsford on 2/3/16.
//  Copyright © 2016 Jordan Lunsford. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
	var vc : ViewController = ViewController()
	
	let save = UserDefaults.standard
	
	var notificationPermissionSent = false
	var welcomeMessageSent = false
	
	var notificationsGranted = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		
		//MARK: Load Values
		if save.object(forKey: "notificationPermissionSent") == nil {
			save.set([notificationPermissionSent], forKey: "notificationPermissionSent")
		} else {
			notificationPermissionSent = (save.object(forKey: "notificationPermissionSent")! as! NSArray)[0] as! Bool
		}
		
		if save.object(forKey: "welcomeMessageSent") == nil {
			save.set([welcomeMessageSent], forKey: "welcomeMessageSent")
		} else {
			welcomeMessageSent = (save.object(forKey: "welcomeMessageSent")! as! NSArray)[0] as! Bool
		}
		
		//MARK: Check if notification message has been sent
		if notificationPermissionSent == false && welcomeMessageSent == true {
			notificationPermission()
		}
		return true
    }
	
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

		UIApplication.shared.ignoreSnapshotOnNextApplicationLaunch()
		exit(0) // GET RID OF THIS
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Only called when re-entering foreground. Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
		
		//vc.updateBenIsBusyTimer()
		
		//print("applicationWillEnterForeground")
		//vc.viewDidLoad()
		/*if vc.history.objectForKey("savedBenBusyTimer") != nil { // && vc.benBusyTimerAdjustedInLoad == false
			vc.delay(1.0) {
				let difference = ((self.vc.history.objectForKey("savedBenBusyTimer")!  as! NSArray)[0] as! NSDate).timeIntervalSinceDate(NSDate())
				if difference >= 0 {
					self.vc.benBusyTimer = NSTimer.scheduledTimerWithTimeInterval(difference, target: self.vc, selector: #selector(ViewController.nextMessage), userInfo: nil, repeats: false)
					//self.vc.benBusyTimerAdjustedInLoad = false
				}
			}
		}*/
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
		// Called on launch and re-entering forground. Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		
		UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
		//ViewController().saveGame()
		//ViewController().history.synchronize()
		//print("applicationWillTerminate")
    }

	
	//MARK: Notifications
	func scheduleNotification(time: Double) {
		
		let trigger = UNTimeIntervalNotificationTrigger(
			timeInterval: time,
			repeats: false)
		
		let content = UNMutableNotificationContent()
		content.body = "[Ben is waiting for you]"
		content.sound = UNNotificationSound.default()
		content.badge = 1
		
		let request = UNNotificationRequest(
			identifier: "benIsWaiting",
			content: content,
			trigger: trigger)
		
		//UIApplication.shared.applicationIconBadgeNumber = 1
		
		//UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
		UNUserNotificationCenter.current().add(request) {(error) in
			if let error = error {
				print("Error: \(error)")
			}
		}
	}
	
	func notificationPermission() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(accepted, error) in
			if accepted == true {
				self.notificationsGranted = true
			}
		}
		notificationPermissionSent = true
		save.set([notificationPermissionSent], forKey: "notificationPermissionSent")
	}
	
	/*func application(_ application: UIApplication, // Should be able to replace in-app timer
	                 didReceiveRemoteNotification userInfo: [AnyHashable : Any],
	                 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		
		vc.history.removeObject(forKey: "savedBenBusyTimer")
		vc.history.set([Date()], forKey: "savedBenBusyTimer")
	}*/
	
	
	
	
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "jordanlun.The_Trek" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "The_Trek", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

