//
//  SOSIK_S.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2021/01/15.
//

import UIKit
import Alamofire
import CVCalendar

class SOSIK_S: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    let TRANSITION = SLIDE_IN_TRANSITION()
    
    var NO_DATA: Bool = false
    var SOSIK_LIST: [SOSIK_API] = []
    
    var CD_DATETIME: [String] = []
    var CD_SC_NAME: [String] = []
    var CD_SUBJECT: [String] = []
    var CD_POSITION: [Int] = []
    var CD_SHOW_DATA: [Bool] = []
    
    let DATE_FORMATTER = DateFormatter()
    
    // 내비게이션바
    @IBOutlet weak var NAVI_BG: UIView!
    @IBOutlet weak var NAVI_VIEW: UIView!
    @IBOutlet weak var NAVI_TITLE: UILabel!
    // 테이블뷰
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    // 캘린더
    var ANIMATION_FINISHED: Bool = true
    var CURRENT_CALENDAR: Calendar?
    
    @IBOutlet weak var MONTH: UILabel!
    @IBOutlet weak var CALENDARVIEW: CVCalendarView!
    
    // 오늘
    @IBAction func TODAY(_ sender: UIButton) {
        CALENDARVIEW.toggleCurrentDayView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.APPDELEGATE.SOSIK_S_VC = self
        
        // 내비게이션바
        NAVI_TITLE.alpha = 0.0
        
        // 달력 날짜 포맷
        DATE_FORMATTER.dateFormat = "yyyyMM"
        // 네트워크 연결 확인
        NETWORK_CHECK(MONTH: DATE_FORMATTER.string(from: Date()))
        
        // 테이블뷰 연결
        TABLEVIEW.delegate = self
        TABLEVIEW.dataSource = self
        TABLEVIEW.separatorStyle = .none
        
        // 캘린더 연결
        CALENDARVIEW.delegate = self
        
        if let CURRENT_CALENDAR = CURRENT_CALENDAR {
            MONTH.text = CVDate(date: Date(), calendar: CURRENT_CALENDAR).globalDescription
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        CALENDARVIEW.toggleCurrentDayView()
    }
    
    // 네트워크 연결 확인
    @objc func NETWORK_CHECK(MONTH: String) {
        
        // 로딩 화면
        ON_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR, "데이터 불러오는 중...")
        
        // 데이터 삭제
        SOSIK_LIST.removeAll(); TABLEVIEW.reloadData()
        
        if SYSTEM_NETWORK_CHECKING() {
            GET_POST_DATA(NAME: "학사일정", BOARD_TYPE: "S", MONTH: MONTH)
        } else {
            VIEW_NOTICE("N: 네트워크 상태를 확인해 주세요")
            DispatchQueue.main.async {
                let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                ALERT.addAction(UIAlertAction(title: "새로고침", style: .default) { (_) in self.NETWORK_CHECK(MONTH: MONTH) })
                self.present(ALERT, animated: true, completion: nil)
            }
        }
    }
    
    func GET_POST_DATA(NAME: String, BOARD_TYPE: String, MONTH: String) {
        
        PUSH_BADGE(BOARD_TYPE: BOARD_TYPE, false)
        
        let POST_URL: String = DATA_URL().SCHOOL_URL + "message/school_sosik.php"
        var PARAMETERS: Parameters = [
            "board_type": BOARD_TYPE,
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "month": MONTH
        ]
        
        var SC_CODE: [String] = []
        for RECORD in UIViewController.APPDELEGATE.ENROLL_LIST { SC_CODE.append(RECORD.value(forKey: "sc_code") as? String ?? "") }
        for i in 0 ..< UNIQ(SOURCE: SC_CODE).count { if UNIQ(SOURCE: SC_CODE)[i] != "" { PARAMETERS["sc_code[\(i)]"] = UNIQ(SOURCE: SC_CODE)[i] } }
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 30.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseJSON(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
//            print(response)
            
            switch response.result {
            case .success(_):
                
                guard let DATA_ARRAY = response.result.value as? Array<Any> else {
                    print("FAIL: ")
                    self.TABLEVIEW.reloadData()
                    self.OFF_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR)
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
                    APPEND_VALUE.SET_IDX(IDX: DATA_DICT?["idx"] as Any)
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
                    self.SOSIK_LIST.append(APPEND_VALUE)
                    self.TABLEVIEW.reloadData()
                }
                
                // 데이터 삭제
                self.CD_DATETIME.removeAll()
                self.CD_SHOW_DATA.removeAll()
                // 데이터 새로고침
                self.CALENDARVIEW.contentController.refreshPresentedMonth()
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.VIEW_NOTICE("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.VIEW_NOTICE("E: 네트워크 연결 실패 (000)"); self.NETWORK_CHECK(MONTH: MONTH) }
                
                self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
            }
            
            self.OFF_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR)
        })
    }
}

extension SOSIK_S: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        
        if OFFSET_Y >= 0 {
            // 내비게이션바
            NAVI_TITLE.alpha = OFFSET_Y/20
        } else {
            // 내비게이션바
            NAVI_TITLE.alpha = 0.0
        }
    }
}

extension SOSIK_S: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if CD_DATETIME.count == 0 {
            if CD_SHOW_DATA.count == 0 {
                if SOSIK_LIST.count == 0 { NO_DATA = true; return 1 } else { NO_DATA = false; return SOSIK_LIST.count }
            } else {
                NO_DATA = true; return 1
            }
        } else {
            NO_DATA = false; return CD_DATETIME.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if NO_DATA || SOSIK_LIST.count == 0 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SOSIK_TC_NONE", for: indexPath) as! SOSIK_TC
            
            return CELL
        } else {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SOSIK_TC", for: indexPath) as! SOSIK_TC
            
            CELL.CT_VIEW.layer.cornerRadius = 10.0
            CELL.CT_VIEW.clipsToBounds = true
            
            if CD_DATETIME.count == 0 {
                
                let DATA = SOSIK_LIST[indexPath.item]
                
                // 날짜
                CELL.DATETIME.text = FORMAT_DATETIME(DATA.DATETIME)
                // 학교이름
                if DATA.SC_NAME != "" { CELL.SC_NAME.text = DATA.SC_NAME }
                // 제목
                CELL.CT_TITLE.text = ENCODE(DATA.SUBJECT)
            } else {
                
                // 날짜
                CELL.DATETIME.text = FORMAT_DATETIME(CD_DATETIME[indexPath.item])
                // 학교이름
                if CD_SC_NAME.count != 0 { CELL.SC_NAME.text = CD_SC_NAME[indexPath.item] }
                // 제목
                CELL.CT_TITLE.text = ENCODE(CD_SUBJECT[indexPath.item])
            }
            
            return CELL
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !(NO_DATA || SOSIK_LIST.count == 0) {

            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SUBMIT_EVENT") as! SUBMIT_EVENT
            VC.modalPresentationStyle = .overCurrentContext
            VC.transitioningDelegate = self
            VC.SOSIK_LIST = SOSIK_LIST
            if CD_DATETIME.count == 0 {
                VC.SOSIK_POSITION = indexPath.item
            } else {
                VC.SOSIK_POSITION = CD_POSITION[indexPath.item]
            }
            present(VC, animated: true, completion: nil)
        }
    }
}
