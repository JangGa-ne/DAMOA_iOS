//
//  DETAIL_SOSIK.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/30.
//

import UIKit
import Alamofire
import YoutubePlayer_in_WKWebView

class SOSIK_DETAIL_TC: UITableViewCell {
    
    // 학부모연수
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Content: UITextView!
}

//MARK: - 소식 디테일 페이지
class DETAIL_SOSIK: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var PUSH: Bool = false
    
    @IBAction func BACK_VC(_ sender: UIButton) { if PUSH { VIEWCONTROLLER_VC(IDENTIFIER: "HOME") } else { dismiss(animated: true, completion: nil) } }
    
    var DB_CHECK: Bool = false
    var SOSIK_LIST: [SOSIK_API] = []
    var SOSIK_POSITION: Int = 0
    
    @IBOutlet weak var SC_LOGO: UIImageView!
    @IBOutlet weak var BOARD_TYPE: UILabel!
    @IBOutlet weak var SC_NAME: UILabel!
    @IBOutlet weak var DATETIME: UILabel!
    @IBOutlet weak var DAY: UILabel!
    
    // 테이블뷰
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    // 설문조사
    @IBOutlet weak var SURVEY_VC_VIEW: UIView!
    @IBOutlet weak var SURVEY_VC: UIButton!
    // 첨부파일
    @IBOutlet weak var DL_IMAGE: UIImageView!
    @IBOutlet weak var DL_NAME: UILabel!
    @IBOutlet weak var DL_BTN: UIButton!
    // 좋아요(스크랩)
    @IBOutlet weak var SR_IMAGE_VIEW: UIView!
    @IBOutlet weak var SR_IMAGE: UIImageView!
    @IBOutlet weak var SR_BTN: UIButton!
    // 공유하기
    @IBOutlet weak var SH_IMAGE: UIImageView!
    @IBOutlet weak var SH_BTN: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let DATA = SOSIK_LIST[SOSIK_POSITION]
        
        // 학교로고
        SC_LOGO.layer.cornerRadius = 5.0
        SC_LOGO.clipsToBounds = true
        if !(DATA.SC_LOGO == "" || DATA.SC_LOGO == "Y") {
            let IMAGE_URL = "https://sms.pen.go.kr/files/school_logo/\(DATA.SC_LOGO)"
            NUKE(IMAGE_URL: IMAGE_URL, PLACEHOLDER: UIImage(named: "school_logo.png")!, PROFILE: SC_LOGO, FRAME_VIEW: SC_LOGO, SCALE: .scaleAspectFit)
        } else {
            let IMAGE_URL = "https://sms.pen.go.kr/files/school_logo/\(DATA.SC_CODE)"
            NUKE(IMAGE_URL: IMAGE_URL, PLACEHOLDER: UIImage(named: "school_logo.png")!, PROFILE: SC_LOGO, FRAME_VIEW: SC_LOGO, SCALE: .scaleAspectFit)
        }
        // 타입
        if DATA.BOARD_NAME != "" { BOARD_TYPE.text = DATA.BOARD_NAME }
        // 학교이름
        if DATA.SC_NAME != "" { SC_NAME.text = DATA.SC_NAME }
        // 날짜
        DATETIME.text = FORMAT_DATETIME(DATA.DATETIME)
        // 요일
        DAY.text = FORMAT_DAY(DATA.DATETIME)
        
        // 테이블뷰 연결
        TABLEVIEW.delegate = self
        TABLEVIEW.dataSource = self
        TABLEVIEW.separatorStyle = .none
        
        //MARK: - 컨텐츠
        var MEDIA: [String] = []
        var FILE: [String] = []
        
        if DATA.ATTACHED.count != 0 {
            for (_, DATA) in DATA.ATTACHED.enumerated() {
                if DATA.MEDIA_TYPE != "f" { MEDIA.append(DATA.MEDIA_TYPE) } else { FILE.append(DATA.MEDIA_TYPE) }
            }
        }
        
        //MARK: 설문조사
        SURVEY_VC.layer.cornerRadius = 5.0
        SURVEY_VC.clipsToBounds = true
        // 설문조사
        if DATA.BOARD_TYPE == "SV" {
            
            SURVEY_VC_VIEW.isHidden = false
            SR_IMAGE_VIEW.isHidden = true
            
            let DATE_FORMATTER = DateFormatter()
            DATE_FORMATTER.dateFormat = "yyyy-MM-dd"
            
            if DATA.SV_INFO.count != 0 {
                
                // 설문기한 확인
                if DATE_FORMATTER.string(from: Date()) <= DATA.SV_INFO[0].END_DATE {
                    SURVEY_VC.tag = 0
                    SURVEY_VC.setTitle("참여하기", for: .normal)
                    SURVEY_VC.backgroundColor = .systemBlue
                } else {
                    SURVEY_VC.tag = 1
                    SURVEY_VC.setTitle("마감", for: .normal)
                    SURVEY_VC.backgroundColor = .darkGray
                }
            } else {
                SURVEY_VC.tag = 1
                SURVEY_VC.setTitle("마감", for: .normal)
                SURVEY_VC.backgroundColor = .darkGray
            }
            
            SURVEY_VC.addTarget(self, action: #selector(WEB_VC(_:)), for: .touchUpInside)
        } else {
            
            SURVEY_VC_VIEW.isHidden = true
            SR_IMAGE_VIEW.isHidden = false
        }
        
        //MARK: - 첨부파일/좋아요(스크랩)/공유하기
        // 첨부파일
        if FILE.count == 0 {
            DL_IMAGE.image = UIImage(named: "file_off")
            DL_NAME.text = "파일 없음"
        } else {
            DL_IMAGE.image = UIImage(named: "file_on")
            DL_NAME.text = "파일 보기 및 다운로드"
            DL_BTN.tag = SOSIK_POSITION
            DL_BTN.addTarget(self, action: #selector(FILE(_:)), for: .touchUpInside)
        }
        // 좋아요(스크랩)
        if DATA.LIKE { SR_IMAGE.image = UIImage(named: "like_on.png") } else { SR_IMAGE.image = UIImage(named: "like_off.png") }
        SR_BTN.tag = SOSIK_POSITION
        SR_BTN.addTarget(self, action: #selector(SR_BTN(_:)), for: .touchUpInside)
        // 공유하기
        SH_BTN.tag = SOSIK_POSITION
        SH_BTN.addTarget(self, action: #selector(SHARE(_:)), for: .touchUpInside)
        
        //MARK: 소식 업데이트
        if SYSTEM_NETWORK_CHECKING() { PUT_POST_DATA(NAME: "소식(상세보기)열기", ACTION_TYPE: "open") }
    }
    
    //MARK: 소식 업데이트(좋아요)
    func PUT_POST_DATA(NAME: String, ACTION_TYPE: String) {
        
        let POST_URL: String = DATA_URL().SCHOOL_URL + "message/school_sosik_update.php"
        let PARAMETERS: Parameters = [
            "mb_id": UIViewController.USER_DATA.string(forKey: "mb_id") ?? "",
            "board_key": SOSIK_LIST[SOSIK_POSITION].BOARD_KEY,
            "board_type": SOSIK_LIST[SOSIK_POSITION].BOARD_TYPE,
            "action_type": ACTION_TYPE
        ]
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 15.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseString(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
            print(response)
        })
    }
    
    @objc func WEB_VC(_ sender: UIButton) {
        
        let DATA = SOSIK_LIST[SOSIK_POSITION]
        let MB_ID = UserDefaults.standard.string(forKey: "mb_id") ?? ""
        
        if sender.tag == 0 {
            UIApplication.shared.open(URL(string: "https://damoaapp.pen.go.kr/card/_sv.php?poll_num=\(DATA.POLL_NUM)&mb_id=\(MB_ID)&po_index=1")!)
        } else {
            NOTIFICATION_VIEW("본 설문조사는 마감되었습니다")
        }
    }
    
    //MARK: - 첨부파일
    @objc func FILE(_ sender: UIButton) {
        UIImpactFeedbackGenerator().impactOccurred()
        FILE(SOSIK_LIST: SOSIK_LIST, TAG: sender.tag)
    }
    
    // 좋아요(스크랩)
    @objc func SR_BTN(_ sender: UIButton) {
        
        let DATA = SOSIK_LIST[sender.tag]
        
        if !DB_CHECK {
            
            if !DATA.LIKE {
                // 데이터 추가
                SCRAP()
                DATA.LIKE = true
                SR_IMAGE.image = UIImage(named: "like_on.png")
                VIEW_NOTICE(": 소식 보관함에 추가됨")
                //MARK: 소식 좋아요
                if SYSTEM_NETWORK_CHECKING() { PUT_POST_DATA(NAME: "소식좋아요", ACTION_TYPE: "like") }
            } else {
                // 데이터 삭제
                UIViewController.APPDELEGATE.DELETE_DB_MAIN(ALL: false, BOARD_KEY: DATA.BOARD_KEY)
                DATA.LIKE = false
                SR_IMAGE.image = UIImage(named: "like_off.png")
                VIEW_NOTICE(": 소식 보관함에서 삭제됨")
            }
        } else {
            
            let ALERT = UIAlertController(title: "", message: "항목을 저장 취소하면 항목이 추가된 모든 컬렉션에서도 삭제됩니다.", preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            ALERT.addAction(UIAlertAction(title: "삭제", style: .destructive) { (_) in
                // 데이터 삭제
                UIViewController.APPDELEGATE.DELETE_DB_MAIN(ALL: false, BOARD_KEY: DATA.BOARD_KEY)
                self.dismiss(animated: true, completion: nil)
            })
            present(ALERT, animated: true, completion: nil)
        }
    }
    
    //MARK: - 좋아요(스크랩)
    func SCRAP() {
        
        UIViewController.APPDELEGATE.OPEN_DB_MAIN()
        
        var DATETIME: String = ""; var DT_FROM: String = ""; var DOWNLOAD_URL: String = ""; var FILE_NAME: String = ""; var FILE_NAME_ORG: String = ""
        var FILE_SIZE: String = ""; var IDX: String = ""; var IN_SEQ: String = ""; var LAT: String = ""; var LNG: String = ""; var MEDIA_FILES: String = ""
        var MEDIA_TYPE: String = ""; var MSG_GROUP: String = ""; var HTTP_STRING: String = ""
        
        let DATA = SOSIK_LIST[SOSIK_POSITION]
        
        for ATTACHED in DATA.ATTACHED {
            
            DATETIME.append("\(ATTACHED.DATETIME)|"); DT_FROM.append("\(ATTACHED.DT_FROM)|"); DOWNLOAD_URL.append("\(ATTACHED.DOWNLOAD_URL)|"); FILE_NAME.append("\(ATTACHED.FILE_NAME)|"); FILE_NAME_ORG.append("\(ATTACHED.FILE_NAME_ORG)|")
            FILE_SIZE.append("\(ATTACHED.FILE_SIZE)|"); IDX.append("\(ATTACHED.IDX)|"); IN_SEQ.append("\(ATTACHED.IN_SEQ)|"); LAT.append("\(ATTACHED.LAT)|"); LNG.append("\(ATTACHED.LNG)|")
            MEDIA_FILES.append("\(ATTACHED.MEDIA_FILES)|"); MEDIA_TYPE.append("\(ATTACHED.MEDIA_TYPE)|"); MSG_GROUP.append("\(ATTACHED.MSG_GROUP)|"); HTTP_STRING.append("\(ATTACHED.HTTP_STRING)|")
        }
        
        UIViewController.APPDELEGATE.INSERT_DB_MAIN(BOARD_CODE: DATA.BOARD_CODE, BOARD_ID: DATA.BOARD_ID, BOARD_KEY: DATA.BOARD_KEY, BOARD_NAME: DATA.BOARD_NAME, BOARD_SOURCE: DATA.BOARD_SOURCE, BOARD_TYPE: DATA.BOARD_TYPE, CALL_BACK: DATA.CALL_BACK, CLASS_INFO: DATA.CLASS_INFO, CONTENT: DATA.CONTENT, CONTENT_TEXT: DATA.CONTENT_TEXT, CONTENT_TYPE: DATA.CONTENT_TYPE, DATETIME: DATA.DATETIME, DST: DATA.DST, DST_NAME: DATA.DST_NAME, DST_TYPE: DATA.DST_TYPE, FCM_KEY: DATA.FCM_KEY, FILE_COUNT: DATA.FILE_COUNT, FROM_FILE: DATA.FROM_FILE, IDX: DATA.IDX, INPUT_DATE: DATA.INPUT_DATE, IS_MODIFY: DATA.IS_MODIFY, IS_PUSH: DATA.IS_PUSH, LIKE_COUNT: DATA.LIKE_COUNT, LIKE_ID: DATA.LIKE_ID, ME_LENGTH: DATA.ME_LENGTH, MEDIA_COUNT: DATA.MEDIA_COUNT, MSG_GROUP: DATA.MSG_GROUP, NO: DATA.NO, OPEN_COUNT: DATA.OPEN_COUNT, POLL_NUM: DATA.POLL_NUM, RESULT: DATA.RESULT, SC_CODE: DATA.SC_CODE, SC_GRADE: DATA.SC_GRADE, SC_GROUP: DATA.SC_GROUP, SC_LOCATION: DATA.SC_LOCATION, SC_LOGO: DATA.SC_LOGO, SC_NAME: DATA.SC_NAME, SEND_TYPE: DATA.SEND_TYPE, SENDER_IP: DATA.SENDER_IP, SUBJECT: DATA.SUBJECT, TARGET_GRADE: DATA.TARGET_GRADE, TARGET_CLASS: DATA.TARGET_CLASS, WR_SHARE: DATA.WR_SHARE, WRITER: DATA.WRITER, LIKE: true, AT_DATETIME: DATETIME, AT_DT_FROM: DT_FROM, AT_FILE_NAME: FILE_NAME, AT_FILE_NAME_ORG: FILE_NAME_ORG, AT_FILE_SIZE: FILE_SIZE, AT_IDX: IDX, AT_IN_SEQ: IN_SEQ, AT_LAT: LAT, AT_LNG: LNG, AT_MEDIA_FILES: MEDIA_FILES, AT_MEDIA_TYPE: MEDIA_TYPE, AT_MSG_GROUP: MSG_GROUP, AT_HTTP_STRING: HTTP_STRING, AT_DOWNLOAD_URL: DOWNLOAD_URL)
    }
    
    //MARK: - 공유하기
    @objc func SHARE(_ sender: UIButton) {
        SHARE(SOSIK_LIST: SOSIK_LIST, TAG: sender.tag)
    }
}

extension DETAIL_SOSIK: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SOSIK_LIST.count == 0 { return 0 } else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let DATA = SOSIK_LIST[SOSIK_POSITION]
        
        // PUSH 데이터 삭제 되었을 경우
        if DATA.SC_NAME == "" && DATA.SUBJECT == "" && DATA.CONTENT == "" {
            
            let ALERT = UIAlertController(title: "부산교육 다모아", message: "해당 내용은 관리자에 의해 삭제되었습니다", preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "확인", style: .cancel) { (_) in self.VIEWCONTROLLER_VC(IDENTIFIER: "HOME") })
            present(ALERT, animated: true)
        }
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "SOSIK_TC", for: indexPath) as! SOSIK_TC
        
        if (DATA.SUBJECT == "") && (DATA.CONTENT == "") && (DATA.ATTACHED.count == 0) {
            
            let ALERT = UIAlertController(title: "부산교육 다모아", message: "관리자에 의해 해당 소식은 볼 수 없습니다.", preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "확인", style: .default) { (_) in self.VIEWCONTROLLER_VC(IDENTIFIER: "HOME") })
            present(ALERT, animated: true, completion: nil)
        }
        
        CELL.DETAIL = true
        // 프로토콜 연결
        CELL.PROTOCOL = self
        // 데이터 넘김
        CELL.SOSIK_LIST = SOSIK_LIST
        CELL.SOSIK_POSITION = SOSIK_POSITION
        
        //MARK: - 컨텐츠
        var MEDIA: [String] = []
        var FILE: [String] = []
        
        if DATA.ATTACHED.count != 0 {
            for (_, DATA) in DATA.ATTACHED.enumerated() {
                if DATA.MEDIA_TYPE != "f" { MEDIA.append(DATA.MEDIA_TYPE) } else { FILE.append(DATA.MEDIA_TYPE) }
            }
        }
        // 컨텐츠뷰
        if MEDIA.count == 0 {
            CELL.CT_VIEW.isHidden = true
        } else {
            CELL.CT_VIEW.isHidden = false
            CELL.DELEGATE()
        }
        // 제목
        CELL.CT_TITLE.text = ENCODE(DATA.SUBJECT)
        // 내용
        CELL.CT_TEXTVIEW.isEditable = false
        if DATA.CONTENT_TYPE == "text" {
            CELL.CT_TEXTVIEW.text = ENCODE(DATA.CONTENT).replacingOccurrences(of: "<BR>", with: "\n").replacingOccurrences(of: "<br>", with: "\n")
        } else {
            CELL.CT_TEXTVIEW.attributedText = HTML_STRING_DETAIL(ENCODE(DATA.CONTENT), CELL.COLLECTIONVIEW.frame.size.width - 30.0)
        }
        CELL.CT_TEXTVIEW.dataDetectorTypes = .link
        
        return CELL
    }
}
