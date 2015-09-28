//
//  AppDelegate.swift
//  Chipmunk
//
//  Created by Daniel Mathews on 2015-09-26.
//  Copyright © 2015 Daniel Mathews. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId(APIKeys.parseApplicationID(), clientKey: APIKeys.parseClientID())
        
//        let testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            print("Object has been saved.")
//        }
        
        if PFUser.currentUser() != nil { //user is logged into app
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let listVC = storyboard.instantiateInitialViewController()
            
            window?.rootViewController = listVC
            window?.makeKeyAndVisible()
            
        }else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let signupVC = storyboard.instantiateInitialViewController()
            
            window?.rootViewController = signupVC
            window?.makeKeyAndVisible()
        }
        
        let settings = UIUserNotificationSettings(forTypes:[UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // Extract the notification data
        if let notificationPayload = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            
            if let userId = notificationPayload["p"] as? String {
                let targetUser = PFUser(withoutDataWithObjectId: userId)
                
                // Fetch photo object
                targetUser.fetchIfNeededInBackgroundWithBlock {
                    (user: PFObject?, error:NSError?) -> Void in
                    if error == nil {
                        if let profileUser = user as? PFUser {
                            // Show photo view controller
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let profileVC = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
                            profileVC.user = profileUser
                        }
                    }
                }
            }
        }
        
        return true
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        

    }

    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.addUniqueObject((PFUser.currentUser()?.objectId)!, forKey: "channels")
        installation.saveInBackground()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

