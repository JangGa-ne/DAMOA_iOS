//
//  SETTING_SQL.swift
//  busan-damoa
//
//  Created by 장 제현 on 2021/03/08.
//  Copyright © 2021 장제현. All rights reserved.
//

import UIKit

class PSBG_DB_STMT {
    
    var DB: OpaquePointer?          // SQLite 연결 정보를 담을 객체
    var STMT: OpaquePointer?        // 컴파일된 SQL을 담을 객체
}

class PSBG_DATA {
    
    var PUSH_N: Bool = false
    var PUSH_M: Bool = false
    var PUSH_C: Bool = false
    var PUSH_F: Bool = false
    var PUSH_T: Bool = false
    var PUSH_ET: Bool = false
    var PUSH_SC: Bool = false
    var PUSH_S: Bool = false
    var PUSH_NS: Bool = false
    var PUSH_EN: Bool = false
    var PUSH_CS: Bool = false
    var PUSH_SV: Bool = false
    
    func SET_PUSH_N(PUSH_N: Any) { self.PUSH_N = (PUSH_N as! NSString).boolValue }
    func SET_PUSH_M(PUSH_M: Any) { self.PUSH_M = (PUSH_M as! NSString).boolValue }
    func SET_PUSH_C(PUSH_C: Any) { self.PUSH_C = (PUSH_C as! NSString).boolValue }
    func SET_PUSH_F(PUSH_F: Any) { self.PUSH_F = (PUSH_F as! NSString).boolValue }
    func SET_PUSH_T(PUSH_T: Any) { self.PUSH_T = (PUSH_T as! NSString).boolValue }
    func SET_PUSH_ET(PUSH_ET: Any) { self.PUSH_ET = (PUSH_ET as! NSString).boolValue }
    func SET_PUSH_SC(PUSH_SC: Any) { self.PUSH_SC = (PUSH_SC as! NSString).boolValue }
    func SET_PUSH_S(PUSH_S: Any) { self.PUSH_S = (PUSH_S as! NSString).boolValue }
    func SET_PUSH_NS(PUSH_NS: Any) { self.PUSH_NS = (PUSH_NS as! NSString).boolValue }
    func SET_PUSH_EN(PUSH_EN: Any) { self.PUSH_EN = (PUSH_EN as! NSString).boolValue }
    func SET_PUSH_CS(PUSH_CS: Any) { self.PUSH_CS = (PUSH_CS as! NSString).boolValue }
    func SET_PUSH_SV(PUSH_SV: Any) { self.PUSH_SV = (PUSH_SV as! NSString).boolValue }
}

//MARK: SQL
extension AppDelegate {
    
    // DB 열기
    func OPEN_DB_MAIN() {
        
        let FILE_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("SCHOOL_DB.sqlite")
        
        if sqlite3_open(FILE_URL.path, &SQL_SCHOOL.DB) != SQLITE_OK {
            print("DB 연결 실패")
        }
        
        // KEY_ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        
        let CREATE_TABLE = "CREATE TABLE IF NOT EXISTS SCHOOL_DB (BOARD_CODE TEXT, BOARD_ID TEXT, BOARD_KEY TEXT, BOARD_NAME TEXT, BOARD_SOURCE TEXT, BOARD_TYPE TEXT, CALL_BACK TEXT, CLASS_INFO TEXT, CONTENT TEXT, CONTENT_TEXT TEXT, CONTENT_TYPE TEXT, DATETIME TEXT, DST TEXT, DST_NAME TEXT, DST_TYPE TEXT, FCM_KEY TEXT, FILE_COUNT TEXT, FROM_FILE TEXT, IDX TEXT, INPUT_DATE TEXT, IS_MODIFY TEXT, IS_PUSH TEXT, LIKE_COUNT TEXT, LIKE_ID TEXT, ME_LENGTH TEXT, MEDIA_COUNT TEXT, MSG_GROUP TEXT, NO TEXT, OPEN_COUNT TEXT, POLL_NUM TEXT, RESULT TEXT, SC_CODE TEXT, SC_GRADE TEXT, SC_GROUP TEXT, SC_LOCATION TEXT, SC_LOGO TEXT, SC_NAME TEXT, SEND_TYPE TEXT, SENDER_IP TEXT, SUBJECT TEXT, TARGET_GRADE TEXT, TARGET_CLASS TEXT, WR_SHARE TEXT, WRITER TEXT, LIKE BOOL, ATTACHED_DATETIME TEXT, ATTACHED_DT_FROM TEXT, ATTACHED_FILE_NAME TEXT, ATTACHED_FILE_NAME_ORG TEXT, ATTACHED_FILE_SIZE TEXT, ATTACHED_IDX TEXT, ATTACHED_IN_SEQ TEXT, ATTACHED_LAT TEXT, ATTACHED_LNG TEXT, ATTACHED_MEDIA_FILES TEXT, ATTACHED_MEDIA_TYPE TEXT, ATTACHED_MSG_GROUP TEXT, ATTACHED_HTTP_STRING TEXT, ATTACHED_DOWNLOAD_URL TEXT)"
        
        if sqlite3_exec(SQL_SCHOOL.DB, CREATE_TABLE, nil, nil, nil) != SQLITE_OK {
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(SQL_SCHOOL.DB)!)
            print("ERROR CREATING TABLE : \(ERROR_MESSAGE)")
        }
    }
    
    // DB 저장
    func INSERT_DB_MAIN(BOARD_CODE: String, BOARD_ID: String, BOARD_KEY: String, BOARD_NAME: String, BOARD_SOURCE: String, BOARD_TYPE: String, CALL_BACK: String, CLASS_INFO: String, CONTENT: String, CONTENT_TEXT: String, CONTENT_TYPE: String, DATETIME: String, DST: String, DST_NAME: String, DST_TYPE: String, FCM_KEY: String, FILE_COUNT: String, FROM_FILE: String, IDX: String, INPUT_DATE: String, IS_MODIFY: String, IS_PUSH: String, LIKE_COUNT: String, LIKE_ID: String, ME_LENGTH: String, MEDIA_COUNT: String, MSG_GROUP: String, NO: String, OPEN_COUNT: String, POLL_NUM: String, RESULT: String, SC_CODE: String, SC_GRADE: String, SC_GROUP: String, SC_LOCATION: String, SC_LOGO: String, SC_NAME: String, SEND_TYPE: String, SENDER_IP: String, SUBJECT: String, TARGET_GRADE: String, TARGET_CLASS: String, WR_SHARE: String, WRITER: String, LIKE: Bool, AT_DATETIME: String, AT_DT_FROM: String, AT_FILE_NAME: String, AT_FILE_NAME_ORG: String, AT_FILE_SIZE: String, AT_IDX: String, AT_IN_SEQ: String, AT_LAT: String, AT_LNG: String, AT_MEDIA_FILES: String, AT_MEDIA_TYPE: String, AT_MSG_GROUP: String, AT_HTTP_STRING: String, AT_DOWNLOAD_URL: String) {
        
        let INSERT_TABLE = "INSERT INTO SCHOOL_DB (BOARD_CODE, BOARD_ID, BOARD_KEY, BOARD_NAME, BOARD_SOURCE, BOARD_TYPE, CALL_BACK, CLASS_INFO, CONTENT, CONTENT_TEXT, CONTENT_TYPE, DATETIME, DST, DST_NAME, DST_TYPE, FCM_KEY, FILE_COUNT, FROM_FILE, IDX, INPUT_DATE, IS_MODIFY, IS_PUSH, LIKE_COUNT, LIKE_ID, ME_LENGTH, MEDIA_COUNT, MSG_GROUP, NO, OPEN_COUNT, POLL_NUM, RESULT, SC_CODE, SC_GRADE, SC_GROUP, SC_LOCATION, SC_LOGO, SC_NAME, SEND_TYPE, SENDER_IP, SUBJECT, TARGET_GRADE, TARGET_CLASS, WR_SHARE, WRITER, LIKE, ATTACHED_DATETIME, ATTACHED_DT_FROM, ATTACHED_FILE_NAME, ATTACHED_FILE_NAME_ORG, ATTACHED_FILE_SIZE, ATTACHED_IDX, ATTACHED_IN_SEQ, ATTACHED_LAT, ATTACHED_LNG, ATTACHED_MEDIA_FILES, ATTACHED_MEDIA_TYPE, ATTACHED_MSG_GROUP, ATTACHED_HTTP_STRING, ATTACHED_DOWNLOAD_URL) VALUES ('\(BOARD_CODE)', '\(BOARD_ID)', '\(BOARD_KEY)', '\(BOARD_NAME)', '\(BOARD_SOURCE)', '\(BOARD_TYPE)', '\(CALL_BACK)', '\(CLASS_INFO)', '\(CONTENT)', '\(CONTENT_TEXT)', '\(CONTENT_TYPE)', '\(DATETIME)', '\(DST)', '\(DST_NAME)', '\(DST_TYPE)', '\(FCM_KEY)', '\(FILE_COUNT)', '\(FROM_FILE)', '\(IDX)', '\(INPUT_DATE)', '\(IS_MODIFY)', '\(IS_PUSH)', '\(LIKE_COUNT)', '\(LIKE_ID)', '\(ME_LENGTH)', '\(MEDIA_COUNT)', '\(MSG_GROUP)', '\(NO)', '\(OPEN_COUNT)', '\(POLL_NUM)', '\(RESULT)', '\(SC_CODE)', '\(SC_GRADE)', '\(SC_GROUP)', '\(SC_LOCATION)', '\(SC_LOGO)', '\(SC_NAME)', '\(SEND_TYPE)', '\(SENDER_IP)', '\(SUBJECT)', '\(TARGET_GRADE)', '\(TARGET_CLASS)', '\(WR_SHARE)', '\(WRITER)', '\(LIKE)', '\(AT_DATETIME)', '\(AT_DT_FROM)', '\(AT_FILE_NAME)', '\(AT_FILE_NAME_ORG)', '\(AT_FILE_SIZE)', '\(AT_IDX)', '\(AT_IN_SEQ)', '\(AT_LAT)', '\(AT_LNG)', '\(AT_MEDIA_FILES)', '\(AT_MEDIA_TYPE)', '\(AT_MSG_GROUP)', '\(AT_HTTP_STRING)', '\(AT_DOWNLOAD_URL)')"
        
        if sqlite3_prepare_v2(SQL_SCHOOL.DB, INSERT_TABLE, -1, &SQL_SCHOOL.STMT, nil) != SQLITE_OK {
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(SQL_SCHOOL.DB)!)
            print("[소식] ERROR PREPARING INSERT : \(ERROR_MESSAGE)")
            return
        }
        
        if sqlite3_step(SQL_SCHOOL.STMT) != SQLITE_DONE {
            print("FAILURE SAVED")
        }
    }
    
    func ALTER_DB_MAIN() {
        
        let ALTER_TABLE = "ALTER TABLE SCHOOL_DB ADD COLUMN ATTACHED_DOWNLOAD_URL TEXT"
        
        if sqlite3_prepare_v2(SQL_SCHOOL.DB, ALTER_TABLE, -1, &SQL_SCHOOL.STMT, nil) != SQLITE_OK {
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(SQL_SCHOOL.DB)!)
            print("[소식] ERROR PREPARING ALTER : \(ERROR_MESSAGE)")
            return
        }
        
        if sqlite3_step(SQL_SCHOOL.STMT) != SQLITE_DONE {
            print("FIELD ATTACHED_DOWNLOAD_URL ADDED TO SCHOOL_DB")
        }
        sqlite3_finalize(SQL_SCHOOL.STMT)
    }
    
    // DB 삭제
    func DELETE_DB_MAIN(ALL: Bool, BOARD_KEY: String) {
        
        var DELETE_TABLE: String = ""
        if ALL {
            DELETE_TABLE = "DELETE FROM SCHOOL_DB"
        } else {
            DELETE_TABLE = "DELETE FROM SCHOOL_DB WHERE BOARD_KEY = '\(BOARD_KEY)'"
        }
        
        if sqlite3_exec(SQL_SCHOOL.DB, DELETE_TABLE, nil, nil, nil) != SQLITE_OK {
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(SQL_SCHOOL.DB)!)
            print("ERROR DELETE TABLE : \(ERROR_MESSAGE)")
        }
    }
    
//MARK: PUSH 배지 SQL 설정
    
    func OPEN_PUSH_BADGE_DB() {
        
        let FILE_URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("PSBG_DB.sqlite")
        
        if sqlite3_open(FILE_URL.path, &PSBG_DB.DB) != SQLITE_OK {
            print("DB 연결 실패")
        }
        
        let CREATE_TABLE = "CREATE TABLE IF NOT EXISTS PSBG_DB (PUSH_N TEXT, PUSH_M TEXT, PUSH_C TEXT, PUSH_F TEXT, PUSH_T TEXT, PUSH_ET TEXT, PUSH_SC TEXT, PUSH_S TEXT, PUSH_NS TEXT, PUSH_EN TEXT, PUSH_CS TEXT, PUSH_SV TEXT)"
        
        if sqlite3_exec(PSBG_DB.DB, CREATE_TABLE, nil, nil, nil) != SQLITE_OK {
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(PSBG_DB.DB)!)
            print("ERROR CREATING TABLE : \(ERROR_MESSAGE)")
        }
    }
    
    // DB 저장
    func SAVE_PUSH_BADGE_DB() {
        
        let INSERT_TABLE = "INSERT INTO PSBG_DB (PUSH_N, PUSH_M, PUSH_C, PUSH_F, PUSH_T, PUSH_ET, PUSH_SC, PUSH_S, PUSH_NS, PUSH_EN, PUSH_CS, PUSH_SV) VALUES ('\(false)', '\(false)', '\(false)', '\(false)', '\(false)', '\(false)', '\(true)', '\(false)', '\(false)', '\(false)', '\(false)', '\(false)')"
        
        if sqlite3_prepare_v2(self.PSBG_DB.DB, INSERT_TABLE, -1, &self.PSBG_DB.STMT, nil) != SQLITE_OK {
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(self.PSBG_DB.DB)!)
            print("[PUSH] ERROR PREPARING INSERT : \(ERROR_MESSAGE)")
            return
        }
        
        if sqlite3_step(self.PSBG_DB.STMT) != SQLITE_DONE {
            print("FAILURE SAVED")
        }
    }
    
    func UPDATE_PUSH_BADGE_DB() {
        
        let UPDATE_TABLE = "UPDATE PSBG_DB SET PUSH_N='\(PUSH_N)', PUSH_M='\(PUSH_M)', PUSH_C='\(PUSH_C)', PUSH_F='\(PUSH_F)', PUSH_T='\(PUSH_T)', PUSH_ET='\(PUSH_ET)', PUSH_SC='\(PUSH_SC)', PUSH_S='\(PUSH_S)', PUSH_NS='\(PUSH_NS)', PUSH_EN='\(PUSH_EN)', PUSH_CS='\(PUSH_CS)', PUSH_SV='\(PUSH_SV)'"
        
        if sqlite3_prepare_v2(self.PSBG_DB.DB, UPDATE_TABLE, -1, &self.PSBG_DB.STMT, nil) != SQLITE_OK {
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(self.PSBG_DB.DB)!)
            print("ERROR PREPARING UPDATE : \(ERROR_MESSAGE)")
            return
        }
        
        if sqlite3_step(self.PSBG_DB.STMT) != SQLITE_DONE {
            print("FAILURE SAVED")
        }
        
        MAIN_VC?.PUSH_VIEW()
    }
    
    func DELETE_PUSH_BADGE_DB() {
        
        let DELETE_TABLE = "DELETE FROM PSBG_DB"
        
        if sqlite3_exec(PSBG_DB.DB, DELETE_TABLE, nil, nil, nil) != SQLITE_OK {
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(PSBG_DB.DB)!)
            print("ERROR DELETE TABLE : \(ERROR_MESSAGE)")
        }
    }
}

extension UIViewController {
    
    // DB 불러오기
    func SCRAP_CHECK(BOARD_TYPE: String) {
        
        var BOARD_KEY: [String] = []
        var LIKE: [String] = []
        
        // 데이터 삭제
        BOARD_KEY.removeAll(); LIKE.removeAll()
        
        let SQL_EDIT: String = "SELECT * FROM SCHOOL_DB ORDER BY DATETIME DESC"
        let SC_SCRAP_SQL = UIViewController.APPDELEGATE.SQL_SCHOOL
        
        if sqlite3_prepare(SC_SCRAP_SQL.DB, SQL_EDIT, -1, &SC_SCRAP_SQL.STMT, nil) != SQLITE_OK {
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(SC_SCRAP_SQL.DB)!)
            print("[좋아요] ERROR PREPARING SELECT: \(ERROR_MESSAGE)")
            return
        }
        
        while sqlite3_step(SC_SCRAP_SQL.STMT) == SQLITE_ROW {
            
            BOARD_KEY.append(String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 2)))
            LIKE.append(String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 44)))
        }
        
        // 소식보관함
        if BOARD_TYPE == "MAIN" {
            for DATA in (UIViewController.APPDELEGATE.MAIN_VC?.SOSIK_LIST)! { DATA.LIKE = false
                for i in 0 ..< BOARD_KEY.count { if DATA.BOARD_KEY == BOARD_KEY[i] { DATA.LIKE = Bool(LIKE[i]) ?? false } }
            }
        } else if BOARD_TYPE == "A" {
            for DATA in (UIViewController.APPDELEGATE.SOSIK_A_VC?.SOSIK_LIST)! { DATA.LIKE = false
                for i in 0 ..< BOARD_KEY.count { if DATA.BOARD_KEY == BOARD_KEY[i] { DATA.LIKE = Bool(LIKE[i]) ?? false } }
            }
        } else if BOARD_TYPE == "N" {
            for DATA in (UIViewController.APPDELEGATE.SOSIK_N_VC?.SOSIK_LIST)! { DATA.LIKE = false
                for i in 0 ..< BOARD_KEY.count { if DATA.BOARD_KEY == BOARD_KEY[i] { DATA.LIKE = Bool(LIKE[i]) ?? false } }
            }
        } else if BOARD_TYPE == "M" {
            for DATA in (UIViewController.APPDELEGATE.SOSIK_M_VC?.SOSIK_LIST)! { DATA.LIKE = false
                for i in 0 ..< BOARD_KEY.count { if DATA.BOARD_KEY == BOARD_KEY[i] { DATA.LIKE = Bool(LIKE[i]) ?? false } }
            }
        } else if BOARD_TYPE == "C" {
            for DATA in (UIViewController.APPDELEGATE.SOSIK_C_VC?.SOSIK_LIST)! { DATA.LIKE = false
                for i in 0 ..< BOARD_KEY.count { if DATA.BOARD_KEY == BOARD_KEY[i] { DATA.LIKE = Bool(LIKE[i]) ?? false } }
            }
        } else if BOARD_TYPE == "F" {
            for DATA in (UIViewController.APPDELEGATE.SOSIK_F_VC?.SOSIK_LIST)! { DATA.LIKE = false
                for i in 0 ..< BOARD_KEY.count { if DATA.BOARD_KEY == BOARD_KEY[i] { DATA.LIKE = Bool(LIKE[i]) ?? false } }
            }
        } else if BOARD_TYPE == "ET" {
            for DATA in (UIViewController.APPDELEGATE.SOSIK_ET_VC?.SOSIK_LIST)! { DATA.LIKE = false
                for i in 0 ..< BOARD_KEY.count { if DATA.BOARD_KEY == BOARD_KEY[i] { DATA.LIKE = Bool(LIKE[i]) ?? false } }
            }
        } else if BOARD_TYPE == "NS" {
            for DATA in (UIViewController.APPDELEGATE.SOSIK_NS_VC?.SOSIK_LIST)! { DATA.LIKE = false
                for i in 0 ..< BOARD_KEY.count { if DATA.BOARD_KEY == BOARD_KEY[i] { DATA.LIKE = Bool(LIKE[i]) ?? false } }
            }
        } else if BOARD_TYPE == "EN" {
            for DATA in (UIViewController.APPDELEGATE.SOSIK_EN_VC?.SOSIK_LIST)! { DATA.LIKE = false
                for i in 0 ..< BOARD_KEY.count { if DATA.BOARD_KEY == BOARD_KEY[i] { DATA.LIKE = Bool(LIKE[i]) ?? false } }
            }
        }
    }
}
