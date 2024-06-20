//
//  SETTING_VERSION.swift
//  busan-damoa
//
//  Created by 장 제현 on 2021/03/08.
//  Copyright © 2021 장제현. All rights reserved.
//

import UIKit
import Alamofire

//MARK: 앱 버전 확인
extension UIViewController {
    
    func CHECK_VERSION(_ NAVI_TITLE: UIView) {
        
        let STORE_VERSION = UIViewController.APPDELEGATE.NEW_VERSION
        let NOW_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String // 현재 버전
        
        if NOW_VERSION < STORE_VERSION {
            if !DEVICE_RATIO() {
                EFFECT_UPDATE_NOTI(UIView(), NAVI_TITLE, "iOS 새로운 버전 업데이트 알림", "버전 \(STORE_VERSION) 으로 업데이트 해주세요", Y: 20.0)
            } else {
                EFFECT_UPDATE_NOTI(UIView(), NAVI_TITLE, "iOS 새로운 버전 업데이트 알림", "버전 \(STORE_VERSION) 으로 업데이트 해주세요", Y: 34.0)
            }
        }
    }
    
    func GET_VERSION_POST_DATA(NAME: String, ACTION_TYPE: String) {
        
        let POST_URL: String = DATA_URL().SCHOOL_URL + "member/version_check.php"
        let PARAMETERS: Parameters = [
            "os": "ios"
        ]
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 15.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseJSON(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
            print(response)
            
            switch response.result {
            case .success(_):
                
                guard let DATA_DICT = response.result.value as? [String: Any] else {
                    print("FAILURE: ")
                    return
                }
                
                // 데이터 추가
                UIViewController.APPDELEGATE.NEW_VERSION = DATA_DICT["version_name"] as? String ?? "1.0"
            case .failure(let ERROR):
                
                print("ERROR: \(ERROR.localizedDescription)")
            }
        })
    }
}
