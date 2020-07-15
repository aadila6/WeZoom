//
//  AppDelegate.swift
//  WeZoom
//
//  Created by Adila on 7/13/20.
//  Copyright © 2020 Adila Abudureheman. All rights reserved.
//
//
//import UIKit
//import MobileRTC
//import MobileCoreServices
//
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate, MobileRTCAuthDelegate {
//    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
//         print("on MobileRTCAuthReturn....  \(returnValue)");
//    }
//
//    var rtc_appkey      = "lT5nWyalm4Y18Flhbyn73K0xh6c2muHgTpa2";
//    var rtc_appsecret   = "KSHEeauw3yjH7QFNZaa0iEtpQAY17udxeeqs";
//    var rtc_domain      = "zoom.us";
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        sdkAuth();
//        return true
//    }
//
//    // MARK: UISceneSession Lifecycle
//
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//
//    func sdkAuth(){
////        MobileRTC.shared().setMobileRTCDomain(rtc_domain);
//
//        let service = MobileRTC.shared().getAuthService();
//        if (service != nil) {
//            service?.delegate = self;
//
//            service?.clientKey = rtc_appkey;
//            service?.clientSecret = rtc_appsecret;
//
//            service?.sdkAuth();
//        }
//    }
//
//
//}

import UIKit
import MobileRTC
import MobileCoreServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MobileRTCAuthDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let navigationController = UINavigationController(rootViewController: newViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        RTCAuthInit()
        return true
    }
    
    func RTCAuthInit(){
        let mainSDK = MobileRTCSDKInitContext()
        mainSDK.domain = "zoom.us"
        MobileRTC.shared().initialize(mainSDK)
        let authService = MobileRTC.shared().getAuthService()
        print(MobileRTC.shared().mobileRTCVersion)
        authService?.delegate        = self
        authService?.clientKey       = "lT5nWyalm4Y18Flhbyn73K0xh6c2muHgTpa2"
        authService?.clientSecret    = "KSHEeauw3yjH7QFNZaa0iEtpQAY17udxeeqs"
        authService?.sdkAuth()
    }
    
    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        print("0 if SUCCESS: ",returnValue)
        if (returnValue != MobileRTCAuthError_Success)
        {
            let msg = "SDK authentication failed, error code: \(returnValue)"
            print(msg)
        }
    }
}
