//
//  AS_CENTER.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/07/17.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

// 문의사항
class AS_CENTER: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var Navi_Title: UILabel!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var TITLE_VIEW_BG: UIView!
    @IBOutlet weak var TITLE_VIEW: UIView!
    
    @IBOutlet weak var PHONE_NUM: UITextField!          // 휴대폰번호
    @IBOutlet weak var CONTENT: UITextView!             // 요청내용
    @IBOutlet weak var AGREE_VIEW: UIView!              // 개인정보동의
    @IBOutlet weak var AGREE_IMAGE: UIImageView!        //
    @IBOutlet weak var AGREE_CHECK: UIButton!           //
    @IBOutlet weak var FEEDBACK_SEND: UIButton!         //
    
    override func loadView() {
        super.loadView()
        
        CHECK_VERSION(Navi_Title)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navi_Title.alpha = 0.0
        ScrollView.delegate = self
        
//        if !DEVICE_RATIO() {
//            Navi_Title.alpha = 1.0
//            TITLE_VIEW.frame.size.height = 0.0
//            TITLE_VIEW.clipsToBounds = true
//        } else {
//            Navi_Title.alpha = 0.0
//            TITLE_VIEW.frame.size.height = 52.0
//            TITLE_VIEW.clipsToBounds = false
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 휴대폰번호
        PHONE_NUM.text = UIViewController.USER_DATA.string(forKey: "mb_id") ?? ""
        PHONE_NUM.layer.cornerRadius = 10.0
        PHONE_NUM.clipsToBounds = true
        TOOL_BAR_DONE(TEXT_FILELD: PHONE_NUM)
        PLACEHOLDER(TEXT_FILELD: PHONE_NUM, PLACEHOLDER: "전화번호를 입력해주세요")
        PHONE_NUM.PADDING_LEFT(X: 10.0)
        // 요청내용
        CONTENT.layer.cornerRadius = 10.0
        CONTENT.clipsToBounds = true
        TOOL_BAR_DONE(TEXT_VIEW: CONTENT)
        // 개인정보동의
        AGREE_VIEW.layer.cornerRadius = 10.0
        AGREE_VIEW.clipsToBounds = true
        
        FEEDBACK_SEND.layer.cornerRadius = 10.0
        FEEDBACK_SEND.clipsToBounds = true
    }
    
    // 개인정보동의
    @IBAction func AGREE_CHECK(_ sender: UIButton) {
        
        if sender.isSelected == false {
            sender.isSelected = true
            AGREE_IMAGE.image = UIImage(named: "check_on.png")
        } else {
            sender.isSelected = false
            AGREE_IMAGE.image = UIImage(named: "check_off.png")
        }
    }
    
    // 등록하기
    @IBAction func FEEDBACK_SEND(_ sender: UIButton) {
        
        if PHONE_NUM.text == "" || CONTENT.text == "" {
            NOTIFICATION_VIEW("미입력된 항목이 있습니다")
        } else if AGREE_CHECK.isSelected == false {
            NOTIFICATION_VIEW("미동의 항목이 있습니다")
        } else {
            if !SYSTEM_NETWORK_CHECKING() {
                NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
            } else {
                HTTP_FEEDBACK()
            }
        }
    }
    
    func HTTP_FEEDBACK() {
        
        let PARAMETERS: Parameters = [
            "mb_id": PHONE_NUM.text!,
            "content": CONTENT.text!,
            "action_type": "insert",
            "mb_platform": "ios"
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in

            for (key, value) in PARAMETERS {
                
                print("key: \(key)", "value: \(value)")
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, to: DATA_URL().SCHOOL_URL + "message/usr_ask.php") { (result) in
            
            switch result {
            case .success(let upload, _, _):
            
            upload.responseJSON { response in

                print("[피드백] ", response)
                
//                guard let INSERT_DICT = response.result.value as? [String: Any] else {
//
//                    print("[피드백] FAIL")
//                    return
//                }
//
//                if INSERT_DICT["result"] as? String ?? "fail" == "success" {
//
//
//                }
                
                let DATE_FORMATTER = DateFormatter()
                DATE_FORMATTER.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let ALERT = UIAlertController(title: "소중한 의견 감사합니다", message: DATE_FORMATTER.string(from: Date()), preferredStyle: .alert)
                
                ALERT.addAction(UIAlertAction(title: "확인", style: .default) { (_) in
                    
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "HOME") as! HOME
                    VC.modalTransitionStyle = .crossDissolve
                    self.present(VC, animated: true, completion: nil)
                })
                
                self.present(ALERT, animated: true)
            }
            case .failure(let encodingError):
                
                print(encodingError)
                break
            }
        }
    }
}

extension AS_CENTER: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        if DEVICE_RATIO() {
            if ScrollView.contentOffset.y <= 0 {
                Navi_Title.alpha = 0.0
            } else if ScrollView.contentOffset.y <= 34 {
                Navi_Title.alpha = 0.0
            } else if ScrollView.contentOffset.y <= 38 {
                Navi_Title.alpha = 0.2
            } else if ScrollView.contentOffset.y <= 42 {
                Navi_Title.alpha = 0.4
            } else if ScrollView.contentOffset.y <= 46 {
                Navi_Title.alpha = 0.6
            } else if ScrollView.contentOffset.y <= 50 {
                Navi_Title.alpha = 0.8
            } else {
                Navi_Title.alpha = 1.0
            }
//        }
    }
}
