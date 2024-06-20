//
//  SETTING_PREVIEW.swift
//  busan-damoa
//
//  Created by 장 제현 on 2021/03/10.
//  Copyright © 2021 장제현. All rights reserved.
//

import UIKit
import Alamofire

//MARK: 로그인 및 미리보기
extension UIViewController {
    
    func GET_LOGIN_POST_DATA(NAME: String, BOARD_TYPE: String) {
        
        // 데이터 삭제
        UIViewController.APPDELEGATE.LOGIN_API.removeAll()
        
        let POST_URL: String = DATA_URL().SCHOOL_URL + "member/member.php"
        let PARAMETERS: Parameters = [
            "uuid": UUID().uuidString,
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "gcm_id": UserDefaults.standard.string(forKey: "gcm_id") ?? "",
            "action_type": "login",
            "mb_platform": "ios"
        ]
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 15.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseJSON(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
            print(response)
            
            switch response.result {
            case .success(_):
                
                guard let DATA_ARRAY = response.result.value as? Array<Any> else {
                    print("FAILURE: ")
                    UIViewController.APPDELEGATE.LOGIN = false
                    self.VIEWCONTROLLER_VC(IDENTIFIER: "SIGN_UP")
                    return
                }
                
                for (_, DATA) in DATA_ARRAY.enumerated() {

                    let DATA_DICT = DATA as? [String: Any]
                    let APPEND_VALUE = LOGIN_DATA()

                    APPEND_VALUE.SET_APP_CHECKED(APP_CHECKED: DATA_DICT?["app_checked"] as Any)
                    APPEND_VALUE.SET_GCM_ID(GCM_ID: DATA_DICT?["gcm_id"] as Any)
                    APPEND_VALUE.SET_LAST_LOGIN(LAST_LOGIN: DATA_DICT?["last_login"] as Any)
                    APPEND_VALUE.SET_LOC_SHARE(LOC_SHARE: DATA_DICT?["loc_share"] as Any)
                    APPEND_VALUE.SET_MB_ID(MB_ID: DATA_DICT?["mb_id"] as Any)
                    APPEND_VALUE.SET_MB_IMG(MB_IMG: DATA_DICT?["mb_img"] as Any)
                    APPEND_VALUE.SET_MB_IP(MB_IP: DATA_DICT?["mb_ip"] as Any)
                    APPEND_VALUE.SET_MB_NAME(MB_NAME: DATA_DICT?["mb_name"] as Any)
                    APPEND_VALUE.SET_MB_PHONE(MB_PHONE: DATA_DICT?["mb_phone"] as Any)
                    APPEND_VALUE.SET_MB_PLATFORM(MB_PLATFORM: DATA_DICT?["mb_platform"] as Any)
                    APPEND_VALUE.SET_MB_TYPE(MB_TYPE: DATA_DICT?["mb_type"] as Any)
                    APPEND_VALUE.SET_REG_DATE(REG_DATE: DATA_DICT?["reg_date"] as Any)
                    APPEND_VALUE.SET_UUID(UUID: DATA_DICT?["uuid"] as Any)

                    let MB_TYPE = DATA_DICT?["mb_type"] as? String ?? ""
                    UserDefaults.standard.setValue(MB_TYPE, forKey: "mb_type")
                    UserDefaults.standard.synchronize()
                    // 데이터 추가
                    UIViewController.APPDELEGATE.LOGIN_API.append(APPEND_VALUE)
                }
                
                UIViewController.APPDELEGATE.LOGIN = true
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.NOTIFICATION_VIEW("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.NOTIFICATION_VIEW("E: 네트워크 연결 실패 (000)") }
                
                self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
            }
        })
    }
    
    func GET_PREVIEW_POST_DATA(NAME: String, BOARD_TYPE: String, NEW: Bool) {
        
        // 데이터 삭제
        UIViewController.APPDELEGATE.PREVIEW_LIST.removeAll()
        
        let POST_URL: String = DATA_URL().SCHOOL_URL + "message/school_sosik.php"
        var PARAMETERS: Parameters = [
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "limit_start": "0",
            "board_type": BOARD_TYPE
        ]
        
        var SC_CODE: [String] = ["CENTER"]
        for RECORD in UIViewController.APPDELEGATE.ENROLL_LIST { SC_CODE.append(RECORD.value(forKey: "sc_code") as? String ?? "") }
        for i in 0 ..< UNIQ(SOURCE: SC_CODE).count { if UNIQ(SOURCE: SC_CODE)[i] != "" { PARAMETERS["sc_code[\(i)]"] = UNIQ(SOURCE: SC_CODE)[i] } }
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 15.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseJSON(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
//            print(response)
            
            switch response.result {
            case .success(_):
                
                guard let DATA_ARRAY = response.result.value as? Array<Any> else {
                    print("FAILURE: ")
                    self.VIEWCONTROLLER_VC(IDENTIFIER: "HOME")
                    return
                }
                
                for i in 0 ..< DATA_ARRAY.count {
                    
                    if i < 3 {
                                        
                        let DATA_DICT = DATA_ARRAY[i] as? [String: Any]
                        let APPEND_VALUE = SOSIK_API()
                        
                        APPEND_VALUE.SET_ATTACHED(ATTACHED: self.SET_ATTACHED_DATA(ATTACHED_ARRAY: DATA_DICT?["attached"] as? [Any] ?? []))
                        APPEND_VALUE.SET_BOARD_CODE(BOARD_CODE: DATA_DICT?["board_code"] as Any)
                        APPEND_VALUE.SET_BOARD_ID(BOARD_ID: DATA_DICT?["board_id"] as Any)
                        APPEND_VALUE.SET_BOARD_KEY(BOARD_KEY: DATA_DICT?["board_key"] as Any)
                        APPEND_VALUE.SET_BOARD_NAME(BOARD_NAME: DATA_DICT?["board_name"] as Any)
                        APPEND_VALUE.SET_BOARD_SOURCE(BOARD_SOURCE: DATA_DICT?["board_source"] as Any)
                        APPEND_VALUE.SET_BOARD_TYPE(BOARD_TYPE: DATA_DICT?["board_type"] as Any)
                        APPEND_VALUE.SET_CALL_BACK(CALL_BACK: DATA_DICT?["callback"] as Any)
                        APPEND_VALUE.SET_CLASS_INFO(CLASS_INFO: DATA_DICT?["class_info"] as Any)
                        APPEND_VALUE.SET_CONTENT(CONTENT: DATA_DICT?["content"] as Any)
                        APPEND_VALUE.SET_CONTENT_TEXT(CONTENT_TEXT: DATA_DICT?["content_text"] as Any)
                        APPEND_VALUE.SET_CONTENT_TEXT_2(CONTENT_TEXT_2: DATA_DICT?["content_text2"] as Any)
                        APPEND_VALUE.SET_CONTENT_TYPE(CONTENT_TYPE: DATA_DICT?["content_type"] as Any)
                        APPEND_VALUE.SET_DATETIME(DATETIME: DATA_DICT?["request_time"] as Any)
                        APPEND_VALUE.SET_DST(DST: DATA_DICT?["dst"] as Any)
                        APPEND_VALUE.SET_DST_NAME(DST_NAME: DATA_DICT?["dst_name"] as Any)
                        APPEND_VALUE.SET_DST_TYPE(DST_TYPE: DATA_DICT?["dst_type"] as Any)
                        APPEND_VALUE.SET_FCM_KEY(FCM_KEY: DATA_DICT?["fcm_key"] as Any)
                        APPEND_VALUE.SET_FILE_COUNT(FILE_COUNT: DATA_DICT?["file_cnt"] as Any)
                        APPEND_VALUE.SET_FROM_FILE(FROM_FILE: DATA_DICT?["from_file"] as Any)
                        APPEND_VALUE.SET_IDX(IDX: DATA_DICT?["board_key"] as Any) // BOARD_KEY 내부DB
                        APPEND_VALUE.SET_INPUT_DATE(INPUT_DATE: DATA_DICT?["input_date"] as Any)
                        APPEND_VALUE.SET_IS_MODIFY(IS_MODIFY: DATA_DICT?["is_modify"] as Any)
                        APPEND_VALUE.SET_IS_PUSH(IS_PUSH: DATA_DICT?["is_push"] as Any)
                        APPEND_VALUE.SET_LIKE_COUNT(LIKE_COUNT: DATA_DICT?["like_cnt"] as Any)
                        APPEND_VALUE.SET_LIKE_ID(LIKE_ID: DATA_DICT?["like_id"] as Any)
                        APPEND_VALUE.SET_ME_LENGTH(ME_LENGTH: DATA_DICT?["me_length"] as Any)
                        APPEND_VALUE.SET_MEDIA_COUNT(MEDIA_COUNT: DATA_DICT?["media_cnt"] as Any)
                        APPEND_VALUE.SET_MSG_GROUP(MSG_GROUP: DATA_DICT?["msg_group"] as Any)
                        APPEND_VALUE.SET_NO(NO: DATA_DICT?["no"] as Any)
                        APPEND_VALUE.SET_OPEN_COUNT(OPEN_COUNT: DATA_DICT?["open_cnt"] as Any)
                        APPEND_VALUE.SET_POLL_NUM(POLL_NUM: DATA_DICT?["poll_num"] as Any)
                        APPEND_VALUE.SET_RESULT(RESULT: DATA_DICT?["result"] as Any)
                        APPEND_VALUE.SET_SC_CODE(SC_CODE: DATA_DICT?["sc_code"] as Any)
                        APPEND_VALUE.SET_SC_GRADE(SC_GRADE: DATA_DICT?["sc_grade"] as Any)
                        APPEND_VALUE.SET_SC_GROUP(SC_GROUP: DATA_DICT?["sc_group"] as Any)
                        APPEND_VALUE.SET_SC_LOCATION(SC_LOCATION: DATA_DICT?["sc_location"] as Any)
                        APPEND_VALUE.SET_SC_LOGO(SC_LOGO: DATA_DICT?["sc_logo"] as Any)
                        APPEND_VALUE.SET_SC_NAME(SC_NAME: DATA_DICT?["sc_name"] as Any)
                        APPEND_VALUE.SET_SEND_TYPE(SEND_TYPE: DATA_DICT?["send_type"] as Any)
                        APPEND_VALUE.SET_SENDER_IP(SENDER_IP: DATA_DICT?["sender_ip"] as Any)
                        APPEND_VALUE.SET_SUBJECT(SUBJECT: DATA_DICT?["subject"] as Any)
                        APPEND_VALUE.SET_TARGET_GRADE(TARGET_GRADE: DATA_DICT?["tagret_grade"] as Any)
                        APPEND_VALUE.SET_TARGET_CLASS(TARGET_CLASS: DATA_DICT?["target_class"] as Any)
                        APPEND_VALUE.SET_WR_SHARE(WR_SHARE: DATA_DICT?["wr_share"] as Any)
                        APPEND_VALUE.SET_WRITER(WRITER: DATA_DICT?["writer"] as Any)
                        // 데이터 추가
                        UIViewController.APPDELEGATE.PREVIEW_LIST.append(APPEND_VALUE)
                    } else {
                        break
                    }
                }
                
                if NEW {
                    if UIViewController.APPDELEGATE.ENROLL_LIST.count == 0 && !UserDefaults.standard.bool(forKey: "enroll") {
                        self.VIEWCONTROLLER_VC(IDENTIFIER: "SETTING_ENROLL")
                    } else {
                        self.VIEWCONTROLLER_VC(IDENTIFIER: "HOME")
                    }
                }
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.NOTIFICATION_VIEW("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.NOTIFICATION_VIEW("E: 네트워크 연결 실패 (000)") }
                
                self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
                
                if NEW {
                    if UIViewController.APPDELEGATE.ENROLL_LIST.count == 0 && !UserDefaults.standard.bool(forKey: "enroll") {
                        self.VIEWCONTROLLER_VC(IDENTIFIER: "SETTING_ENROLL")
                    } else {
                        self.VIEWCONTROLLER_VC(IDENTIFIER: "HOME")
                    }
                }
            }
        })
    }
    
    func GET_PUSH_POST_DATA(NAME: String, BOARD_TYPE: String, BOARD_KEY: String) {
        
        // 데이터 삭제
        UIViewController.APPDELEGATE.PUSH_API.removeAll()
        
        let POST_URL: String = DATA_URL().SCHOOL_URL + "message/school_sosik_detail.php"
        let PARAMETERS: Parameters = [
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "board_type": BOARD_TYPE,
            "board_key": BOARD_KEY
        ]
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 15.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseJSON(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
            print(response)
            
            switch response.result {
            case .success(_):
                
                guard let DATA_ARRAY = response.result.value as? Array<Any> else {
                    print("FAILURE: ")
                    self.VIEWCONTROLLER_VC(IDENTIFIER: "HOME")
                    return
                }
                
                for (_, DATA) in DATA_ARRAY.enumerated() {
                    
                    let DATA_DICT = DATA as? [String: Any]
                    let APPEND_VALUE = SOSIK_API()
                    
                    APPEND_VALUE.SET_ATTACHED(ATTACHED: self.SET_ATTACHED_DATA(ATTACHED_ARRAY: DATA_DICT?["attached"] as? [Any] ?? []))
                    APPEND_VALUE.SET_BOARD_CODE(BOARD_CODE: DATA_DICT?["board_code"] as Any)
                    APPEND_VALUE.SET_BOARD_ID(BOARD_ID: DATA_DICT?["board_id"] as Any)
                    APPEND_VALUE.SET_BOARD_KEY(BOARD_KEY: DATA_DICT?["board_key"] as Any)
                    APPEND_VALUE.SET_BOARD_NAME(BOARD_NAME: DATA_DICT?["board_name"] as Any)
                    APPEND_VALUE.SET_BOARD_SOURCE(BOARD_SOURCE: DATA_DICT?["board_source"] as Any)
                    APPEND_VALUE.SET_BOARD_TYPE(BOARD_TYPE: DATA_DICT?["board_type"] as Any)
                    APPEND_VALUE.SET_CALL_BACK(CALL_BACK: DATA_DICT?["callback"] as Any)
                    APPEND_VALUE.SET_CLASS_INFO(CLASS_INFO: DATA_DICT?["class_info"] as Any)
                    APPEND_VALUE.SET_CONTENT(CONTENT: DATA_DICT?["content"] as Any)
                    APPEND_VALUE.SET_CONTENT_TEXT(CONTENT_TEXT: DATA_DICT?["content_text"] as Any)
                    APPEND_VALUE.SET_CONTENT_TEXT_2(CONTENT_TEXT_2: DATA_DICT?["content_text2"] as Any)
                    APPEND_VALUE.SET_CONTENT_TYPE(CONTENT_TYPE: DATA_DICT?["content_type"] as Any)
                    APPEND_VALUE.SET_DATETIME(DATETIME: DATA_DICT?["request_time"] as Any)
                    APPEND_VALUE.SET_DST(DST: DATA_DICT?["dst"] as Any)
                    APPEND_VALUE.SET_DST_NAME(DST_NAME: DATA_DICT?["dst_name"] as Any)
                    APPEND_VALUE.SET_DST_TYPE(DST_TYPE: DATA_DICT?["dst_type"] as Any)
                    APPEND_VALUE.SET_FCM_KEY(FCM_KEY: DATA_DICT?["fcm_key"] as Any)
                    APPEND_VALUE.SET_FILE_COUNT(FILE_COUNT: DATA_DICT?["file_cnt"] as Any)
                    APPEND_VALUE.SET_FROM_FILE(FROM_FILE: DATA_DICT?["from_file"] as Any)
                    APPEND_VALUE.SET_IDX(IDX: DATA_DICT?["board_key"] as Any) // BOARD_KEY 내부DB
                    APPEND_VALUE.SET_INPUT_DATE(INPUT_DATE: DATA_DICT?["input_date"] as Any)
                    APPEND_VALUE.SET_IS_MODIFY(IS_MODIFY: DATA_DICT?["is_modify"] as Any)
                    APPEND_VALUE.SET_IS_PUSH(IS_PUSH: DATA_DICT?["is_push"] as Any)
                    APPEND_VALUE.SET_LIKE_COUNT(LIKE_COUNT: DATA_DICT?["like_cnt"] as Any)
                    APPEND_VALUE.SET_LIKE_ID(LIKE_ID: DATA_DICT?["like_id"] as Any)
                    APPEND_VALUE.SET_ME_LENGTH(ME_LENGTH: DATA_DICT?["me_length"] as Any)
                    APPEND_VALUE.SET_MEDIA_COUNT(MEDIA_COUNT: DATA_DICT?["media_cnt"] as Any)
                    APPEND_VALUE.SET_MSG_GROUP(MSG_GROUP: DATA_DICT?["msg_group"] as Any)
                    APPEND_VALUE.SET_NO(NO: DATA_DICT?["no"] as Any)
                    APPEND_VALUE.SET_OPEN_COUNT(OPEN_COUNT: DATA_DICT?["open_cnt"] as Any)
                    APPEND_VALUE.SET_POLL_NUM(POLL_NUM: DATA_DICT?["poll_num"] as Any)
                    APPEND_VALUE.SET_RESULT(RESULT: DATA_DICT?["result"] as Any)
                    APPEND_VALUE.SET_SC_CODE(SC_CODE: DATA_DICT?["sc_code"] as Any)
                    APPEND_VALUE.SET_SC_GRADE(SC_GRADE: DATA_DICT?["sc_grade"] as Any)
                    APPEND_VALUE.SET_SC_GROUP(SC_GROUP: DATA_DICT?["sc_group"] as Any)
                    APPEND_VALUE.SET_SC_LOCATION(SC_LOCATION: DATA_DICT?["sc_location"] as Any)
                    APPEND_VALUE.SET_SC_LOGO(SC_LOGO: DATA_DICT?["sc_logo"] as Any)
                    APPEND_VALUE.SET_SC_NAME(SC_NAME: DATA_DICT?["sc_name"] as Any)
                    APPEND_VALUE.SET_SEND_TYPE(SEND_TYPE: DATA_DICT?["send_type"] as Any)
                    APPEND_VALUE.SET_SENDER_IP(SENDER_IP: DATA_DICT?["sender_ip"] as Any)
                    APPEND_VALUE.SET_SUBJECT(SUBJECT: DATA_DICT?["subject"] as Any)
                    APPEND_VALUE.SET_TARGET_GRADE(TARGET_GRADE: DATA_DICT?["tagret_grade"] as Any)
                    APPEND_VALUE.SET_TARGET_CLASS(TARGET_CLASS: DATA_DICT?["target_class"] as Any)
                    APPEND_VALUE.SET_WR_SHARE(WR_SHARE: DATA_DICT?["wr_share"] as Any)
                    APPEND_VALUE.SET_WRITER(WRITER: DATA_DICT?["writer"] as Any)
                    // 데이터 추가
                    UIViewController.APPDELEGATE.PUSH_API.append(APPEND_VALUE)
                }
                self.SOSIK_DETAIL_VC(BOARD_TYPE: BOARD_TYPE)
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.NOTIFICATION_VIEW("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.NOTIFICATION_VIEW("E: 네트워크 연결 실패 (000)") }
                
                self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
            }
        })
    }
    
    func SOSIK_DETAIL_VC(BOARD_TYPE: String) {
        
        if UIViewController.APPDELEGATE.PUSH_API.count == 0 {
            VIEWCONTROLLER_VC(IDENTIFIER: "HOME")
        } else {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "DETAIL_SOSIK") as! DETAIL_SOSIK
            VC.modalTransitionStyle = .crossDissolve
            VC.PUSH = true
            VC.SOSIK_LIST = UIViewController.APPDELEGATE.PUSH_API
            VC.SOSIK_POSITION = 0
            present(VC, animated: true, completion: nil)
        }
    }
}
