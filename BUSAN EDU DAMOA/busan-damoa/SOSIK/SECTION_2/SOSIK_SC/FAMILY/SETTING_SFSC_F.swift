//
//  SETTING_SFSC_F.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/20.
//

import UIKit
import Alamofire

class SETTING_SFSC_F_TC: UITableViewCell {
    
    @IBOutlet weak var TITLE: UILabel!
}

//MARK: - 위치 정보 조회 (가족)
class SETTING_SFSC_F: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var FAMILY_LIST: [FAMILY_BEACON] = []
    var FAMILY_POSITION: Int = 0
    
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
    // 멤버삭제
    @IBOutlet weak var DELETE_MEMBER: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 내비게이션바
        NAVI_BG.alpha = 0.0
        
        // 테이블뷰 연결
        TABLEVIEW.delegate = self
        TABLEVIEW.dataSource = self
        TABLEVIEW.contentInset = UIEdgeInsets(top: 200.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        // 멤버삭제
        DELETE_MEMBER.addTarget(self, action: #selector(DELETE_MEMBER(_:)), for: .touchUpInside)
    }
    
    // 멤버삭제
    @objc func DELETE_MEMBER(_ sender: UIButton) {
        
        // 진동 이벤트
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ALERT.addAction(UIAlertAction(title: "멤버 지우기", style: .destructive) { (_) in
            // 네트워크 연결 확인
            if self.SYSTEM_NETWORK_CHECKING() {
                self.PUT_POST_DATA(NAME: "멤버삭제", ACTION_TYPE: "delete")
            } else {
                self.VIEW_NOTICE("N: 네트워크 상태를 확인해 주세요")
            }
        })
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(ALERT, animated: true, completion: nil)
    }
    
    //MARK: - 멤버 삭제
    func PUT_POST_DATA(NAME: String, ACTION_TYPE: String) {
        
        let POST_URL: String = DATA_URL().SCHOOL_URL + "member/family.php"
        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "family_id": FAMILY_LIST[FAMILY_POSITION].FAMILY_ID
        ]
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 30.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseString(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
//            print(response)
            
            switch response.result {
            case .success(_):
                
                // 삭제 성공 시, 페이지 뒤로가기
                self.dismiss(animated: true, completion: nil)
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.VIEW_NOTICE("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.VIEW_NOTICE("E: 네트워크 연결 실패 (000)") }
                
                self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
            }
        })
    }
}

extension SETTING_SFSC_F: UIScrollViewDelegate {
    
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

extension SETTING_SFSC_F: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "SETTING_SFSC_F_TC", for: indexPath) as! SETTING_SFSC_F_TC
        
        if indexPath.item == 0 {
            CELL.TITLE.text = "실시간 위치"
        } else {
            CELL.TITLE.text = "이동 경로"
        }
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 진동 이벤트
        UIImpactFeedbackGenerator().impactOccurred()
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "DETAIL_SFSC") as! DETAIL_SFSC
        VC.FAMILY_LIST = FAMILY_LIST
        VC.FAMILY_POSITION = FAMILY_POSITION
        if indexPath.item == 0 {
            VC.REALTIME_LOACTION = true
        } else {
            VC.REALTIME_LOACTION = false
        }
        present(VC, animated: true, completion: nil)
    }
}
