//
//  EXTENSION.swift
//  DAMOA
//
//  Created by 장제현 on 2020/05/01.
//  Copyright © 2020 장제현. All rights reserved.
//
import UIKit
import Alamofire
import FirebaseMessaging
import Nuke
import AVKit
import AFNetworking
import CoreLocation
import UserNotifications
import LocalAuthentication
import SystemConfiguration

extension Array where Element: Hashable {
    var UNIQUES: Array {
        var BUFFER = Array()
        var ADDED = Set<Element>()
        for DATA in self { if !ADDED.contains(DATA) { BUFFER.append(DATA); ADDED.insert(DATA) } }
        return BUFFER
    }
}

extension UIViewController {
    
    // 네트워크 연결 확인
    func SYSTEM_NETWORK_CHECKING() -> Bool {
        
        var ZERO_ADDRESS = sockaddr_in()
        ZERO_ADDRESS.sin_len = UInt8(MemoryLayout.size(ofValue: ZERO_ADDRESS))
        ZERO_ADDRESS.sin_family = sa_family_t(AF_INET)
        
        let DEFAULT_ROUTE_REACHABILITY = withUnsafePointer(to: &ZERO_ADDRESS, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1, { zero_Sock_Address in
                SCNetworkReachabilityCreateWithAddress(nil, zero_Sock_Address)
            })
        })
        
        var FLAGS = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(DEFAULT_ROUTE_REACHABILITY!, &FLAGS) {
            return false
        }
        
        let IS_REACHABLE = FLAGS.contains(.reachable)
        let NEEDS_CONNECTION = FLAGS.contains(.connectionRequired)
        
        return (IS_REACHABLE && !NEEDS_CONNECTION)
    }
    
    // 알림창
    func NOTIFICATION_VIEW(_ MESSAGE: String) {
        
        let NOTIFICATION = UILabel(frame: CGRect(x: view.frame.size.width/2 - 97.5, y: 0.0, width: 195.0, height: 50.0))
            
        NOTIFICATION.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        NOTIFICATION.textColor = .lightGray
        NOTIFICATION.textAlignment = .center
        NOTIFICATION.font = UIFont.boldSystemFont(ofSize: 12)
        NOTIFICATION.text = MESSAGE
        NOTIFICATION.layer.cornerRadius = 25.0
        NOTIFICATION.clipsToBounds = true
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            
            NOTIFICATION.alpha = 1.0
            
            if !self.DEVICE_RATIO() {
                NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 20.0)
            } else {
                NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 44.0)
            }
        })
        
        view.addSubview(NOTIFICATION)
            
        UIView.animate(withDuration: 0.2, delay: 2.0, options: .curveEaseOut, animations: {
                
            NOTIFICATION.alpha = 0.0
            NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 0.0)
        }, completion: {(isCompleted) in
                
            NOTIFICATION.removeFromSuperview()
        })
    }
    
    func EFFECT_ALERT_VIEW(_ IMAGE: UIImage,_ TITLE: String, _ MESSAGE: String) {
        
        let VIEW = UIView()
        VIEW.frame = CGRect(x: view.frame.size.width / 2 - 80.0, y: view.frame.size.height / 2 - 80.0, width: 160.0, height: 160.0)
        VIEW.backgroundColor = .clear
        VIEW.layer.cornerRadius = 10.0
        VIEW.clipsToBounds = true
        
        let EFFECT_VIEW = UIVisualEffectView()
        EFFECT_VIEW.frame = VIEW.bounds
        EFFECT_VIEW.effect = UIBlurEffect(style: .extraLight)
        VIEW.addSubview(EFFECT_VIEW)
        
        let IMAGE_ = UIImageView()
        
        IMAGE_.frame = CGRect(x: VIEW.frame.size.width / 2 - 30.0, y: 20.0, width: 60.0, height: 60.0)
        IMAGE_.image = IMAGE
        IMAGE_.isOpaque = true
        IMAGE_.contentMode = .scaleAspectFit
        VIEW.addSubview(IMAGE_)
        
        let TITLE_ = UILabel()
            
        TITLE_.frame = CGRect(x: 0.0, y: 100.0, width: EFFECT_VIEW.frame.size.width, height: 20.0)
        TITLE_.textColor = .darkGray
        TITLE_.textAlignment = .center
        TITLE_.font = UIFont.boldSystemFont(ofSize: 14)
        TITLE_.text = TITLE
        VIEW.addSubview(TITLE_)
        
        let MESSAGE_ = UILabel()
            
        MESSAGE_.frame = CGRect(x: 0.0, y: 120.0, width: EFFECT_VIEW.frame.size.width, height: 20.0)
        MESSAGE_.textColor = .gray
        MESSAGE_.textAlignment = .center
        MESSAGE_.font = UIFont.systemFont(ofSize: 10)
        MESSAGE_.text = MESSAGE
        VIEW.addSubview(MESSAGE_)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            
            VIEW.alpha = 1.0
        })
        
        view.addSubview(VIEW)
        
        UIView.animate(withDuration: 0.5, delay: 2.0, options: .curveEaseOut, animations: {
                
            VIEW.alpha = 0.0
        }, completion: {(isCompleted) in
                
            VIEW.removeFromSuperview()
        })
    }
    
    func EFFECT_INDICATOR_VIEW(_ VIEW: UIView, _ IMAGE: UIImage,_ TITLE: String, _ MESSAGE: String) {
        
        VIEW.frame = CGRect(x: view.frame.size.width / 2 - 80.0, y: view.frame.size.height / 2 - 80.0, width: 160.0, height: 160.0)
        VIEW.backgroundColor = .GRAY_F1F1F1
        VIEW.layer.cornerRadius = 20.0
        VIEW.clipsToBounds = true
        
        let EFFECT_VIEW = UIVisualEffectView()
        EFFECT_VIEW.frame = VIEW.bounds
        EFFECT_VIEW.effect = UIBlurEffect(style: .extraLight)
        VIEW.addSubview(EFFECT_VIEW)
        
        let IMAGE_ = UIImageView()
        
        IMAGE_.frame = CGRect(x: VIEW.frame.size.width / 2 - 60.0, y: 20.0, width: 120.0, height: 60.0)
        IMAGE_.image = IMAGE
        IMAGE_.isOpaque = true
        IMAGE_.contentMode = .scaleAspectFill
        VIEW.addSubview(IMAGE_)
        
        let TITLE_ = UILabel()
            
        TITLE_.frame = CGRect(x: 0.0, y: 100.0, width: EFFECT_VIEW.frame.size.width, height: 20.0)
        TITLE_.textColor = .darkGray
        TITLE_.textAlignment = .center
        TITLE_.font = UIFont.boldSystemFont(ofSize: 14)
        TITLE_.text = TITLE
        VIEW.addSubview(TITLE_)
        
        let MESSAGE_ = UILabel()
            
        MESSAGE_.frame = CGRect(x: 0.0, y: 120.0, width: EFFECT_VIEW.frame.size.width, height: 20.0)
        MESSAGE_.textColor = .gray
        MESSAGE_.textAlignment = .center
        MESSAGE_.font = UIFont.systemFont(ofSize: 10)
        MESSAGE_.text = MESSAGE
        VIEW.addSubview(MESSAGE_)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            
            VIEW.alpha = 1.0
        })
        
        view.addSubview(VIEW)
    }
    
    func CLOSE_EFFECT_INDICATOR_VIEW(VIEW: UIView) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            VIEW.alpha = 0.0
        }, completion: {(isCompleted) in
            VIEW.removeFromSuperview()
        })
    }
    
    func EFFECT_UPDATE_NOTI(_ VIEW: UIView, _ NAVI_VIEW: UIView, _ TITLE: String, _ BODY: String, Y: CGFloat) {
        
        VIEW.frame = CGRect(x: 10.0, y: NAVI_VIEW.frame.origin.y + Y, width: view.frame.size.width - 20.0, height: 75.0)
        VIEW.backgroundColor = .clear
        VIEW.layer.cornerRadius = 15.0
        VIEW.clipsToBounds = true
        
        let EFFECT_VIEW = UIVisualEffectView()
        
        EFFECT_VIEW.frame = VIEW.bounds
        EFFECT_VIEW.effect = UIBlurEffect(style: .prominent)
        VIEW.addSubview(EFFECT_VIEW)
        
        let IMAGE_ = UIImageView()
        
        IMAGE_.frame = CGRect(x: 10.0, y: 10.0, width: 20.0, height: 20.0)
        IMAGE_.image = UIImage(named: "icon.png")
        IMAGE_.contentMode = .scaleAspectFill
        IMAGE_.layer.cornerRadius = 5.0
        IMAGE_.clipsToBounds = true
        IMAGE_.layer.borderWidth = 0.5
        IMAGE_.layer.borderColor = UIColor.white.cgColor
        IMAGE_.clipsToBounds = true
        VIEW.addSubview(IMAGE_)
        
        let APP_NAME_ = UILabel()
        
        APP_NAME_.frame = CGRect(x: IMAGE_.frame.size.width + 17.5, y: 10, width: EFFECT_VIEW.frame.size.width - IMAGE_.frame.size.width + 5.0 - 10, height: 20.0)
        APP_NAME_.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.regular)
        if #available(iOS 13.0, *) { APP_NAME_.textColor = .label } else { APP_NAME_.textColor = .black }
//        APP_NAME_.textColor = .black
        APP_NAME_.alpha = 0.3
        APP_NAME_.text = "부산교육 다모아"
        VIEW.addSubview(APP_NAME_)
        
        let TITLE_ = UILabel()
            
        TITLE_.frame = CGRect(x: 12.5, y: 35.0, width: EFFECT_VIEW.frame.size.width - 25.0, height: 15.0)
        if #available(iOS 13.0, *) { TITLE_.textColor = .label } else { TITLE_.textColor = .black }
        TITLE_.font = UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.regular)
        TITLE_.text = TITLE
        VIEW.addSubview(TITLE_)
        
        let BODY_ = UILabel()
            
        BODY_.frame = CGRect(x: 12.5, y: 50.0, width: EFFECT_VIEW.frame.size.width - 25.0, height: 15.0)
        if #available(iOS 13.0, *) { BODY_.textColor = .label } else { BODY_.textColor = .black }
        APP_NAME_.alpha = 0.7
        BODY_.font = UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.thin)
        BODY_.text = BODY
        VIEW.addSubview(BODY_)
        
        let UPDATE_ = UIButton()
        
        UPDATE_.frame = CGRect(x: EFFECT_VIEW.frame.size.width - 72.5, y: 35.0, width: 60.0, height: 30.0)
        UPDATE_.setTitle("업데이트", for: .normal)
        if #available(iOS 13.0, *) { UPDATE_.setTitleColor(.secondaryLabel, for: .normal) } else { UPDATE_.setTitleColor(.darkGray, for: .normal) }
        UPDATE_.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.medium)
        UPDATE_.titleLabel?.textAlignment = .center
        UPDATE_.layer.borderColor = UIColor.systemGray.cgColor
        UPDATE_.layer.borderWidth = 1.0
        UPDATE_.layer.cornerRadius = 5.0
        UPDATE_.clipsToBounds = true
        UPDATE_.addTarget(self, action: #selector(OPEN_UPDATE(_:)), for: .touchUpInside)
        VIEW.addSubview(UPDATE_)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            
            VIEW.alpha = 1.0
        })
        
        view.addSubview(VIEW)
    }
    
    @objc func OPEN_UPDATE(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/busan-damoa/id1378854278")!)
    }
    
    // 이미지 비동기화
    func NUKE_IMAGE(IMAGE_URL: String, PLACEHOLDER: UIImage, PROFILE: UIImageView, FRAME_SIZE: CGSize) {
        
        ImageCache.shared.removeAll()
        
        let REQUEST = ImageRequest(url: URL(string: IMAGE_URL)!, processors: [ImageProcessor.Resize(size: FRAME_SIZE)])
        let OPTIONS = ImageLoadingOptions(placeholder: PLACEHOLDER, contentModes: .init(success: .scaleAspectFit, failure: .scaleAspectFit, placeholder: .scaleAspectFit))
        Nuke.loadImage(with: REQUEST, options: OPTIONS, into: PROFILE)
    }
    
    func NUKE_DETAIL_IMAGE(IMAGE_URL: String, PLACEHOLDER: UIImage, PROFILE: UIImageView, FRAME_SIZE: CGSize) {
        
        ImageCache.shared.removeAll()
        
        let REQUEST = ImageRequest(url: URL(string: IMAGE_URL)!, processors: [ImageProcessor.Resize(size: FRAME_SIZE)])
        let OPTIONS = ImageLoadingOptions(placeholder: PLACEHOLDER, contentModes: .init(success: .scaleAspectFit, failure: .center, placeholder: .center))
        Nuke.loadImage(with: REQUEST, options: OPTIONS, into: PROFILE)
    }
    
    // 에시 표시
    func PLACEHOLDER(TEXT_FILELD: UITextField, PLACEHOLDER: String) {
        
        TEXT_FILELD.attributedPlaceholder = NSAttributedString(string: PLACEHOLDER, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    // 완료 버튼
    func TOOL_BAR_DONE(TEXT_FILELD: UITextField) {
        
        let TOOL_BAR = UIToolbar()
        TOOL_BAR.sizeToFit()
        
        let SPACE = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let DONE = UIBarButtonItem(title: "완료", style: .done, target: self, action:  #selector(DONE_CLICKED))
        if #available(iOS 13.0, *) { TOOL_BAR.tintColor = .label } else { TOOL_BAR.tintColor = .black }
        TOOL_BAR.setItems([SPACE, DONE], animated: false)
        
        TEXT_FILELD.inputAccessoryView = TOOL_BAR
    }
    
    func TOOL_BAR_DONE(TEXT_VIEW: UITextView) {
        
        let TOOL_BAR = UIToolbar()
        TOOL_BAR.sizeToFit()
        
        let SPACE = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let DONE = UIBarButtonItem(title: "완료", style: .done, target: self, action:  #selector(DONE_CLICKED))
        if #available(iOS 13.0, *) { TOOL_BAR.tintColor = .label } else { TOOL_BAR.tintColor = .black }
        TOOL_BAR.setItems([SPACE, DONE], animated: false)
        
        TEXT_VIEW.inputAccessoryView = TOOL_BAR
    }
    
    // 스크롤
    func SCROLL_EDIT(TABLE_VIEW: UITableView, NAVI_TITLE: UILabel) {
        
        if TABLE_VIEW.contentOffset.y <= 0.0 {
            NAVI_TITLE.alpha = 0.0
        } else if TABLE_VIEW.contentOffset.y <= 34.0 {
            NAVI_TITLE.alpha = 0.0
        } else if TABLE_VIEW.contentOffset.y <= 38.0 {
            NAVI_TITLE.alpha = 0.2
        } else if TABLE_VIEW.contentOffset.y <= 42.0 {
            NAVI_TITLE.alpha = 0.4
        } else if TABLE_VIEW.contentOffset.y <= 46.0 {
            NAVI_TITLE.alpha = 0.6
        } else if TABLE_VIEW.contentOffset.y <= 50.0 {
            NAVI_TITLE.alpha = 0.8
        } else {
            NAVI_TITLE.alpha = 1.0
        }
    }
    
    // 전화번호 형식 체크
    func PHONE_NUM_CHECK(PHONE_NUM: String) -> Bool {
        
        let REGEX = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: PHONE_NUM)
    }
    
    // 인증번호 형식 체크
    func SMS_NUM_CHECK(PHONE_NUM: String) -> Bool {
        
        let REGEX = "^([0-9]{6})$"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: PHONE_NUM)
    }

    
    
}

extension UITableViewCell {
    
    // 이미지 비동기화
    func NUKE_IMAGE(IMAGE_URL: String, PLACEHOLDER: UIImage, PROFILE: UIImageView, FRAME_SIZE: CGSize) {
        
        let REQUEST = ImageRequest(url: URL(string: IMAGE_URL)!, processors: [ImageProcessor.Resize(size: FRAME_SIZE)])
        
        if PLACEHOLDER == UIImage(named: "clear_bg_image.png") {
            let OPTIONS = ImageLoadingOptions(placeholder: PLACEHOLDER, contentModes: .init(success: .scaleAspectFill, failure: .center, placeholder: .scaleAspectFit))
            Nuke.loadImage(with: REQUEST, options: OPTIONS, into: PROFILE)
        } else {
            let OPTIONS = ImageLoadingOptions(placeholder: PLACEHOLDER, contentModes: .init(success: .scaleAspectFit, failure: .center, placeholder: .scaleAspectFit))
            Nuke.loadImage(with: REQUEST, options: OPTIONS, into: PROFILE)
        }
    }
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // 토큰을 문자열로 변환
        print("APNs device token: \(deviceToken)")
        // Print it to console
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.prod)
        
        // Persist it in your backend in case it's new
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate {
    
    func HTTP_PUSH_COUNT(BOARD_KEY: String, BOARD_TYPE: String, PUSH_TYPE: String) {
        
        let PARAMETERS: Parameters = [
            "mb_id": UIViewController.USER_DATA.string(forKey: "mb_id") ?? "",
            "board_key": BOARD_KEY,
            "board_type": BOARD_TYPE,
            "push_type": PUSH_TYPE,
            "mb_platform": "ios"    //UIDevice.current.systemName
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in

            for (key, value) in PARAMETERS {
                
                print("key: \(key)", "value: \(value)")
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, to: DATA_URL().SCHOOL_URL + "message/push_count.php") { (result) in
            
            result
            
            switch result {
            case .success(let upload, _, _):
            
            upload.responseJSON { response in

                print("[PUSH카운트] ", response)
                
                guard let COUNTDICT = response.result.value as? [String: Any] else {

                    print("[PUSH카운트] FAIL")
                    return
                }
                
                if COUNTDICT["result"] as? String ?? "fail" == "success" {
                    print("[PUSH카운트] SUCCESS")
                }
            }
            case .failure(let encodingError):
                
                print(encodingError)
                break
            }
        }
    }
}
