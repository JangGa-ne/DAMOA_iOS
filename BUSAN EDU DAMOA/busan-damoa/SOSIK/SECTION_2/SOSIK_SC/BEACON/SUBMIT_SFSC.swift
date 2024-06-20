//
//  SUBMIT_SFSC_B.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/18.
//

import UIKit
import Alamofire
import CoreLocation
import FirebaseMessaging

enum BACK_TYPE: Int {
    case TRUE
    case FALSE
}

//MARK: - 조약돌 등록
class SUBMIT_SFSC_B: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil)}
    
    var didTabBackType: ((BACK_TYPE) -> Void)?
    
    var FIND_BEACON_LIST: [String: CLBeacon] = [:]
    var BEACON_KEY: Array<Any> = []
    var BC_POSITION: Int = 0
    
    var SC_CODE: [String] = []
    var SC_NAME: [String] = []
    var SC_POSITION: Int = 0
    
    @IBOutlet weak var BG_VIEW: UIView!
    @IBOutlet weak var PICKERVIEW: UIPickerView!
    @IBOutlet weak var NO_DATA: UILabel!
    @IBOutlet weak var COIN_NAME: UITextField!
    @IBOutlet weak var ADD_BEACON: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 키보드 설정
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // BG뷰
        BG_VIEW.layer.cornerRadius = 20.0
        BG_VIEW.clipsToBounds = true
        
        var SC_CODE: [String] = []
        var SC_NAME: [String] = []
        
        for RECORD in UIViewController.APPDELEGATE.ENROLL_LIST {
            SC_CODE.append(RECORD.value(forKey: "sc_code") as? String ?? "")
            SC_NAME.append(RECORD.value(forKey: "sc_name") as? String ?? "")
        }
        
        // 데이터 추가
        for i in 0 ..< UNIQ(SOURCE: SC_CODE).count { if UNIQ(SOURCE: SC_CODE)[i] != "" { self.SC_CODE.append(UNIQ(SOURCE: SC_CODE)[i]) } }
        for i in 0 ..< UNIQ(SOURCE: SC_NAME).count { if UNIQ(SOURCE: SC_NAME)[i] != "" { self.SC_NAME.append(UNIQ(SOURCE: SC_NAME)[i]) } }
        PICKERVIEW.reloadAllComponents()
        
        // 피커뷰 연결
        PICKERVIEW.delegate = self
        PICKERVIEW.dataSource = self
        PICKERVIEW.setValue(UIColor.black, forKey: "textColor")
        // 학교 데이터 없음
        if self.SC_CODE.count == 0 {
            PICKERVIEW.isHidden = true
            NO_DATA.isHidden = false
        } else {
            PICKERVIEW.isHidden = false
            NO_DATA.isHidden = true
        }
        
        // 이름
        COIN_NAME.layer.borderWidth = 1.0
        COIN_NAME.layer.borderColor = UIColor.lightGray.cgColor
        COIN_NAME.layer.cornerRadius = 5.0
        PLACEHOLDER(TF: COIN_NAME, PH: "조약돌 이름을 지어주세요.")
        TOOL_BAR_DONE(TF: COIN_NAME, TV: UITextView(), SB: UISearchBar())
        COIN_NAME.PADDING_LEFT(X: 10.0)
        
        // 등록
        ADD_BEACON.layer.cornerRadius = 10.0
        ADD_BEACON.clipsToBounds = true
        ADD_BEACON.addTarget(self, action: #selector(SUBMIT(_:)), for: .touchUpInside)
    }
    
    //MARK: 등록
    @objc func SUBMIT(_ sender: UIButton) {
        
        // 미입력 항목 확인
        if COIN_NAME.text == "" || SC_CODE.count == 0 || SC_NAME.count == 0 {
            VIEW_NOTICE("N: 미입력된 항목이 있습니다")
        } else {
            COIN_NAME.resignFirstResponder()
            // 네트워크 연결 확인
            if SYSTEM_NETWORK_CHECKING() {
                PUT_POST_DATA(NAME: "조약돌등록", ACTION_TYPE: "reg")
            } else {
                VIEW_NOTICE("N: 네트워크 상태를 확인해 주세요")
            }
        }
    }
    
    //MARK: - 조약돌 등록
    func PUT_POST_DATA(NAME: String, ACTION_TYPE: String) {
        
        let POST_URL: String = "https://damoalbs.pen.go.kr/conn/coin/coin_add.php"
        let BEACON = FIND_BEACON_LIST["\(BEACON_KEY[BC_POSITION])"]!
        let BC_ADDRESS = BEACON.major.stringValue.appending(BEACON.minor.stringValue)
        
        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "device_major": BEACON.major,
            "device_minor": BEACON.minor,
            "device_addr": BC_ADDRESS,
            "sc_code": SC_CODE[SC_POSITION],
            "sc_name": SC_NAME[SC_POSITION],
            "coin_name": COIN_NAME.text!
        ]
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 30.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseString(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
            print(response)
            
            switch response.result {
            case .success(_):
                
                // 진동 이벤트
                UIImpactFeedbackGenerator().impactOccurred()
                
                var TITLE: String = ""
                var TAG: Int = 0
                
                if "\(response)" == "SUCCESS: success" {
                    TITLE = "등록 되었습니다."; TAG = 0
                } else if "\(response)" == "SUCCESS: duplicate" {
                    TITLE = "이미 등록된 조약돌 입니다."; TAG = 1
                } else {
                    TITLE = "등록 실패하였습니다."; TAG = 1
                }
                
                let ALERT = UIAlertController(title: TITLE, message: nil, preferredStyle: .alert)
                
                ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
                    if TAG == 0 { Messaging.messaging().subscribe(toTopic: "\(BEACON.major)\(BEACON.minor)SC_ios") }
                    guard let BACK = BACK_TYPE(rawValue: TAG) else { return }
                    self.dismiss(animated: true) { [weak self] in self?.didTabBackType?(BACK) }
                }))
                
                self.present(ALERT, animated: true, completion: nil)
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.VIEW_NOTICE("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.VIEW_NOTICE("E: 네트워크 연결 실패 (000)"); }
                
                self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
            }
        })
    }
}

extension SUBMIT_SFSC_B: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SC_NAME.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        SC_POSITION = row
        return SC_NAME[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SC_POSITION = row
    }
}
