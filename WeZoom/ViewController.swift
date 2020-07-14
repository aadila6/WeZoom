//
//  ViewController.swift
//  WeZoom
//
//  Created by Adila on 7/13/20.
//  Copyright © 2020 Adila Abudureheman. All rights reserved.
//

import UIKit
import MobileRTC
import MobileCoreServices

var rtc_userid = "";
var rtc_username = "Adila";
var rtc_meeting = "99522301577";


class ViewController: UIViewController, MobileRTCMeetingServiceDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func StartMeeting(_ sender: UIButton) {
        print("Start Meeting initialization...")
        let service = MobileRTC.shared().getMeetingService();
        if (service == nil){
            return;
        }
        
        service?.delegate = self;
        
        let dic = [kMeetingParam_UserID: rtc_userid,
                   //kMeetingParam_UserToken: rtc_token,
                   kMeetingParam_UserType: "99",
                   kMeetingParam_Username: rtc_username,
                   kMeetingParam_MeetingNumber: rtc_meeting,
                   ];
        
        let ret = service?.startMeeting(with: dic);
        print("start meeting ret: \(ret)");
    }
    
    @IBAction func JoinMetting(_ sender: UIButton) {
        print("Join Meeting initialization...")
        let service = MobileRTC.shared().getMeetingService();
        if (service == nil){
            return;
        }
        
        service?.delegate = self;
        
        let dic = [kMeetingParam_Username: rtc_username,
                   kMeetingParam_MeetingNumber: rtc_meeting,
                   ];
        
        let ret = service?.joinMeeting(with: dic);
        print("join meeting ret: \(ret)");
    }
    
}

