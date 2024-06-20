//
//  LOADING.swift
//  부산교육 다모아
//
//  Created by 장제현 on 2020/07/05.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class LOADING: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var PUSH_YN: Bool = false
    var BOARD_KEY: String = ""
    var BOARD_TYPE: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 아이디 확인
        if UserDefaults.standard.string(forKey: "mb_id") ?? "" == "" {
            DispatchQueue.main.async { self.VIEWCONTROLLER_VC(IDENTIFIER: "SIGN_UP") }
        } else {
            // 학생 위치 서비스 설정
            UIViewController.APPDELEGATE.LOC_UPDATE()
            //MARK: 네트워크 연결 확인
            NETWORK_CHECK()
        }
    }
    
    //MARK: 네트워크 연결 확인
    @objc func NETWORK_CHECK() {
        
        if SYSTEM_NETWORK_CHECKING() {
            // 로그인 확인
            if !UIViewController.APPDELEGATE.LOGIN { GET_LOGIN_POST_DATA(NAME: "로그인", BOARD_TYPE: "") }
            // PUSH 확인
            if PUSH_YN {
                if BOARD_TYPE == "SC" {
                    UIViewController.APPDELEGATE.SC_CHECK = true
                    GET_PREVIEW_POST_DATA(NAME: "미리보기(새로고침)", BOARD_TYPE: "A", NEW: true)
                } else if BOARD_TYPE == "SV" {
                    UIViewController.APPDELEGATE.SV_CHECK = true
                    GET_PREVIEW_POST_DATA(NAME: "미리보기(새로고침)", BOARD_TYPE: "A", NEW: true)
                } else if BOARD_TYPE == "T" || BOARD_TYPE == "EL" || BOARD_TYPE == "LE" {
                    UIViewController.APPDELEGATE.T_CHECK = true
                    GET_PREVIEW_POST_DATA(NAME: "미리보기(새로고침)", BOARD_TYPE: "A", NEW: true)
                } else if BOARD_TYPE == "CS" || BOARD_TYPE == "PE" || BOARD_TYPE == "PA" {
                    UIViewController.APPDELEGATE.CS_CHECK = true
                    GET_PREVIEW_POST_DATA(NAME: "미리보기(새로고침)", BOARD_TYPE: "A", NEW: true)
                } else if BOARD_TYPE != "" || BOARD_KEY != "" {
                    GET_PREVIEW_POST_DATA(NAME: "미리보기(새로고침)", BOARD_TYPE: "A", NEW: false)
                    GET_PUSH_POST_DATA(NAME: "PUSH", BOARD_TYPE: BOARD_TYPE, BOARD_KEY: BOARD_KEY)
                }
            } else {
                GET_PREVIEW_POST_DATA(NAME: "미리보기(새로고침)", BOARD_TYPE: "A", NEW: true)
            }
        } else {
            NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
            DispatchQueue.main.async {
                let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                ALERT.addAction(UIAlertAction(title: "새로고침", style: .default) { (_) in self.NETWORK_CHECK() })
                self.present(ALERT, animated: true, completion: nil)
            }
        }
    }
}
