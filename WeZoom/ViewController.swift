//
//  ViewController.swift
//  WeZoom
//
//  Created by Adila on 7/13/20.
//  Copyright © 2020 Adila Abudureheman. All rights reserved.
//

//import UIKit
//import MobileRTC
//import MobileCoreServices
//
//var rtc_userid = "";
//var rtc_username = "Adila";
//var rtc_meeting = "99522301577";
//
//
//class ViewController: UIViewController, MobileRTCMeetingServiceDelegate{
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//    @IBAction func StartMeeting(_ sender: UIButton) {
//        print("Start Meeting initialization...")
//        let service = MobileRTC.shared().getMeetingService();
//        if (service == nil){
//            return;
//        }
//        service?.delegate = self;
//
//        let dic = [kMeetingParam_UserID: rtc_userid,
//                   //kMeetingParam_UserToken: rtc_token,
//                   kMeetingParam_UserType: "99",
//                   kMeetingParam_Username: rtc_username,
//                   kMeetingParam_MeetingNumber: rtc_meeting,
//                   ];
//
//        let ret = service?.startMeeting(with: dic);
//        print("start meeting ret: \(ret)");
//    }
//
//    @IBAction func JoinMetting(_ sender: UIButton) {
//        print("Join Meeting initialization...")
//        let service = MobileRTC.shared().getMeetingService();
//        if (service == nil){
//            return;
//        }
//
//        service?.delegate = self;
//
//        let dic = [kMeetingParam_Username: rtc_username,
//                   kMeetingParam_MeetingNumber: rtc_meeting,
//                   ];
//
//        let ret = service?.joinMeeting(with: dic);
//        print("join meeting ret: \(ret)");
//    }
//
//}

import UIKit
import MobileRTC
class ViewController: UIViewController {
    let meetingNo = "919 4866 9521"
    let meetingPwd = "759993"
    let kSDKUserName = "Adila"
    let ApiKey = "DR2LJG3CQlyWYeyfF3wieg"
    let ApiToken = "kdYpYCniYbZ3V109agp40jDkQyekvVgyR0fo"
    let userID = "LeE4XRa8Zw" //fake
    let userToken = "mL4KVYD-8fI2TtnE1nFM5IeEMjNXT4xfgdFj62PmqNg.BgIsb0NFOURZNStNZGJuNXhXSGY5SWRyd" //fake
    let userType = "ZoomSDKUserType_ZoomUser"
    let displayName = "Demo"
    let meetingNumber = "12345"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 25/255, green: 25/255, blue: 25/255, alpha : 1)
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
    
    
    @objc func joinMeeting(){
        print("1111111111111111")
        if(self.meetingNo == "") {
            // If the meeting number is empty, return error.
            print("Please enter a meeting number")
            return
        } else {
            // If the meeting number is not empty.
            let getservice = MobileRTC.shared().getMeetingService()
            //            print(getservice!)
            if let service = getservice {
                print("22222222222222")
                service.delegate = self
                let paramDict =      [kMeetingParam_Username:kSDKUserName,
                                      kMeetingParam_MeetingNumber:meetingNo,
                                      kMeetingParam_MeetingPassword:meetingPwd,
                                      kMeetingParam_WebinarToken:"dTlmVm40NGZ0U0RrRGFmU295aWxldz09"
                ]
                let response = service.joinMeeting(with: paramDict)
                print("onJoinMeeting, response: \(response)")
            }
        }
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
            textField.placeholder = "No Password"
            textField.isSecureTextEntry = true
        })
        
        let okay = UIAlertAction(title: "Join", style: .default, handler: {
            (action) in
            guard let meetingNumberText = alert.textFields?[0].text, let meetingNumber = Int(meetingNumberText), let meetingPassword = alert.textFields?[1].text else { return }
            
            
            let getservice = MobileRTC.shared().getMeetingService()
            //            print(getservice!)
            if let service = getservice {
                print("22222222222222")
                service.delegate = self
                let paramDict =      [kMeetingParam_Username:self.kSDKUserName,
                                      kMeetingParam_MeetingNumber:self.meetingNo,
                                      kMeetingParam_MeetingPassword:self.meetingPwd,
                                      kMeetingParam_WebinarToken:"dTlmVm40NGZ0U0RrRGFmU295aWxldz09"
                ]
                // Join Zoom meeting.
                let response = service.joinMeeting(with: paramDict)
                print("onJoinMeeting, response: \(response)")
            }
            
            
            //        ZoomService.sharedInstance.joinMeeting(number: meetingNumber, password: meetingPassword)
        })
        
        alert.addAction(okay)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func start() {
        let alert = UIAlertController(title: "Add Password?", message: "Secure your next meeting with a password. Keep the creeps out!", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "No Password"
            textField.isSecureTextEntry = true
        })
        
        let start = UIAlertAction(title: "Start", style: .default, handler: {
            (action) in
            guard let meetingPassword = alert.textFields?[0].text else { return }
            var paramDict: [String : Any] = [kMeetingParam_Username : self.kSDKUserName]
            // Start Zoom meeting.
            paramDict[kMeetingParam_UserID] = self.userID
            //        paramDict[kMeetingParam_UserToken] = self.userToken
            
            
            let getservice = MobileRTC.shared().getMeetingService()
            //            print(getservice!)
            if let service = getservice {
                print("22222222222222")
                service.delegate = self
                let paramDict =      [kMeetingParam_Username:self.kSDKUserName]
//                                      kMeetingParam_MeetingNumber:self.meetingNo,
//                                      kMeetingParam_MeetingPassword:self.meetingPwd,
//                                      kMeetingParam_WebinarToken:"dTlmVm40NGZ0U0RrRGFmU295aWxldz09"
                //]
                // Join Zoom meeting.
                let response = service.startMeeting(with: paramDict)
                print("onJoinMeeting, response: \(response)")
            }
        })
        
        alert.addAction(start)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: MobileRTCMeetingServiceDelegate{
    func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        print("Meeting State: \(state)")
    }
}

