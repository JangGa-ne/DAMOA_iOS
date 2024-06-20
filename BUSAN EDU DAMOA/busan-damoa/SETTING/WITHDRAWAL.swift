//
//  WITHDRAWAL.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/06/16.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import FirebaseMessaging
import Alamofire

// 회원탈퇴
class WITHDRAWAL: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func WITHDRAWAL_BUTTON(_ sender: UIButton) {
        
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
        } else {
            HTTP_WITHDRAWAL()
        }
    }
    
    func HTTP_WITHDRAWAL() {
            
        let PARAMETERS: Parameters = [
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "action_type": "delete"
        ]
        
        print("PARAMETERS -", PARAMETERS)
                
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            for (KEY, VALUE) in PARAMETERS {

                print("key: \(KEY)", "value: \(VALUE)")
                multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
            }
        }, to: DATA_URL().SCHOOL_URL + "member/member.php") { (result) in
        
            switch result {
            case .success(let upload, _, _):
            
            upload.responseString { response in

                print("[회원탈퇴]", response)
                
                guard let WITHDRAWAL = response.result.value else {

                    print("[회원탈퇴] FAIL")
                    return
                }

                if WITHDRAWAL == "SUCCESS" {
                    
                    Messaging.messaging().unsubscribe(fromTopic: "p\(UIViewController.USER_DATA.string(forKey: "mb_id") ?? "")")
                    
                    // FIREBASE 구독취소
                    let PUSH_TYPE: [String] = ["n", "m", "c", "f", "t", "et", "sc", "s", "ns", "en", "cs", "sv"]
                    for TYPE in PUSH_TYPE { UserDefaults.standard.setValue(false, forKey: "switch_\(TYPE)"); UserDefaults.standard.synchronize() }
                    self.MAIN_PUSH_CONTROL_CENTER()      // 메인푸시
                    self.SCHOOL_PUSH_CONTROL_CENTER()    // 학교푸시
                    
                    let APPDELEGATE = UIViewController.APPDELEGATE
                    // 등록된 학교 삭제
                    APPDELEGATE.DELETE_ALL("ENROLL_LIST")
                    // 로그인 정보 삭제
                    APPDELEGATE.LOGIN_API.removeAll()
                    UserDefaults.standard.removeObject(forKey: "mb_id")
                    UserDefaults.standard.removeObject(forKey: "mb_type")
                    UserDefaults.standard.setValue(false, forKey: "enroll")
                    UserDefaults.standard.synchronize()
                    APPDELEGATE.LOGIN = false
                    // 소식 보관함 삭제
                    APPDELEGATE.DELETE_DB_MAIN(ALL: true, BOARD_KEY: "")
                    // PUSH 배지 재설정
                    APPDELEGATE.DELETE_PUSH_BADGE_DB()
                    APPDELEGATE.SAVE_PUSH_BADGE_DB()

                    UIView.animate(withDuration: 0.0, delay: 2.0, animations: {

                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SIGN_UP") as! SIGN_UP
                        VC.modalTransitionStyle = .crossDissolve
                        self.present(VC, animated: true, completion: nil)
                    })
                } else {

                    self.NOTIFICATION_VIEW("회원탈퇴 실패")
                }
            }
            case .failure(let encodingError):
        
                print(encodingError)
                break
            }
        }
    }
}
