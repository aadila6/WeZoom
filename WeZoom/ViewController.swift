//
//  ViewController.swift
//  WeZoom
//
//  Created by Adila on 7/13/20.
//  Copyright © 2020 Adila Abudureheman. All rights reserved.
//

import UIKit
import MobileRTC
import AVFoundation

//LOCK MEETING
//ENTER WITHOUT REQUESTING PERMISSION
//PRESET SETTINGS BEFORE ACTUALLY START A MEETING

class ViewController: UIViewController, MobileRTCPremeetingDelegate, MobileRTCMeetingServiceDelegate {
    
    
    let kSDKUserName = "Adila"
    var isUserAuthenticated = false
    var meetingUniqueID : UInt64 = 0
    var meetingTopic : String = "Meeting with Hamid on iOS"
    
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
        
        // Create a meeting with custom meeting topic, and start immediately,
        // Please refer sinkSchedultMeeting function where startmeeting is called
        if let preMeetingService = MobileRTC.shared().getPreMeetingService(), let meetingItem = preMeetingService.createMeetingItem()
        {
            preMeetingService.delegate = self
            meetingItem.setMeetingTopic(self.meetingTopic)
            meetingItem.enableWaitingRoom(false)
//            meetingItem.bottomBarHidden = true
            preMeetingService.scheduleMeeting(meetingItem, withScheduleFor: nil)
        }
        
    }
    
    func bluetoothAudioConnected() -> Bool{
        print("Inside checking the bluetooth")
      let outputs = AVAudioSession.sharedInstance().currentRoute.outputs
      for output in outputs{
        if output.portType == AVAudioSession.Port.bluetoothA2DP || output.portType == AVAudioSession.Port.bluetoothHFP || output.portType == AVAudioSession.Port.bluetoothLE{
          return true
        }
      }
      return false
    }
    
    func startMeeting(meetingID : String){
        var paramDict: [String : Any] = [kMeetingParam_Username : self.kSDKUserName]
        // Start Zoom meeting.
        //        paramDict[kMeetingParam_MeetingPassword] = ""
        // let meetingInfo = MobileRTCInviteHelper()
        
        if let meetingService = MobileRTC.shared().getMeetingService() {
            if let meetingSetting = MobileRTC.shared().getMeetingSettings(){
                meetingSetting.bottomBarHidden = true
                if (bluetoothAudioConnected()){
                    print("AUDIO CONNECTED TO BLUETOOTH")
                     meetingSetting.setAutoConnectInternetAudio(true)
                }
//                meetingSetting.setFaceBeautyEnabled(true)
                        
            }
            let user = MobileRTCMeetingStartParam4LoginlUser()
            
            let param:MobileRTCMeetingStartParam = user
            
            param.meetingNumber = meetingID
            
            meetingService.delegate = self
            
            meetingService.customizeMeetingTitle("Calculus Midterm Review")

            
            let ret: MobileRTCMeetError = meetingService.startMeeting(with: param)
            
            print(ret)
        }
    }
    
    //Custom UI alert for User to type in their email and password and MeetingTopic
    func customLoginAlert() {
        //        let alert = UIAlertController(title: "Zoom Sign In?", message: "Please sign in to Zoom Account ", preferredStyle: .alert)
        //        //Meeting setting where changes the meeting topics before hands
        //
        //        alert.addTextField(configurationHandler: {
        //            (textField) in
        //            //            textField.keyboardType = .numberPad
        //            textField.placeholder = "Email"
        //        })
        //
        //        alert.addTextField(configurationHandler: {
        //            (textField) in
        //            textField.placeholder = "Password"
        //            textField.isSecureTextEntry = true
        //        })
        //
        //        guard let zoomEmail = alert.textFields?[0].text, let zoomPwd = alert.textFields?[1].text else { return }
        //
        //        alert.addTextField(configurationHandler: {
        //            (textField) in
        //            textField.placeholder = "Meeting Topic"
        //            textField.isSecureTextEntry = true
        //        })
        //
        //        alert.addAction(start)
        //
        //        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //
        //        alert.addAction(cancel)
        //
        //        present(alert, animated: true, completion: nil)
    }
    
    func sinkSchedultMeeting(_ result: PreMeetingError, meetingUniquedID uniquedID: UInt64) {
        print("Unique ID: \(uniquedID)")
        self.meetingUniqueID = uniquedID
        // actually start the meeting right away, if not want to start,
        // comment out the startMeeting function below and put it on its desired location
        startMeeting(meetingID: String(uniquedID))
    }
    
    func sinkEditMeeting(_ result: PreMeetingError, meetingUniquedID uniquedID: UInt64) {
        
    }
    
    func sinkDeleteMeeting(_ result: PreMeetingError) {
        
    }
    
    func sinkListMeeting(_ result: PreMeetingError, withMeetingItems array: [Any]) {
        
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
}

