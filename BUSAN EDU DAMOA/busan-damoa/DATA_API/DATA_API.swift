//
//  DATA_API.swift
//  DAMOA
//
//  Created by 장제현 on 2020/04/04.
//  Copyright © 2020 장제현. All rights reserved.
//

import Foundation


// 통신 주소
class DATA_URL {
    
    var SCHOOL_URL = "https://damoaapp.pen.go.kr/conn/"
    var SCHOOL_LOGO_URL = "https://sms.pen.go.kr/files/school_logo/"
    var SCHOOL_LOCATION_URL = "http://damoalbs.pen.go.kr/conn/location/"
    
    var NEW_SCHOOL_URL = "https://dapp.uic.me/conn/"
    var NEW_PROFILE_URL = "https://dapp.uic.me/member_img/"
}


// 로그인 데이터
public class LOGIN_DATA {
    
    var APP_CHECKED: String = ""
    var GCM_ID: String = ""
    var LAST_LOGIN: String = ""
    var LOC_SHARE: String = ""
    var MB_ID: String = ""
    var MB_IMG: String = ""
    var MB_IP: String = ""
    var MB_NAME: String = ""
    var MB_PHONE: String = ""
    var MB_PLATFORM: String = ""
    var MB_TYPE: String = ""
    var REG_DATE: String = ""
    var UUID: String = ""
    
    func SET_APP_CHECKED(APP_CHECKED: Any) { self.APP_CHECKED = APP_CHECKED as? String ?? "" }
    func SET_GCM_ID(GCM_ID: Any) { self.GCM_ID = GCM_ID as? String ?? "" }
    func SET_LAST_LOGIN(LAST_LOGIN: Any) { self.LAST_LOGIN = LAST_LOGIN as? String ?? "" }
    func SET_LOC_SHARE(LOC_SHARE: Any) { self.LOC_SHARE = LOC_SHARE as? String ?? "" }
    func SET_MB_ID(MB_ID: Any) { self.MB_ID = MB_ID as? String ?? "" }
    func SET_MB_IMG(MB_IMG: Any) { self.MB_IMG = MB_IMG as? String ?? "" }
    func SET_MB_IP(MB_IP: Any) { self.MB_IP = MB_IP as? String ?? "" }
    func SET_MB_NAME(MB_NAME: Any) { self.MB_NAME = MB_NAME as? String ?? "" }
    func SET_MB_PHONE(MB_PHONE: Any) { self.MB_PHONE = MB_PHONE as? String ?? "" }
    func SET_MB_PLATFORM(MB_PLATFORM: Any) { self.MB_PLATFORM = MB_PLATFORM as? String ?? "" }
    func SET_MB_TYPE(MB_TYPE: Any) { self.MB_TYPE = MB_TYPE as? String ?? "" }
    func SET_REG_DATE(REG_DATE: Any) { self.REG_DATE = REG_DATE as? String ?? "" }
    func SET_UUID(UUID: Any) { self.UUID = UUID as? String ?? "" }
}


// 학교 목록 (검색)
struct SC_LIST {
    
    var SC_CODE: String = ""
    var SC_GRADE: String = ""
    var SC_GROUP: String = ""
    var SC_LOCATION: String = ""
    var SC_LOGO: String = ""
    var SC_NAME: String = ""
    var SC_ADDRESS: String = ""
}


// 학교 데이터
public class SOSIK_API {
    
    var PAGE: Int = 0
    
    var ATTACHED: [ATTACHED] = []
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
    var END_DATE: String = ""
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
    var SV_INFO: [SV_INFO] = []
    var TARGET_GRADE: String = ""
    var TARGET_CLASS: String = ""
    var WR_SHARE: String = ""
    var WRITER: String = ""
    var LIKE: Bool = false
    
    func SET_ATTACHED(ATTACHED: [ATTACHED]) { self.ATTACHED = ATTACHED }
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
    func SET_END_DATE(END_DATE: Any) { self.END_DATE = END_DATE as? String ?? "" }
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
    func SET_SV_INFO(SV_INFO: [SV_INFO]) { self.SV_INFO = SV_INFO }
    func SET_TARGET_GRADE(TARGET_GRADE: Any) { self.TARGET_GRADE = TARGET_GRADE as? String ?? "" }
    func SET_TARGET_CLASS(TARGET_CLASS: Any) { self.TARGET_CLASS = TARGET_CLASS as? String ?? "" }
    func SET_WR_SHARE(WR_SHARE: Any) { self.WR_SHARE = WR_SHARE as? String ?? "" }
    func SET_WRITER(WRITER: Any) { self.WRITER = WRITER as? String ?? "" }
    func SET_LIKE(LIKE: Any) { self.LIKE = LIKE as? Bool ?? false }
}

// 학교 데이터 (미디어)
public class ATTACHED {
    
    var DATETIME: String = ""
    var DT_FROM: String = ""
    var DOWNLOAD_URL: String = ""
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
    var HTTP_STRING: String = ""
    
    func SET_DATETIME(DATETIME: Any) { self.DATETIME = DATETIME as? String ?? "" }
    func SET_DT_FROM(DT_FROM: Any) { self.DT_FROM = DT_FROM as? String ?? "" }
    func SET_DOWNLOAD_URL(DOWNLOAD_URL: Any) { self.DOWNLOAD_URL = DOWNLOAD_URL as? String ?? "" }
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
    func SET_HTTP_STRING(HTTP_STRING: Any) { self.HTTP_STRING = HTTP_STRING as? String ?? "" }
}

public class SV_INFO {
    
    var END_DATE: String = ""
    var PO_DATE: String = ""
    var PO_ID: String = ""
    var PO_INDEX: String = ""
    var PO_TITLE: String = ""
    var POLL_NUM: String = ""
    var SC_CODE: String = ""
    var SEND_TO: String = ""
    var SENT: String = ""
    
    func SET_END_DATE(END_DATE: Any) { self.END_DATE = END_DATE as? String ?? "" }
    func SET_PO_DATE(PO_DATE: Any) { self.PO_DATE = PO_DATE as? String ?? "" }
    func SET_PO_ID(PO_ID: Any) { self.PO_ID = PO_ID as? String ?? "" }
    func SET_PO_INDEX(PO_INDEX: Any) { self.PO_INDEX = PO_INDEX as? String ?? "" }
    func SET_PO_TITLE(PO_TITLE: Any) { self.PO_TITLE = PO_TITLE as? String ?? "" }
    func SET_POLL_NUM(POLL_NUM: Any) { self.POLL_NUM = POLL_NUM as? String ?? "" }
    func SET_SC_CODE(SC_CODE: Any) { self.SC_CODE = SC_CODE as? String ?? "" }
    func SET_SEND_TO(SEND_TO: Any) { self.SEND_TO = SEND_TO as? String ?? "" }
    func SET_SENT(SENT: Any) { self.SENT = SENT as? String ?? "" }
}


// 학부모연수
public class PARENT_TRAINING {
    
    var END_DAY: String = ""
    var IDX: String = ""
    var IS_PUSH: String = ""
    var START_DAY: String = ""
    var SU_APPLY: String = ""
    var SU_APPLY_END_DAY: String = ""
    var SU_APPLY_END_TIME: String = ""
    var SU_APPLY_START_DAY: String = ""
    var SU_APPLY_START_TIME: String = ""
    var SU_ASK: String = ""
    var SU_CARE: String = ""
    var SU_CARE_PERSON: String = ""
    var SU_EXPLAIN: String = ""
    var SU_FILE: String = ""
    var SU_FROM: String = ""
    var SU_HOW: String = ""
    var SU_MAX: String = ""
    var SU_OPEN: String = ""
    var SU_PEOPLE: String = ""
    var SU_PERIOD: String = ""
    var SU_PERIOD_END_DAY: String = ""
    var SU_PERIOD_END_TIME: String = ""
    var SU_PERIOD_START_DAY: String = ""
    var SU_PERIOD_START_TIME: String = ""
    var SU_PLACE: String = ""
    var SU_ROUTE: String = ""
    var SU_STAUT: String = ""
    var SU_TARGET: String = ""
    var SU_TEA_NAME: String = ""
    var SU_TITLE: String = ""
    var UIDX: String = ""
    
    func SET_END_DAY(END_DAY: Any) { self.END_DAY = END_DAY as? String ?? "" }
    func SET_IDX(IDX: Any) { self.IDX = IDX as? String ?? "" }
    func SET_IS_PUSH(IS_PUSH: Any) { self.IS_PUSH = IS_PUSH as? String ?? "" }
    func SET_START_DAY(START_DAY: Any) { self.START_DAY = START_DAY as? String ?? "" }
    func SET_SU_APPLY(SU_APPLY: Any) { self.SU_APPLY = SU_APPLY as? String ?? "" }
    func SET_SU_APPLY_END_DAY(SU_APPLY_END_DAY: Any) { self.SU_APPLY_END_DAY = SU_APPLY_END_DAY as? String ?? "" }
    func SET_SU_APPLY_END_TIME(SU_APPLY_END_TIME: Any) { self.SU_APPLY_END_TIME = SU_APPLY_END_TIME as? String ?? "" }
    func SET_SU_APPLY_START_DAY(SU_APPLY_START_DAY: Any) { self.SU_APPLY_START_DAY = SU_APPLY_START_DAY as? String ?? "" }
    func SET_SU_APPLY_START_TIME(SU_APPLY_START_TIME: Any) { self.SU_APPLY_START_TIME = SU_APPLY_START_TIME as? String ?? "" }
    func SET_SU_ASK(SU_ASK: Any) { self.SU_ASK = SU_ASK as? String ?? "" }
    func SET_SU_CARE(SU_CARE: Any) { self.SU_CARE = SU_CARE as? String ?? "" }
    func SET_SU_CARE_PERSON(SU_CARE_PERSON: Any) { self.SU_CARE_PERSON = SU_CARE_PERSON as? String ?? "" }
    func SET_SU_EXPLAIN(SU_EXPLAIN: Any) { self.SU_EXPLAIN = SU_EXPLAIN as? String ?? "" }
    func SET_SU_FILE(SU_FILE: Any) { self.SU_FILE = SU_FILE as? String ?? "" }
    func SET_SU_FROM(SU_FROM: Any) { self.SU_FROM = SU_FROM as? String ?? "" }
    func SET_SU_HOW(SU_HOW: Any) { self.SU_HOW = SU_HOW as? String ?? "" }
    func SET_SU_MAX(SU_MAX: Any) { self.SU_MAX = SU_MAX as? String ?? "" }
    func SET_SU_OPEN(SU_OPEN: Any) { self.SU_OPEN = SU_OPEN as? String ?? "" }
    func SET_SU_PEOPLE(SU_PEOPLE: Any) { self.SU_PEOPLE = SU_PEOPLE as? String ?? "" }
    func SET_SU_PERIOD(SU_PERIOD: Any) { self.SU_PERIOD = SU_PERIOD as? String ?? "" }
    func SET_SU_PERIOD_END_DAY(SU_PERIOD_END_DAY: Any) { self.SU_PERIOD_END_DAY = SU_PERIOD_END_DAY as? String ?? "" }
    func SET_SU_PERIOD_END_TIME(SU_PERIOD_END_TIME: Any) { self.SU_PERIOD_END_TIME = SU_PERIOD_END_TIME as? String ?? "" }
    func SET_SU_PERIOD_START_DAY(SU_PERIOD_START_DAY: Any) { self.SU_PERIOD_START_DAY = SU_PERIOD_START_DAY as? String ?? "" }
    func SET_SU_PERIOD_START_TIME(SU_PERIOD_START_TIME: Any) { self.SU_PERIOD_START_TIME = SU_PERIOD_START_TIME as? String ?? "" }
    func SET_SU_PLACE(SU_PLACE: Any) { self.SU_PLACE = SU_PLACE as? String ?? "" }
    func SET_SU_ROUTE(SU_ROUTE: Any) { self.SU_ROUTE = SU_ROUTE as? String ?? "" }
    func SET_SU_STAUT(SU_STAUT: Any) { self.SU_STAUT = SU_STAUT as? String ?? "" }
    func SET_SU_TARGET(SU_TARGET: Any) { self.SU_TARGET = SU_TARGET as? String ?? "" }
    func SET_SU_TEA_NAME(SU_TEA_NAME: Any) { self.SU_TEA_NAME = SU_TEA_NAME as? String ?? "" }
    func SET_SU_TITLE(SU_TITLE: Any) { self.SU_TITLE = SU_TITLE as? String ?? "" }
    func SET_UIDX(UIDX: Any) { self.UIDX = UIDX as? String ?? "" }
}


// 자녀안심 (가족/비콘)
public class FAMILY_BEACON {
    
    //MARK: - 등록된 가족 위치(실시간,이동경로)
    var ACCURACY: String = ""
    var LAT: String = ""
    var LNG: String = ""
    var MB_ID: String = ""
    var MB_NAME: String = ""
    var REG_DATE: String = ""
    
    func SET_ACCURACY(ACCURACY: Any) { self.ACCURACY = ACCURACY as? String ?? "" }
    func SET_LAT(LAT: Any) { self.LAT = LAT as? String ?? "" }
    func SET_LNG(LNG: Any) { self.LNG = LNG as? String ?? "" }
    func SET_MB_ID(MB_ID: Any) { self.MB_ID = MB_ID as? String ?? "" }
    func SET_MB_NAME(MB_NAME: Any) { self.MB_NAME = MB_NAME as? String ?? "" }
    func SET_REG_DATE(REG_DATE: Any) { self.REG_DATE = REG_DATE as? String ?? "" }
    
    //MARK: - 등록된 가족
    var FAMILY_ID: String = ""
    var FAMILY_IMAGE: String = ""
    var FAMILY_NAME: String = ""
    var FAMILY_TYPE: String = ""
    
    func SET_FAMILY_ID(FAMILY_ID: Any) { self.FAMILY_ID = FAMILY_ID as? String ?? "" }
    func SET_FAMILY_IMAGE(FAMILY_IMAGE: Any) { self.FAMILY_IMAGE = FAMILY_IMAGE as? String ?? "" }
    func SET_FAMILY_NAME(FAMILY_NAME: Any) { self.FAMILY_NAME = FAMILY_NAME as? String ?? "" }
    func SET_FAMILY_TYPE(FAMILY_TYPE: Any) { self.FAMILY_TYPE = FAMILY_TYPE as? String ?? "" }
    
    //MARK: - 등록된 조약돌 위치
    var COIN_NAME: String = ""
    var DATETIME: String = ""
    var DEVICE_ADDR: String = ""
    var DEVICE_MAJOR: String = ""
    var DEVICE_MINOR: String = ""
    var IDX: String = ""
//    var MB_ID: String = ""
    var PUSH_TYPE: String = ""
//    var REG_DATE: String = ""
    var SC_CODE: String = ""
    var SC_NAME: String = ""
    var SCANNER_LOCATION: String = ""
    var SCANNER_MAC: String = ""
    
    func SET_COIN_NAME(COIN_NAME: Any) { self.COIN_NAME = COIN_NAME as? String ?? "" }
    func SET_DATETIME(DATETIME: Any) { self.DATETIME = DATETIME as? String ?? "" }
    func SET_DEVICE_ADDR(DEVICE_ADDR: Any) { self.DEVICE_ADDR = DEVICE_ADDR as? String ?? "" }
    func SET_DEVICE_MAJOR(DEVICE_MAJOR: Any) { self.DEVICE_MAJOR = DEVICE_MAJOR as? String ?? "" }
    func SET_DEVICE_MINOR(DEVICE_MINOR: Any) { self.DEVICE_MINOR = DEVICE_MINOR as? String ?? "" }
    func SET_IDX(IDX: Any) { self.IDX = IDX as? String ?? "" }
//    func SET_MB_ID(MB_ID: Any) { self.MB_ID = MB_ID as? String ?? "" }
    func SET_PUSH_TYPE(PUSH_TYPE: Any) { self.PUSH_TYPE = PUSH_TYPE as? String ?? "" }
//    func SET_REG_DATE(REG_DATE: Any) { self.REG_DATE = REG_DATE as? String ?? "" }
    func SET_SC_CODE(SC_CODE: Any) { self.SC_CODE = SC_CODE as? String ?? "" }
    func SET_SC_NAME(SC_NAME: Any) { self.SC_NAME = SC_NAME as? String ?? "" }
    func SET_SCANNER_LOCATION(SCANNER_LOCATION: Any) { self.SCANNER_LOCATION = SCANNER_LOCATION as? String ?? "" }
    func SET_SCANNER_MAC(SCANNER_MAC: Any) { self.SCANNER_MAC = SCANNER_MAC as? String ?? "" }
}


// 자녀안심 (WEE센터)
public class WEECENTER_DATA {
    
    var SC_NAME: String = ""
    var CENTER_ADDRESS: String = ""
    var CENTER_LAT: String = ""
    var CENTER_LNG: String = ""
    var CENTER_NUM: String = ""
    var CENTER_NAME: String = ""
    
    func SET_SC_NAME(SC_NAME: Any) { self.SC_NAME = SC_NAME as? String ?? "" }
    func SET_CENTER_ADDRESS(CENTER_ADDRESS: Any) { self.CENTER_ADDRESS = CENTER_ADDRESS as? String ?? "" }
    func SET_CENTER_LAT(CENTER_LAT: Any) { self.CENTER_LAT = CENTER_LAT as? String ?? "" }
    func SET_CENTER_LNG(CENTER_LNG: Any) { self.CENTER_LNG = CENTER_LNG as? String ?? "" }
    func SET_CENTER_NUM(CENTER_NUM: Any) { self.CENTER_NUM = CENTER_NUM as? String ?? "" }
    func SET_CENTER_NAME(CENTER_NAME: Any) { self.CENTER_NAME = CENTER_NAME as? String ?? "" }
}


// 학교 및 교육기관 안내
struct OFFICE_LIST {
    
    var IDX: String = ""
    var SC_ADDRESS: String = ""
    var SC_CODE: String = ""
    var SC_HOMEPAGE: String = ""
    var SC_NAME: String = ""
    var SC_TEL: String = ""
    var SC_TYPE: String = ""
}


public class CLASS_DATA {
    
    var CL_CODE: String = ""
    var CL_GRADE: String = ""
    var CL_NAME: String = ""
    var CL_NO: String = ""
    var CLASS_NAME: String = ""
    var IDX: String = ""
    var SC_CODE: String = ""
    var SC_GRADE: String = ""
    var SC_GROUP: String = ""
    var SC_LOCATION: String = ""
    var SC_LOGO: String = ""
    var SC_NAME: String = ""
    var SYS_ID: String = ""
    
    func SET_CL_CODE(CL_CODE: Any) { self.CL_CODE = CL_CODE as? String ?? "" }
    func SET_CL_GRADE(CL_GRADE: Any) { self.CL_GRADE = CL_GRADE as? String ?? "" }
    func SET_CL_NAME(CL_NAME: Any) { self.CL_NAME = CL_NAME as? String ?? "" }
    func SET_CL_NO(CL_NO: Any) { self.CL_NO = CL_NO as? String ?? "" }
    func SET_CLASS_NAME(CLASS_NAME: Any) { self.CLASS_NAME = CLASS_NAME as? String ?? "" }
    func SET_IDX(IDX: Any) { self.IDX = IDX as? String ?? "" }
    func SET_SC_CODE(SC_CODE: Any) { self.SC_CODE = SC_CODE as? String ?? "" }
    func SET_SC_GRADE(SC_GRADE: Any) { self.SC_GRADE = SC_GRADE as? String ?? "" }
    func SET_SC_GROUP(SC_GROUP: Any) { self.SC_GROUP = SC_GROUP as? String ?? "" }
    func SET_SC_LOCATION(SC_LOCATION: Any) { self.SC_LOCATION = SC_LOCATION as? String ?? "" }
    func SET_SC_LOGO(SC_LOGO: Any) { self.SC_LOGO = SC_LOGO as? String ?? "" }
    func SET_SC_NAME(SC_NAME: Any) { self.SC_NAME = SC_NAME as? String ?? "" }
    func SET_SYS_ID(SYS_ID: Any) { self.SYS_ID = SYS_ID as? String ?? "" }
}


public class SEARCH_SOSIK_API {
    
    var LAT: Double = 0.0
    var LNG: Double = 0.0
    var PLACE_NAME: String = ""
    var PLACE_ADDRESS: String = ""
    
    func SET_LAT(LAT: Any) { self.LAT = LAT as? Double ?? 0.0 }
    func SET_LNG(LNG: Any) { self.LNG = LNG as? Double ?? 0.0 }
    func SET_PLACE_NAME(PLACE_NAME: Any) { self.PLACE_NAME = PLACE_NAME as? String ?? "" }
    func SET_PLACE_ADDRESS(PLACE_ADDRESS: Any) { self.PLACE_ADDRESS = PLACE_ADDRESS as? String ?? "" }
}
