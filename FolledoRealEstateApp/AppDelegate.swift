//
//  AppDelegate.swift
//  FolledoRealEstateApp
//
//  Created by Samuel Folledo on 10/14/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//e3258093-1466-4ddd-acde-667495920a4b

import UIKit
import Firebase //RE ep.6 1min
import OneSignal //RE ep.6 1min //Not importing backendless because it's already connected to our Bridging header which automatically allows us to use it all over our project, but still need to set up at 2mins online with its APP_ID, and APP_KEY
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let APP_ID =  "6F5851E4-03F2-5A0B-FF8F-6EE34AB00100" //RE ep.6 2mins from backendless website's project settings
    let API_KEY = "86F6D554-479C-848F-FF2B-4B4322D93600" //RE ep.6 2mins backendless's api_key
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        FirebaseApp.configure() //RE ep.6 2mins start firebase
        backendless!.initApp(APP_ID, apiKey: API_KEY) //RE ep.6 5mins start backendless
        
        IAPService.shared.getProducts() //RE ep.140 2mins as soon as the app runs, we will get our product
        
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: kONESIGNALAPPID, handleNotificationReceived: nil, handleNotificationAction: nil, settings: nil) //RE ep.6 6mins appId can be found in OneSignal's site -> App Settings -> Keys & IDs.
        
        Auth.auth().addStateDidChangeListener { (auth, user) in //RE ep.23 3mins
            if user != nil { //RE ep.23 4mins
                if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil { //RE ep.23 5mins kCURRENTUSER = "currentUser" we check if there is something saved in our UserDefaults
                    DispatchQueue.main.async { //RE ep.23 5mins everytime our user logs in, get the user's oneSignal ID so we can save it to our userObject in firebase and locally so we can update our user with the one signalID if it has changed for some reason
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId" : FUser.currentId()]) //RE ep.23 6-8mins //since we're checking if we have user in our local UserDefault so we can call FUser func and get the currentID. So everytime a user opens the app and there is a logged in user, we notify the NotificationCenter that a user logged in which is the FUser.currentId()
                    }
                }
            }
        }
        
        
        func onUserDidLogin(userId: String) { //RE ep.23 8mins once the NotificationCenter receives our currentId(), it doesnt know what to do with it, so we have to tell it what to do //RE ep.23 9mins
            //start oneSignal
            startOneSignal()
        }
        
        
//observer
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "UserDidLoginNotification"), object: nil, queue: nil) { (note) in //RE ep.23 10mins when we receive this type of notification... we get userId
            let userId:String = note.userInfo!["userId"] as! String //RE ep.23 11mins now we are receiving userInfo that we received //we are accessing "userId" that was passed in userInfo
            UserDefaults.standard.set(userId, forKey: "userId") //RE ep.23 12mins
            UserDefaults.standard.synchronize() //RE ep.23 12mins now we have userId, we save it
            
            onUserDidLogin(userId: userId) //RE ep.23 12mins now we can start oneSignal
        }
        
        
        if #available(iOS 10.0, *) { //RE ep.19 0min check ios 10 or later
            let center = UNUserNotificationCenter.current() //RE ep.19 1min
            center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in //RE ep.19 2mins requesting permission from user
                
            }
            application.registerForRemoteNotifications() //RE ep.19 3mins
            
        } //else {} //RE ep.19 0min previous OS which we will not make so we dont need
        
        
        
        return true
    }

    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) { //RE ep.19 3mins this checks if the application was registered for remote notification
        
        Auth.auth().setAPNSToken(deviceToken, type: .unknown) //RE ep.19 4mins
        //type .production, we use .prod because we uploaded our certificate //token mistmatch
        //type .sandbox //invalid token
        //type .unknown //works before releasing the app
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) { //RE ep.19 4mins
        
        if Auth.auth().canHandleNotification(userInfo) { //RE ep.19 5mins checks if we can userinfo if it can receive notif
            completionHandler(.noData) //RE ep.19 5mins there was no new data to download
            return
        }
        
        //this is not firebase notification...
        /*SUMMARY OF HOW THE MOBILE NOTIFICATION WORKS.... //RE ep.19 6mins
            When user with mobile phone sends a request code, Firebase sends a silent notification from the device (user will not see this). And it will check if the request came from the device, if it was, Firebase is going to send us the real SMS. That is what these 2 AppDelegate method are doing didRegisterForRemoteNotificationsWithDeviceToken and didReceiveRemoteNotification. Also dont forget dudFailToRegisterForRemoteNotifications
        */
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { //RE ep.19 7mins
        print("Failed to register for user notifications") //RE ep.19 7mins
    }
    
    
    
    //MARK: OneSignal
    func startOneSignal() { //RE ep.23 13mins
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState() //RE ep.23 14mins
        let userID = status.subscriptionStatus.userId //RE ep.23 14mins OneSignal returns the userId of our user
        let pushToken = status.subscriptionStatus.pushToken //RE ep.23 14mins receive our two info needed from OneSignal
        
        if pushToken != nil { //RE ep.23 14mins unwrap token and userID
            if let playerId = userID { //RE ep.23 15mins if we have the userID, save that in our UserDefaults
                UserDefaults.standard.set(playerId, forKey: "OneSignalId") //RE ep.23 16mins save it forKey "OneSignalId"
            } else { //RE ep.23 16mins
                UserDefaults.standard.removeObject(forKey: "OneSignalId") //RE ep.23 16mins if we dont have then remove it
            }
        }
        
        print("One signal started... udating OneSignalId in Firebase")
        //save to our user object
        updateOneSignalId() //RE ep.25 6mins
    }
    
    
    
    
    
    
    
    
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }


}

