//
//  AppDelegate.swift
//  Cleaning & Servent
//
//  Created by Jawad ali on 3/13/18.
//  Copyright © 2018 Jaidee. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
var baseVC : BaseViewController?
import GoogleSignIn
import FBSDKCoreKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var viewMove = 0
    var isRefreshAfterCancel = false
    
    var sliderArray = [[String : Any]]()
//    var sliderArray = [[String : Any]]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         UIApplication.shared.statusBarStyle = .lightContent
        IQKeyboardManager.shared.enable = true
         IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done".localized
//        GMSPlacesClient.provideAPIKey("AIzaSyB94MKwU5wRvADF2o9xioRSLp8Te1zUEDc") //("AIzaSyDRU2U1DgbSoN8si1OtMK06UKsHnt8095w") //("AIzaSyAmds1LXPL4C4RphubPGWoQA79gP_4mb3U") //
//        GMSServices.provideAPIKey("AIzaSyBCFIeDFmaE7Sj2huWQc-LVMToqBRBZhlA")//("AIzaSyDRU2U1DgbSoN8si1OtMK06UKsHnt8095w") //("AIzaSyAmds1LXPL4C4RphubPGWoQA79gP_4mb3U") //
        //AIzaSyAmds1LXPL4C4RphubPGWoQA79gP_4mb3U
        
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentSandbox: "AWn798PILYMSTPqZ7_2J7MW4ojqf01Cjno0OUDuxeszXak5N-HP5Y7ai7eHuL4_4VG7GKzyCWgKEStC8"])
        GMSPlacesClient.provideAPIKey("AIzaSyBocVxHuoxkWYk9K8426U3jBywYQ6ESuAI")//("AIzaSyCaF2LSRHDzC-NdWZg_c1cQIbmWjiEX2Kw")
        
        //owner of integrated account -> sir manzor
        //editor role: nvd, key generated by nvd   IOS restricted key
        GMSServices.provideAPIKey("AIzaSyBocVxHuoxkWYk9K8426U3jBywYQ6ESuAI")//("AIzaSyCvaIuO82At02qo4KT6M3k1ljs6y4zxj_Y")
        
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.value(forKey: "L") != nil)
        {
            if (userDefaults.value(forKey: "L") as! String) == "1" {
                Language.language = Language.arabic
               
            }
        }else {
            userDefaults.set("0", forKey: "L")
            userDefaults.synchronize()
           
        }
        FirebaseApp.configure()
        let manager = PushNotificationManager()
        manager.registerForPushNotifications()
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            }
            
        }
        
//        print("self.symbol")
//        print(self.symbol)
//        print(Locale.current.regionCode)
        
        
//        let currentLocale = Locale.current
//        let countryCode = currentLocale.objectForKey(NSLocaleCountryCode) as! String//get the set country name, code of your iphone
//        print("country code is \(Locale.current)")
        
        
        
        
        GIDSignIn.sharedInstance().clientID = "65486751357-73sue475cgs65upnnltc5lfhs63qqlef.apps.googleusercontent.com"
 //65486751357-73sue475cgs65upnnltc5lfhs63qqlef.apps.googleusercontent.com
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        //        let deviceTokenString = deviceToken.hexString
        print("Device Token:\(deviceTokenString)")
    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

//        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])

        let handler = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
        
        GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        return handler
    }
    
//    public var symbol: String {
//        return (Locale.current as NSLocale).displayName(forKey: .currencySymbol, value: "US") ?? ""
//    }
    
    
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
    }


}
