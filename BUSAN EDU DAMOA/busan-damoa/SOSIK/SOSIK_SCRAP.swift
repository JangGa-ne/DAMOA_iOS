//
//  SOSIK_SCRAP.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/28.
//

import UIKit
import SQLite3

//MARK: - 소식 보관함
class SOSIK_SCRAP: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var NO_DATA: Bool = false
    var SOSIK_LIST: [SOSIK_API] = []
    
    var FETCHING_MORE = false
    var PAGE_NUMBER: Int = 0
    var ITEM_COUNT: Int = 20
    
    var BOARD_KEY: [String] = []
    var LIKE: [String] = []
    
    // 내비게이션바
    @IBOutlet weak var NAVI_BG: UIView!
    @IBOutlet weak var NAVI_VIEW: UIView!
    @IBOutlet weak var NAVI_TITLE: UILabel!
    // 테이블뷰
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로딩 화면
        ON_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR, "데이터 불러오는 중...")
        
        // 내비게이션바
        NAVI_TITLE.alpha = 0.0
        
        // 테이블뷰 연결
        TABLEVIEW.delegate = self
        TABLEVIEW.dataSource = self
        TABLEVIEW.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 네트워크 연결 확인
        NETWORK_CHECK()
    }
    
    // 네트워크 연결 확인
    @objc func NETWORK_CHECK() {
        
        // 데이터 삭제
        SOSIK_LIST.removeAll(); PAGE_NUMBER = 0; TABLEVIEW.reloadData()
        
        if SYSTEM_NETWORK_CHECKING() {
            GET_POST_DATA(NAME: "스크랩표시한소식", ACTION_TYPE: "")
        } else {
            VIEW_NOTICE("N: 네트워크 상태를 확인해 주세요")
            DispatchQueue.main.async {
                let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                ALERT.addAction(UIAlertAction(title: "새로고침", style: .default) { (_) in self.NETWORK_CHECK() })
                self.present(ALERT, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - 소식
    func GET_POST_DATA(NAME: String, ACTION_TYPE: String) {
        
        // 데이터 삭제
        SOSIK_LIST.removeAll()
        
        // DB 열기
        UIViewController.APPDELEGATE.OPEN_DB_MAIN()
        
        let POST_SQL: String = "SELECT * FROM SCHOOL_DB ORDER BY DATETIME DESC"
        let SC_SCRAP_SQL = UIViewController.APPDELEGATE.SQL_SCHOOL
        
        if sqlite3_prepare(SC_SCRAP_SQL.DB, POST_SQL, -1, &SC_SCRAP_SQL.STMT, nil) != SQLITE_OK {
            
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(SC_SCRAP_SQL.DB))
            print("[소식] ERROR PREPARING SELECT: \(ERROR_MESSAGE)")
            return
        }
        
        while sqlite3_step(SC_SCRAP_SQL.STMT) == SQLITE_ROW {
            
            let APPEND_VALUE = SOSIK_API()
            
            APPEND_VALUE.SET_ATTACHED(ATTACHED: self.SET_ATTACHED_DATA(SC_SCRAP_SQL: SC_SCRAP_SQL))
            APPEND_VALUE.SET_BOARD_CODE(BOARD_CODE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 0)) as Any)
            APPEND_VALUE.SET_BOARD_ID(BOARD_ID: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 1)) as Any)
            APPEND_VALUE.SET_BOARD_KEY(BOARD_KEY: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 2)) as Any)
            APPEND_VALUE.SET_BOARD_NAME(BOARD_NAME: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 3)) as Any)
            APPEND_VALUE.SET_BOARD_SOURCE(BOARD_SOURCE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 4)) as Any)
            APPEND_VALUE.SET_BOARD_TYPE(BOARD_TYPE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 5)) as Any)
            APPEND_VALUE.SET_CALL_BACK(CALL_BACK: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 6)) as Any)
            APPEND_VALUE.SET_CLASS_INFO(CLASS_INFO: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 7)) as Any)
            APPEND_VALUE.SET_CONTENT(CONTENT: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 8)) as Any)
            APPEND_VALUE.SET_CONTENT_TEXT(CONTENT_TEXT: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 9)) as Any)
            APPEND_VALUE.SET_CONTENT_TYPE(CONTENT_TYPE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 10)) as Any)
            APPEND_VALUE.SET_DATETIME(DATETIME: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 11)) as Any)
            APPEND_VALUE.SET_DST(DST: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 12)) as Any)
            APPEND_VALUE.SET_DST_NAME(DST_NAME: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 13)) as Any)
            APPEND_VALUE.SET_DST_TYPE(DST_TYPE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 14)) as Any)
            APPEND_VALUE.SET_FCM_KEY(FCM_KEY: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 15)) as Any)
            APPEND_VALUE.SET_FILE_COUNT(FILE_COUNT: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 16)) as Any)
            APPEND_VALUE.SET_FROM_FILE(FROM_FILE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 17)) as Any)
            APPEND_VALUE.SET_IDX(IDX: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 18)) as Any)
            APPEND_VALUE.SET_INPUT_DATE(INPUT_DATE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 19)) as Any)
            APPEND_VALUE.SET_IS_MODIFY(IS_MODIFY: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 20)) as Any)
            APPEND_VALUE.SET_IS_PUSH(IS_PUSH: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 21)) as Any)
            APPEND_VALUE.SET_LIKE_COUNT(LIKE_COUNT: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 22)) as Any)
            APPEND_VALUE.SET_LIKE_ID(LIKE_ID: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 23)) as Any)
            APPEND_VALUE.SET_ME_LENGTH(ME_LENGTH: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 24)) as Any)
            APPEND_VALUE.SET_MEDIA_COUNT(MEDIA_COUNT: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 25)) as Any)
            APPEND_VALUE.SET_MSG_GROUP(MSG_GROUP: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 26)) as Any)
            APPEND_VALUE.SET_NO(NO: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 27)) as Any)
            APPEND_VALUE.SET_OPEN_COUNT(OPEN_COUNT: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 28)) as Any)
            APPEND_VALUE.SET_POLL_NUM(POLL_NUM: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 29)) as Any)
            APPEND_VALUE.SET_RESULT(RESULT: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 30)) as Any)
            APPEND_VALUE.SET_SC_CODE(SC_CODE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 31)) as Any)
            APPEND_VALUE.SET_SC_GRADE(SC_GRADE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 32)) as Any)
            APPEND_VALUE.SET_SC_GROUP(SC_GROUP: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 33)) as Any)
            APPEND_VALUE.SET_SC_LOCATION(SC_LOCATION: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 34)) as Any)
            APPEND_VALUE.SET_SC_LOGO(SC_LOGO: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 35)) as Any)
            APPEND_VALUE.SET_SC_NAME(SC_NAME: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 36)) as Any)
            APPEND_VALUE.SET_SEND_TYPE(SEND_TYPE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 37)) as Any)
            APPEND_VALUE.SET_SENDER_IP(SENDER_IP: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 38)) as Any)
            APPEND_VALUE.SET_SUBJECT(SUBJECT: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 39)) as Any)
            APPEND_VALUE.SET_TARGET_GRADE(TARGET_GRADE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 40)) as Any)
            APPEND_VALUE.SET_TARGET_CLASS(TARGET_CLASS: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 41)) as Any)
            APPEND_VALUE.SET_WR_SHARE(WR_SHARE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 42)) as Any)
            APPEND_VALUE.SET_WRITER(WRITER: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 43)) as Any)
            APPEND_VALUE.SET_LIKE(LIKE: Bool(String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 44))) as Any)
            // 데이터 추가
            self.SOSIK_LIST.append(APPEND_VALUE)
            self.TABLEVIEW.reloadData()
        }
       
        self.OFF_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR)
    }
    
    //MARK: - 소식 (미디어)
    func SET_ATTACHED_DATA(SC_SCRAP_SQL: SQLITE_DAMOA) -> [ATTACHED] {
        
        var ATTACHED_LIST: [ATTACHED] = []
        
        let ATTACHED_ARRAY = String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 55)).components(separatedBy: "|")
        
        for i in 0 ..< ATTACHED_ARRAY.count-1 {
            
            let APPEND_VALUE = ATTACHED()
            
            APPEND_VALUE.SET_DATETIME(DATETIME: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 45)).components(separatedBy: "|")[i] as Any)
            APPEND_VALUE.SET_DT_FROM(DT_FROM: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 46)).components(separatedBy: "|")[i] as Any)
            APPEND_VALUE.SET_FILE_NAME(FILE_NAME: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 47)).components(separatedBy: "|")[i] as Any)
            APPEND_VALUE.SET_FILE_NAME_ORG(FILE_NAME_ORG: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 48)).components(separatedBy: "|")[i] as Any)
            APPEND_VALUE.SET_FILE_SIZE(FILE_SIZE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 49)).components(separatedBy: "|")[i] as Any)
            APPEND_VALUE.SET_IDX(IDX: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 50)).components(separatedBy: "|")[i] as Any)
            APPEND_VALUE.SET_IN_SEQ(IN_SEQ: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 51)).components(separatedBy: "|")[i] as Any)
            APPEND_VALUE.SET_LAT(LAT: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 52)).components(separatedBy: "|")[i] as Any)
            APPEND_VALUE.SET_LNG(LNG: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 53)).components(separatedBy: "|")[i] as Any)
            APPEND_VALUE.SET_MEDIA_FILES(MEDIA_FILES: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 54)).components(separatedBy: "|")[i] as Any)
            APPEND_VALUE.SET_MEDIA_TYPE(MEDIA_TYPE: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 55)).components(separatedBy: "|")[i] as Any)
            APPEND_VALUE.SET_MSG_GROUP(MSG_GROUP: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 56)).components(separatedBy: "|")[i] as Any)
            APPEND_VALUE.SET_HTTP_STRING(HTTP_STRING: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 57)).components(separatedBy: "|")[i] as Any)
//            APPEND_VALUE.SET_DOWNLOAD_URL(DOWNLOAD_URL: String(cString: sqlite3_column_text(SC_SCRAP_SQL.STMT, 58)).components(separatedBy: "|")[i] as Any)
            
            ATTACHED_LIST.append(APPEND_VALUE)
        }
        
        return ATTACHED_LIST
    }
}

extension SOSIK_SCRAP: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        let CONTENT_HEIGHT = scrollView.contentSize.height
        
        if OFFSET_Y >= 0 {
            // 내비게이션바
            NAVI_TITLE.alpha = OFFSET_Y/20
        } else {
            // 내비게이션바
            NAVI_TITLE.alpha = 0.0
        }
        
        if OFFSET_Y > CONTENT_HEIGHT - scrollView.frame.height && OFFSET_Y > 0 {
            if !FETCHING_MORE { BEGINBATCHFETCH() }
        }
    }
    
    func BEGINBATCHFETCH() {
        
        FETCHING_MORE = true
        PAGE_NUMBER = PAGE_NUMBER + 1
        
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            
            if self.SYSTEM_NETWORK_CHECKING() {
                self.GET_POST_DATA(NAME: "스크랩", ACTION_TYPE: "")
            } else {
                self.VIEW_NOTICE("N: 네트워크 상태를 확인해 주세요")
            }
        })
    }
}

extension SOSIK_SCRAP: UITableViewDelegate, UITableViewDataSource {
    
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
            
            // 데이터 넘김
            CELL.SOSIK_LIST = SOSIK_LIST
            CELL.SOSIK_POSITION = indexPath.item
            // 프로토콜 연결
            CELL.PROTOCOL = self
            
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
            // 타입
            if DATA.BOARD_NAME != "" { CELL.BOARD_TYPE.text = DATA.BOARD_NAME }
            // 학교이름
            if DATA.SC_NAME != "" { CELL.SC_NAME.text = DATA.SC_NAME }
            
            // 메뉴
            CELL.SR_MENU.tag = indexPath.item
            CELL.SR_MENU.addTarget(self, action: #selector(MENU(_:)), for: .touchUpInside)
            
            return CELL
        }
    }
    
    //MARK: - 삭제/공유
    @objc func MENU(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ALERT.addAction(UIAlertAction(title: "보관된 소식 삭제", style: .default) { (_) in
            
            let ALERT = UIAlertController(title: "", message: "항목을 저장 취소하면 항목이 추가된 모든 컬렉션에서도 삭제됩니다.", preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            ALERT.addAction(UIAlertAction(title: "삭제", style: .destructive) { (_) in
                // 데이터 삭제
                UIViewController.APPDELEGATE.DELETE_DB_MAIN(ALL: false, BOARD_KEY: self.SOSIK_LIST[sender.tag].BOARD_KEY)
                self.NETWORK_CHECK()
            })
            self.present(ALERT, animated: true, completion: nil)
        })
        ALERT.addAction(UIAlertAction(title: "공유하기", style: .default) { (_) in
            self.SHARE(SOSIK_LIST: self.SOSIK_LIST, TAG: sender.tag)
        })
        let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        CANCEL.setValue(UIColor.systemRed, forKey: "titleTextColor")
        ALERT.addAction(CANCEL)
        
        present(ALERT, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if SOSIK_LIST.count != 0 {
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "DETAIL_SOSIK") as! DETAIL_SOSIK
            VC.modalTransitionStyle = .crossDissolve
            VC.PUSH = false
            VC.DB_CHECK = true
            VC.SOSIK_LIST = SOSIK_LIST
            VC.SOSIK_POSITION = indexPath.item
            present(VC, animated: true, completion: nil)
        }
    }
}
