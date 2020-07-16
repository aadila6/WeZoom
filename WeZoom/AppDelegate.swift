//
//  AppDelegate.swift
//  WeZoom
//
//  Created by Adila on 7/13/20.
//  Copyright © 2020 Adila Abudureheman. All rights reserved.

import UIKit
import MobileRTC
import MobileCoreServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MobileRTCAuthDelegate {
    var window: UIWindow?
    var isAPIAuthenticated = false
  
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
        print("Zoom (SDK): Authentication task completed.")
        isAPIAuthenticated = true
        if (returnValue != MobileRTCAuthError_Success)
        {
            let msg = "SDK authentication failed, error code: \(returnValue)"
            print(msg)
        }
//        login(email: "aabudureheman@gmail.com", password: "Adila1628")
    }
    
//    // Authenticate user as a Zoom member.
//    func login(email: String, password: String) {
//      guard isAPIAuthenticated, let authService = MobileRTC.shared().getAuthService() else { return }
//        authService.login(withEmail: email, password: password, rememberMe: true)
//    }
//
//    // Handled by MobileRTCPremeetingDelegate, returns result of login function call.
//    func onMobileRTCLoginReturn(_ returnValue: Int) {
//      guard returnValue == 0 else {
//        print("Zoom (User): Login task failed, error code: \(returnValue)")
//        return
//      }
//      isUserAuthenticated = true
////      guard let preMeetingService = MobileRTC.shared().getPreMeetingService() else { return }
////      preMeetingService.delegate = self
//      print("Zoom (User): Login task completed.")
//    }
//    // Handled by MobileRTCPremeetingDelegate, returns result of logout function call.
//    func onMobileRTCLogoutReturn(_ returnValue: Int) {
//      guard returnValue == 0 else {
//        print("Zoom (User): Logout task failed, error code: \(returnValue)")
//        return
//      }
//      isUserAuthenticated = false
//      print("Zoom (User): Logout task completed.")
//    }
}
