//
//  SETTING_SFSC_B.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/20.
//

import UIKit
import Alamofire
import FirebaseMessaging

class SETTING_SFSC_B_TC: UITableViewCell {
    
    @IBOutlet weak var CONTENTS: UILabel!
}

//MARK: - 위치 정보 조회 (조약돌)
class SETTING_SFSC_B: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var BEACON_LIST: [FAMILY_BEACON] = []
    var BEACON_POSITION: Int = 0
    var BEACON_LOCATION: [FAMILY_BEACON] = []
    
    @IBOutlet weak var AFSC_BG_TOP: UIImageView!
    @IBOutlet weak var AFSC_BG_TOP_HEIGHT: NSLayoutConstraint!
    @IBOutlet weak var AFSC_BG_TOP_VIEW: UIView!
    @IBOutlet weak var AFSC_BG_TOP_VIEW_HEIGHT: NSLayoutConstraint!
    // 내비게이션바
    @IBOutlet weak var NAVI_BG: UIView!
    @IBOutlet weak var NAVI_VIEW: UIView!
    @IBOutlet weak var NAVI_TITLE: UILabel!
    // 테이블뷰
    @IBOutlet weak var TABLEVIEW: UITableView!
    // 조약돌삭제
    @IBOutlet weak var DELETE_BEACON: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로딩 화면
        ON_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR, "데이터 불러오는 중...")
        
        // 내비게이션바
        NAVI_BG.alpha = 0.0
        
        // 네트워크 연결 확인
        NETWORK_CHECK()
        
        // 테이블뷰 연결
        TABLEVIEW.delegate = self
        TABLEVIEW.dataSource = self
        TABLEVIEW.contentInset = UIEdgeInsets(top: 200.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        // 조약돌삭제
        DELETE_BEACON.addTarget(self, action: #selector(DELETE_BEACON(_:)), for: .touchUpInside)
    }
    
    // 네트워크 연결 확인
    func NETWORK_CHECK() {
        
        if SYSTEM_NETWORK_CHECKING() {
            GET_POST_DATA(NAME: "위치정보조회", ACTION_TYPE: "")
        } else {
            VIEW_NOTICE("N: 네트워크 상태를 확인해 주세요")
            DispatchQueue.main.async {
                let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                ALERT.addAction(UIAlertAction(title: "새로고침", style: .default) { (_) in self.NETWORK_CHECK() })
                self.present(ALERT, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - 위치 정보 조회
    func GET_POST_DATA(NAME: String, ACTION_TYPE: String) {
        
        let DATA = BEACON_LIST[BEACON_POSITION]
        
        let POST_URL: String = "https://damoalbs.pen.go.kr/conn/coin/get_coin_location.php"
        let PARAMETERS: Parameters = [
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "device_major": DATA.DEVICE_MAJOR,
            "device_minor": DATA.DEVICE_MINOR,
            "device_addr": DATA.DEVICE_ADDR,
            "sc_code": DATA.SC_CODE,
            "sc_name": DATA.SC_NAME
        ]
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 30.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseJSON(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
            print(response)
            
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
                    let APPEND_VALUE = FAMILY_BEACON()
                    
                    APPEND_VALUE.SET_COIN_NAME(COIN_NAME: DATA_DICT?["coin_name"] as Any)
                    APPEND_VALUE.SET_DATETIME(DATETIME: DATA_DICT?["datetime"] as Any)
                    APPEND_VALUE.SET_DEVICE_ADDR(DEVICE_ADDR: DATA_DICT?["device_addr"] as Any)
                    APPEND_VALUE.SET_DEVICE_MAJOR(DEVICE_MAJOR: DATA_DICT?["device_major"] as Any)
                    APPEND_VALUE.SET_DEVICE_MINOR(DEVICE_MINOR: DATA_DICT?["device_minor"] as Any)
                    APPEND_VALUE.SET_IDX(IDX: DATA_DICT?["idx"] as Any)
                    APPEND_VALUE.SET_MB_ID(MB_ID: DATA_DICT?["mb_id"] as Any)
                    APPEND_VALUE.SET_PUSH_TYPE(PUSH_TYPE: DATA_DICT?["push_type"] as Any)
                    APPEND_VALUE.SET_REG_DATE(REG_DATE: DATA_DICT?["reg_date"] as Any)
                    APPEND_VALUE.SET_SC_CODE(SC_CODE: DATA_DICT?["sc_code"] as Any)
                    APPEND_VALUE.SET_SC_NAME(SC_NAME: DATA_DICT?["sc_name"] as Any)
                    APPEND_VALUE.SET_SCANNER_LOCATION(SCANNER_LOCATION: DATA_DICT?["scanner_location"] as Any)
                    APPEND_VALUE.SET_SCANNER_MAC(SCANNER_MAC: DATA_DICT?["scanner_mac"] as Any)
                    // 데이터 추가
                    self.BEACON_LOCATION.append(APPEND_VALUE)
                    self.TABLEVIEW.reloadData()
                }
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.VIEW_NOTICE("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.VIEW_NOTICE("E: 네트워크 연결 실패 (000)") }
                
                self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
            }
            
            self.OFF_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR)
        })
    }
    
    // 조약돌삭제
    @objc func DELETE_BEACON(_ sender: UIButton) {
        
        // 진동 이벤트
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ALERT.addAction(UIAlertAction(title: "조약돌 지우기", style: .destructive) { (_) in
            // 네트워크 연결 확인
            if self.SYSTEM_NETWORK_CHECKING() {
                self.PUT_POST_DATA(NAME: "조약돌삭제", ACTION_TYPE: "del")
            } else {
                self.VIEW_NOTICE("N: 네트워크 상태를 확인해 주세요")
            }
        })
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(ALERT, animated: true, completion: nil)
    }
    
    //MARK: - 조약돌 삭제
    func PUT_POST_DATA(NAME: String, ACTION_TYPE: String) {
        
        let DATA = BEACON_LIST[BEACON_POSITION]
        
        let POST_URL: String = "https://damoalbs.pen.go.kr/conn/coin/coin_delete.php"
        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "device_major": DATA.DEVICE_MAJOR,
            "device_minor": DATA.DEVICE_MINOR,
            "device_addr": DATA.DEVICE_ADDR,
            "sc_code": DATA.SC_CODE,
            "sc_name": DATA.SC_NAME
        ]
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 30.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseString(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
//            print(response)
            
            switch response.result {
            case .success(_):
                
                Messaging.messaging().subscribe(toTopic: "\(DATA.DEVICE_MAJOR)\(DATA.DEVICE_MINOR)SC_ios")
                // 삭제 성공 시, 페이지 뒤로가기
                self.dismiss(animated: true, completion: nil)
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.VIEW_NOTICE("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.VIEW_NOTICE("E: 네트워크 연결 실패 (000)"); self.NETWORK_CHECK() }
                
                self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
            }
        })
    }
}

extension SETTING_SFSC_B: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        let NAVI_BG_HEIGHT = UIApplication.shared.statusBarFrame.height + 44.0
        
        if OFFSET_Y <= 0 {
            AFSC_BG_TOP_HEIGHT.constant = -OFFSET_Y + NAVI_BG_HEIGHT
            AFSC_BG_TOP_VIEW_HEIGHT.constant = -OFFSET_Y + NAVI_BG_HEIGHT
        }
        // 네비게이션바
        NAVI_BG.alpha = (OFFSET_Y+10)/10
        if OFFSET_Y >= 0 { NAVI_TITLE.alpha = (OFFSET_Y+10)/10 } else { NAVI_TITLE.alpha = 0.0 }
    }
}

extension SETTING_SFSC_B: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if BEACON_LOCATION.count == 0 { return 1 } else { return BEACON_LOCATION.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "SETTING_SFSC_B_TC", for: indexPath) as! SETTING_SFSC_B_TC
        
        if BEACON_LOCATION.count == 0 {
            CELL.CONTENTS.text = "최근 조약돌 위치 데이터가 없습니다."
        } else {
            let DATA = BEACON_LOCATION[indexPath.item]
            CELL.CONTENTS.text = "\(DATA.DATETIME)에 \(DATA.SC_NAME) \(DATA.SCANNER_LOCATION)에서\n\(DATA.COIN_NAME)의 위치가 확인 되었습니다."
        }
        
        return CELL
    }
}
