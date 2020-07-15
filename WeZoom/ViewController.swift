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
    let meetingNo = "922 0717 5505"
    let meetingPwd = "978713"
    let kSDKUserName = "Adila"
    let webTK = "L1dyNXNGWFp1VGVDVitWVnVsbmlZZz09"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 25/255, green: 25/255, blue: 25/255, alpha : 1)
//        print("1111111111111111")
        if(self.meetingNo == "") {
            // If the meeting number is empty, return error.
            print("Please enter a meeting number")
            return
        } else {
            print("2----------------")
            // If the meeting number is not empty.
            let getservice = MobileRTC.shared().getMeetingService()
//            print(getservice!)
            if let service = getservice {
                print("22222222222222")
                service.delegate = self
                let paramDict =      [kMeetingParam_Username:kSDKUserName,
                                      kMeetingParam_MeetingNumber:meetingNo,
                                      kMeetingParam_MeetingPassword:meetingPwd,
//                                      kMeetingParam_WebinarToken:webTK
                ]
                let response = service.joinMeeting(with: paramDict)
                print("onJoinMeeting, response: \(response)")
            }
//            print("33333333333333333")
        }
    }
}
extension ViewController: MobileRTCMeetingServiceDelegate{
    func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        print("Meeting State: \(state)")
    }
}

