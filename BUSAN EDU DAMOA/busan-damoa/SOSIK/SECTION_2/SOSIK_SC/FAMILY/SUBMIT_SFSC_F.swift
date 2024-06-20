//
//  SUBMIT_SFSC_F.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/18.
//

import UIKit
import Nuke
import Alamofire

class SUBMIT_SFSC_F_TC: UITableViewCell {
    
    @IBOutlet weak var FAMILY_IMAGE: UIImageView!
    @IBOutlet weak var FAMILY_NAME: UILabel!
    @IBOutlet weak var FAMILY_PHONE: UILabel!
}

//MARK: - 받은 초대
class SUBMIT_SFSC_F: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    var FAMILY_LIST: [FAMILY_BEACON] = []
    
    // 내비게이션바
    @IBOutlet weak var NAVI_BG: UIView!
    @IBOutlet weak var NAVI_VIEW: UIView!
    @IBOutlet weak var NAVI_TITLE: UILabel!
    // 테이블뷰
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 내비게이션바
        NAVI_TITLE.alpha = 0.0
        
        // 네트워크 연결 확인
        NETWORK_CHECK()
        
        // 테이블뷰 연결
        TABLEVIEW.delegate = self
        TABLEVIEW.dataSource = self
        TABLEVIEW.separatorStyle = .none
    }
    
    // 네트워크 연결 확인
    func NETWORK_CHECK() {
        
        if SYSTEM_NETWORK_CHECKING() {
            GET_POST_DATA(NAME: "받은초대", ACTION_TYPE: "accept_list")
        } else {
            VIEW_NOTICE("N: 네트워크 상태를 확인해 주세요")
            DispatchQueue.main.async {
                let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                ALERT.addAction(UIAlertAction(title: "새로고침", style: .default) { (_) in self.NETWORK_CHECK() })
                self.present(ALERT, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - 받은 초대 불러오기
    func GET_POST_DATA(NAME: String, ACTION_TYPE: String) {
        
        let POST_URL: String = DATA_URL().SCHOOL_URL + "member/family.php"
        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? ""
        ]
        
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
                    return
                }
                
                for (_, DATA) in DATA_ARRAY.enumerated() {
                    
                    let DATA_DICT = DATA as? [String: Any]
                    let APPEND_VALUE = FAMILY_BEACON()
                    
                    APPEND_VALUE.SET_FAMILY_ID(FAMILY_ID: DATA_DICT?["mb_id"] as Any)
                    APPEND_VALUE.SET_FAMILY_IMAGE(FAMILY_IMAGE: DATA_DICT?["mb_img"] as Any)
                    APPEND_VALUE.SET_FAMILY_NAME(FAMILY_NAME: DATA_DICT?["mb_name"] as Any)
                    APPEND_VALUE.SET_FAMILY_TYPE(FAMILY_TYPE: DATA_DICT?["mb_type"] as Any)
                    // 데이터 추가
                    self.FAMILY_LIST.append(APPEND_VALUE)
                    self.TABLEVIEW.reloadData()
                }
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.VIEW_NOTICE("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.VIEW_NOTICE("E: 네트워크 연결 실패 (000)"); self.NETWORK_CHECK() }
                
                self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
            }
        })
    }
}

extension SUBMIT_SFSC_F: UIScrollViewDelegate {
    
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

extension SUBMIT_SFSC_F: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if FAMILY_LIST.count == 0 { return 0 } else { return FAMILY_LIST.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        ImageCache.shared.removeAll()
        
        let DATA = FAMILY_LIST[indexPath.item]
        let CELL = tableView.dequeueReusableCell(withIdentifier: "SUBMIT_SFSC_F_TC", for: indexPath) as! SUBMIT_SFSC_F_TC
        
        // 이미지
        CELL.FAMILY_IMAGE.layer.cornerRadius = 5.0
        CELL.FAMILY_IMAGE.clipsToBounds = true
        if DATA.FAMILY_IMAGE != "" {
            NUKE(IMAGE_URL: DATA.FAMILY_IMAGE, PLACEHOLDER: UIImage(named: "profile.png")!, PROFILE: CELL.FAMILY_IMAGE, FRAME_VIEW: CELL.FAMILY_IMAGE, SCALE: .scaleAspectFill)
        }
        // 이름
        CELL.FAMILY_NAME.text = DATA.FAMILY_NAME
        // 전화번호
        CELL.FAMILY_PHONE.text = DATA.FAMILY_ID
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 진동 이벤트
        UIImpactFeedbackGenerator().impactOccurred()
        
        let DATA = FAMILY_LIST[indexPath.item]
        let ALERT = UIAlertController(title: "가족(휴대폰) 등록 요청", message: "'\(DATA.FAMILY_NAME) (\(DATA.FAMILY_ID))'이(가) 사용자의 iPhone에 등록하려고 합니다.", preferredStyle: .alert)
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        ALERT.addAction(UIAlertAction(title: "등록", style: .default) { (_) in
            // 네트워크 연결 확인
            if self.SYSTEM_NETWORK_CHECKING() {
                self.PUT_POST_DATA(NAME: "받은초대등록", ACTION_TYPE: "accept", POSITION: indexPath.item)
            } else {
                self.VIEW_NOTICE("N: 네트워크 상태를 확인해 주세요")
            }
        })
        present(ALERT, animated: true, completion: nil)
    }
    
    //MARK: - 받은 초대 등록
    func PUT_POST_DATA(NAME: String, ACTION_TYPE: String, POSITION: Int) {
        
        let POST_URL: String = DATA_URL().SCHOOL_URL + "member/family.php"
        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "invitor": FAMILY_LIST[POSITION].FAMILY_ID
        ]
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 30.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseString(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
//            print(response)
            
            switch response.result {
            case .success(_):
                
                let ALERT = UIAlertController(title: "등록 되었습니다.", message: nil, preferredStyle: .alert)
                ALERT.addAction(UIAlertAction(title: "확인", style: .default) { (_) in
                    self.dismiss(animated: true, completion: nil)
                })
                self.present(ALERT, animated: true)
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.VIEW_NOTICE("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.VIEW_NOTICE("E: 네트워크 연결 실패 (000)"); self.NETWORK_CHECK() }
                
                self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
            }
        })
    }
}
