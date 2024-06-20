//
//  SCHOOL_DB.swift
//  DAMOA
//
//  Created by 장제현 on 2020/04/05.
//  Copyright © 2020 장제현. All rights reserved.
//

import Foundation

class SQLITE_DAMOA {
    
    var DB: OpaquePointer?          // SQLite 연결 정보를 담을 객체
    var STMT: OpaquePointer?        // 컴파일된 SQL을 담을 객체
}

// 학교 데이터
public class SCHOOL_DB {
    
    var PAGE: Int = 0
    
    var ATTACHED: [ATTACHED_DB] = []
    var BOARD_CODE: String = ""
    var BOARD_ID: String = ""
    var BOARD_KEY: String = ""
    var BOARD_NAME: String = ""
    var BOARD_SOURCE: String = ""
    var BOARD_TYPE: String = ""
    var CALL_BACK: String = ""
    var CLASS_INFO: String = ""
    var CONTENT: String = ""
    var CONTENT_TEXT: String = ""
    var CONTENT_TEXT_2: String = ""
    var CONTENT_TYPE: String = ""
    var DATETIME: String = ""
    var DST: String = ""
    var DST_NAME: String = ""
    var DST_TYPE: String = ""
    var FCM_KEY: String = ""
    var FILE_COUNT: String = ""
    var FROM_FILE: String = ""
    var IDX: String = ""
    var INPUT_DATE: String = ""
    var IS_MODIFY: String = ""
    var IS_PUSH: String = ""
    var LIKE_COUNT: String = ""
    var LIKE_ID: String = ""
    var ME_LENGTH: String = ""
    var MEDIA_COUNT: String = ""
    var MSG_GROUP: String = ""
    var NO: String = ""
    var OPEN_COUNT: String = ""
    var POLL_NUM: String = ""
    var RESULT: String = ""
    var SC_CODE: String = ""
    var SC_GRADE: String = ""
    var SC_GROUP: String = ""
    var SC_LOCATION: String = ""
    var SC_LOGO: String = ""
    var SC_NAME: String = ""
    var SEND_TYPE: String = ""
    var SENDER_IP: String = ""
    var SUBJECT: String = ""
    var TARGET_GRADE: String = ""
    var TARGET_CLASS: String = ""
    var WR_SHARE: String = ""
    var WRITER: String = ""
    var LIKE: Bool = false
    
    func SET_ATTACHED(ATTACHED: [ATTACHED_DB]) { self.ATTACHED = ATTACHED }
    func SET_BOARD_CODE(BOARD_CODE: Any) { self.BOARD_CODE = BOARD_CODE as? String ?? "" }
    func SET_BOARD_ID(BOARD_ID: Any) { self.BOARD_ID = BOARD_ID as? String ?? "" }
    func SET_BOARD_KEY(BOARD_KEY: Any) { self.BOARD_KEY = BOARD_KEY as? String ?? "" }
    func SET_BOARD_NAME(BOARD_NAME: Any) { self.BOARD_NAME = BOARD_NAME as? String ?? "" }
    func SET_BOARD_SOURCE(BOARD_SOURCE: Any) { self.BOARD_SOURCE = BOARD_SOURCE as? String ?? "" }
    func SET_BOARD_TYPE(BOARD_TYPE: Any) { self.BOARD_TYPE = BOARD_TYPE as? String ?? "" }
    func SET_CALL_BACK(CALL_BACK: Any) { self.CALL_BACK = CALL_BACK as? String ?? "" }
    func SET_CLASS_INFO(CLASS_INFO: Any) { self.CLASS_INFO = CLASS_INFO as? String ?? "" }
    func SET_CONTENT(CONTENT: Any) { self.CONTENT = CONTENT as? String ?? "" }
    func SET_CONTENT_TEXT(CONTENT_TEXT: Any) { self.CONTENT_TEXT = CONTENT_TEXT as? String ?? "" }
    func SET_CONTENT_TEXT_2(CONTENT_TEXT_2: Any) { self.CONTENT_TEXT_2 = CONTENT_TEXT_2 as? String ?? "" }
    func SET_CONTENT_TYPE(CONTENT_TYPE: Any) { self.CONTENT_TYPE = CONTENT_TYPE as? String ?? "" }
    func SET_DATETIME(DATETIME: Any) { self.DATETIME = DATETIME as? String ?? "" }
    func SET_DST(DST: Any) { self.DST = DST as? String ?? "" }
    func SET_DST_NAME(DST_NAME: Any) { self.DST_NAME = DST_NAME as? String ?? "" }
    func SET_DST_TYPE(DST_TYPE: Any) { self.DST_TYPE = DST_TYPE as? String ?? "" }
    func SET_FCM_KEY(FCM_KEY: Any) { self.FCM_KEY = FCM_KEY as? String ?? "" }
    func SET_FILE_COUNT(FILE_COUNT: Any) { self.FILE_COUNT = FILE_COUNT as? String ?? "" }
    func SET_FROM_FILE(FROM_FILE: Any) { self.FROM_FILE = FROM_FILE as? String ?? "" }
    func SET_IDX(IDX: Any) { self.IDX = IDX as? String ?? "" }
    func SET_INPUT_DATE(INPUT_DATE: Any) { self.INPUT_DATE = INPUT_DATE as? String ?? "" }
    func SET_IS_MODIFY(IS_MODIFY: Any) { self.IS_MODIFY = IS_MODIFY as? String ?? "" }
    func SET_IS_PUSH(IS_PUSH: Any) { self.IS_PUSH = IS_PUSH as? String ?? "" }
    func SET_LIKE_COUNT(LIKE_COUNT: Any) { self.LIKE_COUNT = LIKE_COUNT as? String ?? "" }
    func SET_LIKE_ID(LIKE_ID: Any) { self.LIKE_ID = LIKE_ID as? String ?? "" }
    func SET_ME_LENGTH(ME_LENGTH: Any) { self.ME_LENGTH = ME_LENGTH as? String ?? "" }
    func SET_MEDIA_COUNT(MEDIA_COUNT: Any) { self.MEDIA_COUNT = MEDIA_COUNT as? String ?? "" }
    func SET_MSG_GROUP(MSG_GROUP: Any) { self.MSG_GROUP = MSG_GROUP as? String ?? "" }
    func SET_NO(NO: Any) { self.NO = NO as? String ?? "" }
    func SET_OPEN_COUNT(OPEN_COUNT: Any) { self.OPEN_COUNT = OPEN_COUNT as? String ?? "" }
    func SET_POLL_NUM(POLL_NUM: Any) { self.POLL_NUM = POLL_NUM as? String ?? "" }
    func SET_RESULT(RESULT: Any) { self.RESULT = RESULT as? String ?? "" }
    func SET_SC_CODE(SC_CODE: Any) { self.SC_CODE = SC_CODE as? String ?? "" }
    func SET_SC_GRADE(SC_GRADE: Any) { self.SC_GRADE = SC_GRADE as? String ?? "" }
    func SET_SC_GROUP(SC_GROUP: Any) { self.SC_GROUP = SC_GROUP as? String ?? "" }
    func SET_SC_LOCATION(SC_LOCATION: Any) { self.SC_LOCATION = SC_LOCATION as? String ?? "" }
    func SET_SC_LOGO(SC_LOGO: Any) { self.SC_LOGO = SC_LOGO as? String ?? "" }
    func SET_SC_NAME(SC_NAME: Any) { self.SC_NAME = SC_NAME as? String ?? "" }
    func SET_SEND_TYPE(SEND_TYPE: Any) { self.SEND_TYPE = SEND_TYPE as? String ?? "" }
    func SET_SENDER_IP(SENDER_IP: Any) { self.SENDER_IP = SENDER_IP as? String ?? "" }
    func SET_SUBJECT(SUBJECT: Any) { self.SUBJECT = SUBJECT as? String ?? "" }
    func SET_TARGET_GRADE(TARGET_GRADE: Any) { self.TARGET_GRADE = TARGET_GRADE as? String ?? "" }
    func SET_TARGET_CLASS(TARGET_CLASS: Any) { self.TARGET_CLASS = TARGET_CLASS as? String ?? "" }
    func SET_WR_SHARE(WR_SHARE: Any) { self.WR_SHARE = WR_SHARE as? String ?? "" }
    func SET_WRITER(WRITER: Any) { self.WRITER = WRITER as? String ?? "" }
//    func SET_LIKE(LIKE: Any) { self.LIKE = LIKE as? String ?? "" }
}

// 학교 데이터 (미디어)
public class ATTACHED_DB {
    
    var DATETIME: String = ""
    var FILE_NAME: String = ""
    var FILE_NAME_ORG: String = ""
    var FILE_SIZE: String = ""
    var IDX: String = ""
    var IN_SEQ: String = ""
    var LAT: String = ""
    var LNG: String = ""
    var MEDIA_FILES: String = ""
    var MEDIA_TYPE: String = ""
    var MSG_GROUP: String = ""
    
    func SET_DATETIME(DATETIME: Any) { self.DATETIME = DATETIME as? String ?? "" }
    func SET_FILE_NAME(FILE_NAME: Any) { self.FILE_NAME = FILE_NAME as? String ?? "" }
    func SET_FILE_NAME_ORG(FILE_NAME_ORG: Any) { self.FILE_NAME_ORG = FILE_NAME_ORG as? String ?? "" }
    func SET_FILE_SIZE(FILE_SIZE: Any) { self.FILE_SIZE = FILE_SIZE as? String ?? "" }
    func SET_IDX(IDX: Any) { self.IDX = IDX as? String ?? "" }
    func SET_IN_SEQ(IN_SEQ: Any) { self.IN_SEQ = IN_SEQ as? String ?? "" }
    func SET_LAT(LAT: Any) { self.LAT = LAT as? String ?? "" }
    func SET_LNG(LNG: Any) { self.LNG = LNG as? String ?? "" }
    func SET_MEDIA_FILES(MEDIA_FILES: Any) { self.MEDIA_FILES = MEDIA_FILES as? String ?? "" }
    func SET_MEDIA_TYPE(MEDIA_TYPE: Any) { self.MEDIA_TYPE = MEDIA_TYPE as? String ?? "" }
    func SET_MSG_GROUP(MSG_GROUP: Any) { self.MSG_GROUP = MSG_GROUP as? String ?? "" }
}
