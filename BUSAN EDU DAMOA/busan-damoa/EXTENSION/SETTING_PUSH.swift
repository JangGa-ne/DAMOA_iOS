//
//  SETTING_PUSH.swift
//  busan-damoa
//
//  Created by 장 제현 on 2021/03/08.
//  Copyright © 2021 장제현. All rights reserved.
//

import UIKit
import FirebaseMessaging

//MARK: PUSH 설정
extension UIViewController {
    
    func PUSH_CENTER() {
        
        // 긴급알림
        Messaging.messaging().subscribe(toTopic: "MAIN_EN")
        // 교육청알림 ( 공지사항은 항상켜짐 )
        Messaging.messaging().subscribe(toTopic: "MAINN_ios")
        // 가족알림
        Messaging.messaging().subscribe(toTopic: "p\(UIViewController.USER_DATA.string(forKey: "mb_id") ?? "")")
        // 토픽 강제 구독 취소
        Messaging.messaging().unsubscribe(fromTopic: "MAINT_ios")
        Messaging.messaging().unsubscribe(fromTopic: "MAINCS_ios")
        
        MAIN_PUSH_CONTROL_CENTER()      // 메인푸시
        SCHOOL_PUSH_CONTROL_CENTER()    // 학교푸시
    }
    
    func MAIN_PUSH_CONTROL_CENTER() {
        
        // 가정통신문
        if UserDefaults.standard.bool(forKey: "switch_m") {
            Messaging.messaging().subscribe(toTopic: "MAINM_ios")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "MAINM_ios")
        }
        // 학급알림장
        if UserDefaults.standard.bool(forKey: "switch_c") {
            Messaging.messaging().subscribe(toTopic: "MAINC_ios")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "MAINC_ios")
        }
        // 오늘의식단
        if UserDefaults.standard.bool(forKey: "switch_f") {
            Messaging.messaging().subscribe(toTopic: "MAINF_ios")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "MAINF_ios")
        }
        
        // 학부모연수
        if UserDefaults.standard.bool(forKey: "switch_t") {
            Messaging.messaging().unsubscribe(fromTopic: "MAINT_ios")
            Messaging.messaging().subscribe(toTopic: "MAINEL_ios")
            Messaging.messaging().subscribe(toTopic: "MAINLE_ios")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "MAINEL_ios")
            Messaging.messaging().unsubscribe(fromTopic: "MAINLE_ios")
        }
        // 진로도움방
        if UserDefaults.standard.bool(forKey: "switch_et") {
            Messaging.messaging().subscribe(toTopic: "MAINETN_ios")
            Messaging.messaging().subscribe(toTopic: "MAINETV_ios")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "MAINETN_ios")
            Messaging.messaging().unsubscribe(fromTopic: "MAINETV_ios")
        }
        // 자녀안심
        if UserDefaults.standard.bool(forKey: "switch_sc") {
            Messaging.messaging().subscribe(toTopic: "MAINSC_ios")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "MAINSC_ios")
        }
        // 학사일정
        if UserDefaults.standard.bool(forKey: "switch_s") {
            Messaging.messaging().subscribe(toTopic: "MAINS_ios")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "MAINS_ios")
        }
        
        // 학교뉴스
        if UserDefaults.standard.bool(forKey: "switch_ns") {
            Messaging.messaging().subscribe(toTopic: "MAINENS_ios")
            Messaging.messaging().subscribe(toTopic: "MAINENSA_ios")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "MAINENS_ios")
            Messaging.messaging().unsubscribe(fromTopic: "MAINENSA_ios")
        }
        // 교육뉴스
        if UserDefaults.standard.bool(forKey: "switch_en") {
            Messaging.messaging().subscribe(toTopic: "MAINEN_ios")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "MAINEN_ios")
        }
        // 행사체험
        if UserDefaults.standard.bool(forKey: "switch_cs") {
            Messaging.messaging().unsubscribe(fromTopic: "MAICS_ios")
            Messaging.messaging().subscribe(toTopic: "MAINPE_ios")
            Messaging.messaging().subscribe(toTopic: "MAINPA_ios")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "MAINPE_ios")
            Messaging.messaging().unsubscribe(fromTopic: "MAINPA_ios")
        }
        // 설문조사
        if UserDefaults.standard.bool(forKey: "switch_sv") {
            Messaging.messaging().subscribe(toTopic: "MAINSV_ios")
        } else {
            Messaging.messaging().unsubscribe(fromTopic: "MAINSV_ios")
        }
    }
    
    func SCHOOL_PUSH_CONTROL_CENTER() {
        
        //MARK: 관할 교육청
//        Messaging.messaging().subscribe(toTopic: "lo_\(SC_LOCATION)")
//        Messaging.messaging().subscribe(toTopic: "gr_\(SC_GRADE)")
//        Messaging.messaging().subscribe(toTopic: "\(SC_GROUP)")
//
//        Messaging.messaging().subscribe(toTopic: "\(SC_GROUP)_gr_\(SC_GRADE)")
//        Messaging.messaging().subscribe(toTopic: "\(SC_GROUP)_lo_\(SC_LOCATION)")
//        Messaging.messaging().subscribe(toTopic: "lo_\(SC_LOCATION)_gr_\(SC_GRADE)")
//        Messaging.messaging().subscribe(toTopic: "\(SC_GROUP)_lo_\(SC_LOCATION)_gr_\(SC_GRADE)")
        
        let ENROLL_DATA = UIViewController.APPDELEGATE.ENROLL_LIST
            
        for i in 0 ..< ENROLL_DATA.count {
        
            let SC_CODE = ENROLL_DATA[i].value(forKey: "sc_code") as? String ?? ""
            let CL_CODE = ENROLL_DATA[i].value(forKey: "cl_code") as? String ?? ""
            
            // 공지사항
            if UserDefaults.standard.bool(forKey: "switch_n") {
                Messaging.messaging().subscribe(toTopic: "\(SC_CODE)N_ios")
            } else {
                Messaging.messaging().unsubscribe(fromTopic: "\(SC_CODE)N_ios")
            }
            // 가정통신문
            if UserDefaults.standard.bool(forKey: "switch_m") {
                Messaging.messaging().subscribe(toTopic: "\(SC_CODE)M_ios")
            } else {
                Messaging.messaging().unsubscribe(fromTopic: "\(SC_CODE)M_ios")
            }
            // 학급알림장
            if UserDefaults.standard.bool(forKey: "switch_c") {
                Messaging.messaging().subscribe(toTopic: "\(SC_CODE)C_ios")
                if CL_CODE != "" { Messaging.messaging().subscribe(toTopic: "\(CL_CODE)C_ios") }
            } else {
                Messaging.messaging().unsubscribe(fromTopic: "\(SC_CODE)C_ios")
                if CL_CODE != "" { Messaging.messaging().unsubscribe(fromTopic: "\(CL_CODE)C_ios") }
            }
            // 오늘의식단
            if UserDefaults.standard.bool(forKey: "switch_f") {
                Messaging.messaging().subscribe(toTopic: "\(SC_CODE)F_ios")
            } else {
                Messaging.messaging().unsubscribe(fromTopic: "\(SC_CODE)F_ios")
            }
            
            // 학교뉴스
            if UserDefaults.standard.bool(forKey: "switch_ns") {
                Messaging.messaging().subscribe(toTopic: "\(SC_CODE)NS_ios")
            } else {
                Messaging.messaging().unsubscribe(fromTopic: "\(SC_CODE)NS_ios")
            }
        }
    }
    
    //MARK: PUSH 배지
    func PUSH_BADGE(BOARD_TYPE: String, _ YN: Bool) {
        
        UIViewController.USER_DATA.set(0, forKey: "PUSH_\(BOARD_TYPE)")
        UIViewController.USER_DATA.synchronize()
        
        let APPDELEGATE = UIViewController.APPDELEGATE
        
        if BOARD_TYPE == "N" || BOARD_TYPE == "AN" {
            if YN { APPDELEGATE.PUSH_N = true } else { APPDELEGATE.PUSH_N = false }
        } else if BOARD_TYPE == "M" {
            if YN { APPDELEGATE.PUSH_M = true } else { APPDELEGATE.PUSH_M = false }
        } else if BOARD_TYPE == "C" {
            if YN { APPDELEGATE.PUSH_C = true } else { APPDELEGATE.PUSH_C = false }
        } else if BOARD_TYPE == "F" {
            if YN { APPDELEGATE.PUSH_F = true } else { APPDELEGATE.PUSH_F = false }
        } else if BOARD_TYPE == "T" || BOARD_TYPE == "EL" || BOARD_TYPE == "LE" {
            if YN { APPDELEGATE.PUSH_T = true } else { APPDELEGATE.PUSH_T = false }
        } else if BOARD_TYPE == "ET" || BOARD_TYPE == "ETN" || BOARD_TYPE == "ETV" {
            if YN { APPDELEGATE.PUSH_ET = true } else { APPDELEGATE.PUSH_ET = false }
        } else if BOARD_TYPE == "SC" {
            if YN { APPDELEGATE.PUSH_SC = true } else { APPDELEGATE.PUSH_SC = false }
        } else if BOARD_TYPE == "S" {
            if YN { APPDELEGATE.PUSH_S = true } else { APPDELEGATE.PUSH_S = false }
        } else if BOARD_TYPE == "NS" || BOARD_TYPE == "NSA" {
            if YN { APPDELEGATE.PUSH_NS = true } else { APPDELEGATE.PUSH_NS = false }
        } else if BOARD_TYPE == "EN" {
            if YN { APPDELEGATE.PUSH_EN = true } else { APPDELEGATE.PUSH_EN = false }
        } else if BOARD_TYPE == "CS" || BOARD_TYPE == "PE" || BOARD_TYPE == "PA" {
            if YN { APPDELEGATE.PUSH_CS = true } else { APPDELEGATE.PUSH_CS = false }
        } else if BOARD_TYPE == "SV" {
            if YN { APPDELEGATE.PUSH_SV = true } else { APPDELEGATE.PUSH_SV = false }
        }
        
        APPDELEGATE.UPDATE_PUSH_BADGE_DB()
        APPDELEGATE.MAIN_VC?.PUSH_VIEW()
    }
}
