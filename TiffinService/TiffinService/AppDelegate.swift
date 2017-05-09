//
//  AppDelegate.swift
//  TiffinService
//
//  Created by Nitin Jami on 4/20/17.
//  Copyright © 2017 ghutles. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
     
        FIRApp.configure()
        
        // MARK :- Login Integration Code
        
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        if (FIRAuth.auth()?.currentUser != nil) {
            LaunchViewController.ClientViewMenuVC.setAsRootviewController(animated: true)
        } else {
            LaunchViewController.Login.setAsRootviewController(animated: true)
        }
        
        
        // MARK :- Srikant PushNotification.
        
        // Commented out due to app crashing because of forced un-wrap.
        //print("Token-----------\(FIRInstanceID.instanceID().token()!)")
        let lastOrderDate = UserDefaults.standard.string(forKey: "Date")
        if lastOrderDate != getCurrentDate() {
            UserDefaults.standard.removeObject(forKey: OrderCaher.userDefaultsKey)
            UserDefaults.standard.removeObject(forKey: TransactionCacher.userDefaultsKey)
        }
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        return true
    }
    
    func connectToFcm() {
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        //Disconnect previous FCM Connections if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to conect with FCM. \(error?.localizedDescription ?? "" )")
            } else {
                print("Connected to FCM")
            }
        }
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        connectToFcm()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFcm()
        
        application.applicationIconBadgeNumber = 0;
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
        
    }
    
}

extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
    }
}


// MARK :- Login Integration Code.

extension AppDelegate {
    
    enum LaunchViewController {
        case Login, ClientViewMenuVC
        
        var viewController: UIViewController {
            switch self {
            case .Login: return StoryboardScene.Login.initialViewController()
            case .ClientViewMenuVC: return StoryboardScene.Main.initialViewController()
            }
        }
        
        /// Sets `UIWindow().rootViewController` to the appropriate view controller, by default this runs without an animation.
        func setAsRootviewController(animated: Bool = false) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let window = appDelegate.window!
            let launchViewController = viewController
            
            print("Setting \(type(of: launchViewController)) as rootViewController")
            if let rootViewController = window.rootViewController, type(of: rootViewController) != type(of: launchViewController) && animated {
                let overlayView = UIScreen.main.snapshotView(afterScreenUpdates: false)
                launchViewController.view.addSubview(overlayView)
                
                UIView.animate(withDuration: 0.3, animations: {
                    overlayView.alpha = 0.0
                },
                               completion: { _ in
                                overlayView.removeFromSuperview()
                });
            }
            
            window.rootViewController = launchViewController
            window.restorationIdentifier = String(describing: type(of: launchViewController))
            
            if window.isKeyWindow == false {
                window.makeKeyAndVisible()
            }
        }
    }
}

protocol StoryboardSceneType {
    static var storyboardName: String { get }
}

extension StoryboardSceneType {
    static func storyboard() -> UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: nil)
    }
    
    static func initialViewController() -> UIViewController {
        guard let vc = storyboard().instantiateInitialViewController() else {
            fatalError("Failed to instantiate initialViewController for \(self.storyboardName)")
        }
        return vc
    }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
    func viewController() -> UIViewController {
        return Self.storyboard().instantiateViewController(withIdentifier: self.rawValue)
    }
    static func viewController(identifier: Self) -> UIViewController {
        return identifier.viewController()
    }
}

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
    func perform<S: StoryboardSegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
        performSegue(withIdentifier: segue.rawValue, sender: sender)
    }
}

enum StoryboardScene {
    enum LaunchScreen: StoryboardSceneType {
        static let storyboardName = "LaunchScreen"
    }
    enum Main: String, StoryboardSceneType {
        static let storyboardName = "Main"
        
        case ClientViewMenuVC = "ClientViewMenuVC"
        static func clientViewMenuVCViewController() -> Client_ViewMenuVC {
            return Main.ClientViewMenuVC.viewController() as! Client_ViewMenuVC
        }
    }
    enum Login: String, StoryboardSceneType {
        static let storyboardName = "Login"
        
        case LoginVC = "LoginVC"
        static func loginViewController() -> LoginViewController {
            return Login.LoginVC.viewController() as! LoginViewController
        }
    }
}

