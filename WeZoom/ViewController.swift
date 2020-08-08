//
//  ViewController.swift
//  WeZoom
//
//  Created by Adila on 7/13/20.
//  Copyright © 2020 Adila Abudureheman. All rights reserved.
//

import UIKit
import MobileRTC

//LOCK MEETING
//ENTER WITHOUT REQUESTING PERMISSION
//PRESET SETTINGS BEFORE ACTUALLY START A MEETING

class ViewController: UIViewController, MobileRTCPremeetingDelegate, MobileRTCMeetingServiceDelegate {
    
    
    
    
    let kSDKUserName = "Adila"
    let ApiKey = "DR2LJG3CQlyWYeyfF3wieg"
    let ApiToken = "kdYpYCniYbZ3V109agp40jDkQyekvVgyR0fo"
    var isUserAuthenticated = false
    var smd : UInt64 = 0
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
            guard let meetingNumber = alert.textFields?[0].text, let meetingPassword = alert.textFields?[1].text else { return }
            
            let getservice = MobileRTC.shared().getMeetingService()
            if let service = getservice {
                print("Getting started on Joining a Meeting ... ")
                service.delegate = self
                let paramDict =      [kMeetingParam_Username:self.kSDKUserName,
                                      kMeetingParam_MeetingNumber:" 95452918130",
                                      kMeetingParam_MeetingPassword:"393133"]
                // service.disableShowVideoPreviewWhenJoinMeeting()
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
        //Meeting setting where changes the meeting topics before hands
        
        
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
        
        guard let zoomEmail = alert.textFields?[0].text, let zoomPwd = alert.textFields?[1].text else { return }
        
        login(email: zoomEmail, password: zoomPwd)
        
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "Password for Zoom Meeting (optional)"
            textField.isSecureTextEntry = true
        })
        //
        
        if let preMeetingService = MobileRTC.shared().getPreMeetingService(), let meetingItem = preMeetingService.createMeetingItem()
        {
//            print(preMeetingService.listMeeting().description)
            print("INSDE pre meeting process")
            preMeetingService.delegate = self
            meetingItem.setMeetingTopic("Meeting with Hamid about iOS Dev")
            //            meetingItem.setStartTime(date)
            //            meetingItem.setDurationInMinutes(duration)
            //            meetingItem.setTimeZoneID(timezoneID)
            //            meetingItem.setMeetingRepeat(meetingRepeat)
            //            meetingItem.setUsePMIAsMeetingID(usePMI)
            //            meetingItem.turnOffVideo(forHost: hostVideoOff)
            //            meetingItem.turnOffVideo(forAttendee: attendeeVideoOff)
            //            meetingItem.setAudioOption(audioOption)
            //            if let password = password{
            //                meetingItem.setMeetingPassword(pwd)
            //            }
            preMeetingService.scheduleMeeting(meetingItem, withScheduleFor: nil)
            self.smd = meetingItem.getMeetingNumber()
        } else {
            print("failed unwrapping")
        }
        
        let start = UIAlertAction(title: "Start", style: .default, handler: {
            (action) in
            // guard let meetingPassword = alert.textFields?[0].text else { return }
            var paramDict: [String : Any] = [kMeetingParam_Username : self.kSDKUserName]
            // Start Zoom meeting.

            // paramDict[kMeetingParam_MeetingNumber] = meetingItem.getMeetingNumber()

            paramDict[kMeetingParam_MeetingPassword] = ""

            // let meetingInfo = MobileRTCInviteHelper()
            if let meetingService = MobileRTC.shared().getMeetingService() {
                let user = MobileRTCMeetingStartParam4LoginlUser()
                //MobileRTC.shared()?.getMeetingSettings()?.meetingInviteHidden = true
                let param:MobileRTCMeetingStartParam = user

                param.meetingNumber = String(self.smd)

                meetingService.delegate = self
                //            param.noVideo = !video
                // param.meetingNumber = ""
                meetingService.customizeMeetingTitle("Calculus Midterm Review")

                let ret: MobileRTCMeetError = meetingService.startMeeting(with: param)

                print(ret)
            }

        })
        
        
        //Instant Start without scheduling or anything
        //        let start = UIAlertAction(title: "Start", style: .default, handler: {
        //            (action) in
        //            // guard let meetingPassword = alert.textFields?[0].text else { return }
        //            var paramDict: [String : Any] = [kMeetingParam_Username : self.kSDKUserName]
        //            // Start Zoom meeting.
        //
        //            // paramDict[kMeetingParam_MeetingNumber] = meetingItem.getMeetingNumber()
        //
        //            paramDict[kMeetingParam_MeetingPassword] = ""
        //
        //            let getservice = MobileRTC.shared().getMeetingService()
        //            //            let meetingInfo = MobileRTCInviteHelper()
        //            if let service = getservice {
        //                print("Getting started on Starting a Meeting ... ")
        //                service.delegate = self
        //                var paramDict: [String : Any] = [kMeetingParam_Username : self.kSDKUserName]
        //
        //                // Start Zoom meeting
        //
        //                let response = service.startMeeting(with: paramDict)
        //                print("onStartMeeting, response: \(response)")
        //            }
        //        })
        
        
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
    
    func onMeetingError(_ error: MobileRTCMeetError, message: String!) {
        //        UIApplication.stopActivityIndicator()
        print(error.rawValue)
    }
    
    func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        print("Meeting State: \(state)")
        if state.rawValue == 2{
            //if the meeting successfully starts, we will print out the info
            let meetingInfo = MobileRTCInviteHelper()
            print("JOINING URL: \(meetingInfo.joinMeetingURL)")
            print("MEETING NUMBER: \(meetingInfo.ongoingMeetingNumber)")
            print("MEETING TOPIC: \(meetingInfo.ongoingMeetingTopic)")
            print("MEETING RAW PASSWORD: \(meetingInfo.rawMeetingPassword)")
            let num = Int(meetingInfo.ongoingMeetingNumber)
            
            
        }
        
    }
    func sinkSchedultMeeting(_ result: PreMeetingError, meetingUniquedID uniquedID: UInt64) {
        //        print(PreMeetingError.RawValue())
        //        return
    }
    
    func sinkEditMeeting(_ result: PreMeetingError, meetingUniquedID uniquedID: UInt64) {
        //        print(PreMeetingError.RawValue())
        //        return
    }
    
    func sinkDeleteMeeting(_ result: PreMeetingError) {
        //        print(PreMeetingError.RawValue())
        //        return
    }
    
    func sinkListMeeting(_ result: PreMeetingError, withMeetingItems array: [Any]) {
        //        print(PreMeetingError.RawValue())
        //        return
    }
}



