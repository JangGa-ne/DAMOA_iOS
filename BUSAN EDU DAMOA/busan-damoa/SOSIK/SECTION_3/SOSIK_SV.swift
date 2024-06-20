//
//  SOSIK_SV.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/05/14.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

// 설문조사
class SOSIK_SV: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    var SOSIK_LIST: [SOSIK_API] = []
    
    var FETCHING_MORE = false
    var PAGE_NUMBER: Int = 0
    var ITEM_COUNT: Int = 20
    
    var BOARD_KEY: [String] = []
    var LIKE: [String] = []
    
    @IBOutlet weak var NAVI_TITLE: UILabel!
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    // 로딩인디케이터
    let VIEW = UIView()
    override func loadView() {
        super.loadView()
        
        UIViewController.APPDELEGATE.SV_CHECK = false
        
        EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "Logo.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
        CHECK_VERSION(NAVI_TITLE)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.APPDELEGATE.SOSIK_SV_VC = self
        
        NAVI_TITLE.alpha = 0.0
        
        //MARK: 네트워크 연결 확인
        NETWORK_CHECK()
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.delegate = self
        TABLEVIEW.dataSource = self
        TABLEVIEW.backgroundColor = .GRAY_F1F1F1
    }
    
    //MARK: 네트워크 연결 확인
    @objc func NETWORK_CHECK() {
        
        // 데이터 삭제
        SOSIK_LIST.removeAll(); PAGE_NUMBER = 0; TABLEVIEW.reloadData()
        
        if SYSTEM_NETWORK_CHECKING() {
            GET_POST_DATA(NAME: "설문조사", BOARD_TYPE: "SV", LIMIT_START: 0)
        } else {
            NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
            DispatchQueue.main.async {
                let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                ALERT.addAction(UIAlertAction(title: "새로고침", style: .default) { (_) in self.NETWORK_CHECK() })
                self.present(ALERT, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: 소식 불러오기
    func GET_POST_DATA(NAME: String, BOARD_TYPE: String, LIMIT_START: Int) {
        
        PUSH_BADGE(BOARD_TYPE: BOARD_TYPE, false)
        
        let POST_URL: String = DATA_URL().SCHOOL_URL + "message/school_sosik.php"
        var PARAMETERS: Parameters = [
            "mb_id": UIViewController.USER_DATA.string(forKey: "mb_id") ?? "",
            "limit_start": LIMIT_START,
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
            print(response)
            
            switch response.result {
            case .success(_):
                
                let DATA_DICT = response.result.value as? [String: Any]
                if self.SOSIK_LIST.count != 0 {
                    if DATA_DICT?["result"] as? String ?? "" == "none" {
                        UINotificationFeedbackGenerator().notificationOccurred(.error)
                        self.ALERT(TITLE: nil, BODY: "더 이상 불러올 설문조사가 없습니다.", STYLE: .actionSheet)
                    }
                }
                
                guard let DATA_ARRAY = response.result.value as? Array<Any> else {
                    print("FAILURE: ")
//                    self.RF_CONTROL.endRefreshing()
                    self.TABLEVIEW.reloadData()
                    self.CLOSE_EFFECT_INDICATOR_VIEW(VIEW: self.VIEW)
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
                    APPEND_VALUE.SET_SV_INFO(SV_INFO: self.SET_SV_INFO_DATA(SV_INFO_ARRAY: DATA_DICT?["sv_info"] as? [Any] ?? []))
                    APPEND_VALUE.SET_TARGET_GRADE(TARGET_GRADE: DATA_DICT?["tagret_grade"] as Any)
                    APPEND_VALUE.SET_TARGET_CLASS(TARGET_CLASS: DATA_DICT?["target_class"] as Any)
                    APPEND_VALUE.SET_WR_SHARE(WR_SHARE: DATA_DICT?["wr_share"] as Any)
                    APPEND_VALUE.SET_WRITER(WRITER: DATA_DICT?["writer"] as Any)
                    // 데이터 추가
                    self.SOSIK_LIST.append(APPEND_VALUE)
                    self.TABLEVIEW.reloadData()
                }
                // DB 불러오기
                self.SCRAP_CHECK(BOARD_TYPE: BOARD_TYPE)
                self.TABLEVIEW.reloadData()
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.NOTIFICATION_VIEW("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.NOTIFICATION_VIEW("E: 네트워크 연결 실패 (000)"); self.NETWORK_CHECK() }
                
                self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
            }
            
            self.FETCHING_MORE = false
//            self.RF_CONTROL.endRefreshing()
            self.CLOSE_EFFECT_INDICATOR_VIEW(VIEW: self.VIEW)
        })
    }
    
    // 설문조사
    func SET_SV_INFO_DATA(SV_INFO_ARRAY: [Any]) -> [SV_INFO] {
        
        var SV_INFO_API: [SV_INFO] = []
        
        for (_, DATA) in SV_INFO_ARRAY.enumerated() {
            
            let DATADICT = DATA as? [String: Any]
            
            let POST_SV_INFO = SV_INFO()
            
            POST_SV_INFO.SET_END_DATE(END_DATE: DATADICT?["end_date"] as Any)
            POST_SV_INFO.SET_PO_DATE(PO_DATE: DATADICT?["po_date"] as Any)
            POST_SV_INFO.SET_PO_ID(PO_ID: DATADICT?["po_id"] as Any)
            POST_SV_INFO.SET_PO_INDEX(PO_INDEX: DATADICT?["po_index"] as Any)
            POST_SV_INFO.SET_POLL_NUM(POLL_NUM: DATADICT?["poll_num"] as Any)
            POST_SV_INFO.SET_SC_CODE(SC_CODE: DATADICT?["sc_code"] as Any)
            POST_SV_INFO.SET_SEND_TO(SEND_TO: DATADICT?["send_to"] as Any)
            POST_SV_INFO.SET_SENT(SENT: DATADICT?["sent"] as Any)
            
            SV_INFO_API.append(POST_SV_INFO)
        }
        
        return SV_INFO_API
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        let CONTENT_HEIGHT = scrollView.contentSize.height
        
        // 내비게이션바
        if OFFSET_Y >= 0 { NAVI_TITLE.alpha = OFFSET_Y/20 } else { NAVI_TITLE.alpha = 0.0 }
        
        // 추가 데이터 불러오기
        if OFFSET_Y > CONTENT_HEIGHT - scrollView.frame.height && OFFSET_Y > 0 {
            if !FETCHING_MORE { BEGINBATCHFETCH() }
        }
    }
    
    func BEGINBATCHFETCH() {
        
        FETCHING_MORE = true
        PAGE_NUMBER = PAGE_NUMBER + 1
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            
            if self.SYSTEM_NETWORK_CHECKING() {
                self.GET_POST_DATA(NAME: "설문조사", BOARD_TYPE: "SV", LIMIT_START: self.PAGE_NUMBER * self.ITEM_COUNT)
            } else {
                self.NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
            }
        })
    }
}

extension SOSIK_SV: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SOSIK_LIST.count == 0 { return 1 } else { return SOSIK_LIST.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        if SOSIK_LIST.count == 0 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SOSIK_TC_NONE", for: indexPath) as! SOSIK_TC
            
            return CELL
        } else {
        
            let DATA = SOSIK_LIST[indexPath.item]
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SOSIK_TC", for: indexPath) as! SOSIK_TC
                
            CELL.DETAIL = false
            // 프로토콜 연결
            CELL.PROTOCOL = self
            // 데이터 넘김
            CELL.SOSIK_LIST = SOSIK_LIST
            CELL.SOSIK_POSITION = indexPath.item
            
            CELL.CT_VIEW.layer.cornerRadius = 20.0
            CELL.CT_VIEW.clipsToBounds = true
            // 타입
            if DATA.BOARD_NAME != "" { CELL.BOARD_TYPE.text = DATA.BOARD_NAME }
            // 학교이름
            if DATA.SC_NAME != "" { CELL.SC_NAME.text = DATA.SC_NAME }
            // 학교로고
            CELL.SC_LOGO.layer.cornerRadius = 20.0
            CELL.SC_LOGO.clipsToBounds = true
            if !(DATA.SC_LOGO == "" || DATA.SC_LOGO == "Y") {
                let IMAGE_URL = "https://sms.pen.go.kr/files/school_logo/\(DATA.SC_LOGO)"
                NUKE(IMAGE_URL: IMAGE_URL, PLACEHOLDER: UIImage(named: "school_logo.png")!, PROFILE: CELL.SC_LOGO, FRAME_VIEW: CELL.SC_LOGO, SCALE: .scaleAspectFit)
            } else {
                let IMAGE_URL = "https://sms.pen.go.kr/files/school_logo/\(DATA.SC_CODE)"
                NUKE(IMAGE_URL: IMAGE_URL, PLACEHOLDER: UIImage(named: "school_logo.png")!, PROFILE: CELL.SC_LOGO, FRAME_VIEW: CELL.SC_LOGO, SCALE: .scaleAspectFit)
            }
            
            // 제목
            CELL.CT_TITLE.text = ENCODE(DATA.SUBJECT)
            // 내용
            if DATA.CONTENT_TEXT_2 == "" {
                CELL.CT_CONTENT.isHidden = true
            } else {
                CELL.CT_CONTENT.isHidden = false
                CELL.CT_CONTENT.attributedText = LINE_SPACING(TEXT: HTML_STRING(DATA.CONTENT_TEXT_2) ?? "", LINE_SPACING: 5.0)
            }
            
            // 날짜
            if DATA.SV_INFO.count != 0 {
                CELL.DATETIME.text = "설문조사 기한 ~\(FORMAT_DATETIME(DATA.DATETIME))까지"
            }
            CELL.SURVEY_VC.setTitleColor(.systemBlue, for: .normal)
            CELL.SURVEY_VC.layer.borderColor = UIColor.systemBlue.cgColor
            CELL.SURVEY_VC.layer.borderWidth = 1.0
            CELL.SURVEY_VC.layer.cornerRadius = 17.5
            CELL.SURVEY_VC.clipsToBounds = true
            CELL.SURVEY_VC.tag = indexPath.item
            CELL.SURVEY_VC.addTarget(self, action: #selector(SURVEY_VC(_:)), for: .touchUpInside)
            
            return CELL
        }
    }
    
    @objc func SURVEY_VC(_ sender: UIButton) {
        
        if SOSIK_LIST.count != 0 {
        
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "DETAIL_SOSIK") as! DETAIL_SOSIK
            VC.modalTransitionStyle = .crossDissolve
            VC.PUSH = false
            VC.SOSIK_LIST = SOSIK_LIST
            VC.SOSIK_POSITION = sender.tag
            present(VC, animated: true, completion: nil)
        }
    }
}
