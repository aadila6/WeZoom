//
//  ViewController.swift
//  WeZoom
//
//  Created by Adila on 7/13/20.
//  Copyright © 2020 Adila Abudureheman. All rights reserved.
//

import UIKit
import MobileRTC


class ViewController: UIViewController {
    let meetingNo = "919 4866 9521"
    let meetingPwd = "759993"
    let kSDKUserName = "Adila"
    let ApiKey = "DR2LJG3CQlyWYeyfF3wieg"
    let ApiToken = "kdYpYCniYbZ3V109agp40jDkQyekvVgyR0fo"
    var isUserAuthenticated = false
      
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 45/255, green: 45/255, blue: 45/255, alpha : 1)
        let joinButton = UIButton()
        joinButton.backgroundColor = .black
        joinButton.setTitle("Join Meeting", for: .normal)
        joinButton.addTarget(self, action: #selector(join), for: .touchUpInside)
        joinButton.layer.cornerRadius = 5
        
        let startButton = UIButton()
        startButton.backgroundColor = .black
        startButton.setTitle("Start Meeting", for: .normal)
        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        startButton.layer.cornerRadius = 5
        
        joinButton.frame = CGRect(x: view.center.x - 75, y: view.center.y - 25 + 60, width: 150, height: 50)
        startButton.frame = CGRect(x: view.center.x - 75, y: view.center.y - 25 - 60, width: 150, height: 50)
        view.addSubview(joinButton)
        view.addSubview(startButton)
    }
    
    
//    @objc func joinMeeting(){
//
//        if(self.meetingNo == "") {
//            // If the meeting number is empty, return error.
//            print("Please enter a meeting number")
//            return
//        } else {
//            // If the meeting number is not empty.
//            let getservice = MobileRTC.shared().getMeetingService()
//            //            print(getservice!)
//            if let service = getservice {
//                service.delegate = self
//                let paramDict =      [kMeetingParam_Username:kSDKUserName,
//                                      kMeetingParam_MeetingNumber:meetingNo,
//                                      kMeetingParam_MeetingPassword:meetingPwd,
//                                      kMeetingParam_WebinarToken:"dTlmVm40NGZ0U0RrRGFmU295aWxldz09"
//                ]
//                let response = service.joinMeeting(with: paramDict)
//                print("onJoinMeeting, response: \(response)")
//            }
//        }
//    }
    
    @objc func join() {
        let alert = UIAlertController(title: "Meeting Credentials", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Meeting Number"
        })
        
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        })
        
        let okay = UIAlertAction(title: "Join", style: .default, handler: {
            (action) in
            guard let meetingNumberText = alert.textFields?[0].text, let meetingNumber = alert.textFields?[0].text, let meetingPassword = alert.textFields?[1].text else { return }
            
            let getservice = MobileRTC.shared().getMeetingService()
            //            print(getservice!)
            if let service = getservice {
                print("Getting started on Joining a Meeting ... ")
                service.delegate = self
                let paramDict =      [kMeetingParam_Username:self.kSDKUserName,
                                      kMeetingParam_MeetingNumber:meetingNumber,
                                      kMeetingParam_MeetingPassword:meetingPassword,
                                      kMeetingParam_WebinarToken:"dTlmVm40NGZ0U0RrRGFmU295aWxldz09"
                ]
                // Join Zoom meeting.
                let response = service.joinMeeting(with: paramDict)
                print("onJoinMeeting, response: \(response)")
            }
        })
        
        alert.addAction(okay)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func start() {
        let alert = UIAlertController(title: "Zoom Sign In?", message: "Please sign in to Zoom Account ", preferredStyle: .alert)
        
       alert.addTextField(configurationHandler: {
            (textField) in
//            textField.keyboardType = .numberPad
            textField.placeholder = "Email"
        })
        
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        })
//        var zoomEmail = ""
//        let zoomPwd = ""
        
        guard let zoomEmail = alert.textFields?[0].text, let zoomPwd = alert.textFields?[1].text else { return }

        login(email: zoomEmail, password: zoomPwd)
        
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "Password for Zoom Meeting (optional)"
            textField.isSecureTextEntry = true
        })
        
        let start = UIAlertAction(title: "Start", style: .default, handler: {
            (action) in
//            guard let meetingPassword = alert.textFields?[0].text else { return }
            var paramDict: [String : Any] = [kMeetingParam_Username : self.kSDKUserName]
            // Start Zoom meeting.

            paramDict[kMeetingParam_MeetingPassword] = "111"
            
            let getservice = MobileRTC.shared().getMeetingService()
            
            if let service = getservice {
                print("Getting started on Starting a Meeting ... ")
                service.delegate = self
                var paramDict: [String : Any] = [kMeetingParam_Username : self.kSDKUserName]
                paramDict[kMeetingParam_MeetingPassword] = "111"
                // Start Zoom meeting

                let response = service.startMeeting(with: paramDict)
                print("onStartMeeting, response: \(response)")
            }
        })
        
        alert.addAction(start)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
        // Authenticate user as a Zoom member.
        func login(email: String, password: String) {
          guard let authService = MobileRTC.shared().getAuthService() else { return }
            authService.login(withEmail: email, password: password, rememberMe: true)
        }
        
        // Handled by MobileRTCPremeetingDelegate, returns result of login function call.
        func onMobileRTCLoginReturn(_ returnValue: Int) {
          guard returnValue == 0 else {
            print("Zoom (User): Login task failed, error code: \(returnValue)")
            return
          }
          isUserAuthenticated = true
    //      guard let preMeetingService = MobileRTC.shared().getPreMeetingService() else { return }
    //      preMeetingService.delegate = self
          print("Zoom (User): Login task completed.")
        }
        // Handled by MobileRTCPremeetingDelegate, returns result of logout function call.
        func onMobileRTCLogoutReturn(_ returnValue: Int) {
          guard returnValue == 0 else {
            print("Zoom (User): Logout task failed, error code: \(returnValue)")
            return
          }
          isUserAuthenticated = false
          print("Zoom (User): Logout task completed.")
        }

}

extension ViewController: MobileRTCMeetingServiceDelegate{
    func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        print("Meeting State: \(state)")
    }
}

