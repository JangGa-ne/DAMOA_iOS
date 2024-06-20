//
//  SOSIK_SC.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/05/14.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class SAFE_SCHOOL_TC: UITableViewCell {
    
    // 등록된 가족
    @IBOutlet weak var SFSC_VIEW_F: UIView!
    @IBOutlet weak var SFSC_IMAGE_F: UIImageView!
    @IBOutlet weak var SFSC_NAME_F: UILabel!
    @IBOutlet weak var SFSC_PHONE_F: UILabel!
    @IBOutlet weak var SFSC_ADD_VC_F: UIButton!
    // 등록된 조약돌
    @IBOutlet weak var SFSC_VIEW_B: UIView!
    @IBOutlet weak var SFSC_IMAGE_B: UIImageView!
    @IBOutlet weak var SFSC_NAME_B: UILabel!
    @IBOutlet weak var SFSC_PHONE_B: UILabel!
    @IBOutlet weak var SFSC_ADD_VC_B: UIButton!
}

// 자녀안심+
class SOSIK_SC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var LOCATION_SETTING: UIButton!
    @IBAction func LOCATION_SETTING(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
    
    let TRANSITION = SLIDE_IN_TRANSITION()
    
    var SC_CHECK: Bool = false
    var FAMILY_LIST: [FAMILY_BEACON] = []
    var BEACON_LIST: [FAMILY_BEACON] = []
    
    @IBOutlet weak var NAVI_TITLE: UILabel!
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    @IBOutlet weak var SAFE: UIButton!          // 안심 알리미
    @IBOutlet weak var REPORT: UIButton!        // 학교폭력 신고상담
    @IBOutlet weak var MATERIAL: UIButton!      // 학교폭력 자료
    
    
    // 로딩인디케이터
    let VIEW = UIView()
    override func loadView() {
        super.loadView()
        
        EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "Logo.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
        CHECK_VERSION(NAVI_TITLE)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.APPDELEGATE.SOSIK_SC_VC = self
        UIViewController.APPDELEGATE.LOC_UPDATE()
        DispatchQueue.main.async { self.LOC_CHECK_ALERT() }
        PUSH_BADGE(BOARD_TYPE: "SC", false)
        
        SAFE.tag = 0
        SAFE.addTarget(self, action: #selector(SELECT(_:)), for: .touchUpInside)
        REPORT.tag = 1
        REPORT.addTarget(self, action: #selector(SELECT(_:)), for: .touchUpInside)
        MATERIAL.tag = 2
        MATERIAL.addTarget(self, action: #selector(SELECT(_:)), for: .touchUpInside)
        
        TABLEVIEW.delegate = self
        TABLEVIEW.dataSource = self
        TABLEVIEW.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: - 네트워크 연결 확인
        NETWORK_CHECK()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UIViewController.APPDELEGATE.SC_CHECK {
            
            UIViewController.APPDELEGATE.SC_CHECK = false
            
            let TAB_BAR_TITLE: [String] = ["가족초대", "받은초대"]
            let TAB_BAR_IMAGE: [String] = ["send_off.png", "receive_off.png"]
            
            let TBC = self.storyboard?.instantiateViewController(withIdentifier: "SOSIK_FAMILY_TAB") as! UITabBarController
            
            TBC.modalTransitionStyle = .crossDissolve
            TBC.selectedIndex = 1
            
            for i in 0 ..< 2 {
                TBC.tabBar.items?[i].title = TAB_BAR_TITLE[i]
                TBC.tabBar.items?[i].image = UIImage(named: TAB_BAR_IMAGE[i])
            }
            
            present(TBC, animated: true, completion: nil)
        }
    }
    
    @objc func SELECT(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            TABLEVIEW.isHidden = false
        } else if sender.tag == 1 {
            
            TABLEVIEW.isHidden = true
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SCHOOL_VIOLENCE_COUNSELING") as! SCHOOL_VIOLENCE_COUNSELING
            VC.modalTransitionStyle = .crossDissolve
            present(VC, animated: true, completion: nil)
        } else {
            
            TABLEVIEW.isHidden = true
            UIApplication.shared.open(URL(string: "http://www.dorandoran.go.kr")!)
        }
    }
    
    //MARK: - 네트워크 연결 확인
    @objc func NETWORK_CHECK() {
        
        if SYSTEM_NETWORK_CHECKING() {
            GET_POST_DATA(NAME: "등록된가족", ACTION_TYPE: "list")
        } else {
            VIEW_NOTICE("N: 네트워크 상태를 확인해 주세요")
            DispatchQueue.main.async {
                let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                ALERT.addAction(UIAlertAction(title: "새로고침", style: .default) { (_) in self.NETWORK_CHECK() })
                self.present(ALERT, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - 등록된 가족, 조약돌 불러오기
    func GET_POST_DATA(NAME: String, ACTION_TYPE: String) {
        
        // 데이터 삭제
        if NAME == "등록된가족" { FAMILY_LIST.removeAll(); UIViewController.APPDELEGATE.FAMILY_LIST.removeAll() } else if NAME == "등록된조약돌" { BEACON_LIST.removeAll() }
        TABLEVIEW.reloadData()
        
        var POST_URL: String = ""
        var PARAMETERS: Parameters = [:]
        
        if NAME == "등록된가족" {
            POST_URL = DATA_URL().SCHOOL_URL + "member/family.php"
            PARAMETERS["mb_id"] = UserDefaults.standard.string(forKey: "mb_id") ?? ""
            PARAMETERS["action_type"] = ACTION_TYPE
        } else if NAME == "등록된조약돌" {
            POST_URL = "https://damoalbs.pen.go.kr/conn/coin/get_coin_info.php"
            PARAMETERS["mb_id"] = UserDefaults.standard.string(forKey: "mb_id") ?? ""
        }
        
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
                    if NAME == "등록된가족" {
                        self.GET_POST_DATA(NAME: "등록된조약돌", ACTION_TYPE: "")
                    } else {
//                        self.RF_CONTROL.endRefreshing()
                        self.CLOSE_EFFECT_INDICATOR_VIEW(VIEW: self.VIEW)
                    }
                    return
                }
                
                for (_, DATA) in DATA_ARRAY.enumerated() {
                    
                    let DATA_DICT = DATA as? [String: Any]
                    let APPEND_VALUE = FAMILY_BEACON()
                    
                    if NAME == "등록된가족" {
                        
                        APPEND_VALUE.SET_FAMILY_ID(FAMILY_ID: DATA_DICT?["mb_id"] as Any)
                        APPEND_VALUE.SET_FAMILY_IMAGE(FAMILY_IMAGE: DATA_DICT?["mb_img"] as Any)
                        APPEND_VALUE.SET_FAMILY_NAME(FAMILY_NAME: DATA_DICT?["mb_name"] as Any)
                        APPEND_VALUE.SET_FAMILY_TYPE(FAMILY_TYPE: DATA_DICT?["mb_type"] as Any)
                        // 데이터 추가
                        self.FAMILY_LIST.append(APPEND_VALUE)
                        UIViewController.APPDELEGATE.FAMILY_LIST.append(APPEND_VALUE)
                        self.TABLEVIEW.reloadData()
                        self.TABLEVIEW.layer.removeAllAnimations()
                        self.TABLEVIEW.setContentOffset(self.TABLEVIEW.contentOffset, animated: false)
                    } else if NAME == "등록된조약돌" {
                        
                        APPEND_VALUE.SET_COIN_NAME(COIN_NAME: DATA_DICT?["coin_name"] as Any)
                        APPEND_VALUE.SET_DATETIME(DATETIME: DATA_DICT?["datetime"] as Any)
                        APPEND_VALUE.SET_DEVICE_ADDR(DEVICE_ADDR: DATA_DICT?["device_addr"] as Any)
                        APPEND_VALUE.SET_DEVICE_MAJOR(DEVICE_MAJOR: DATA_DICT?["device_major"] as Any)
                        APPEND_VALUE.SET_DEVICE_MINOR(DEVICE_MINOR: DATA_DICT?["device_minor"] as Any)
                        APPEND_VALUE.SET_IDX(IDX: DATA_DICT?["idx"] as Any)
                        APPEND_VALUE.SET_MB_ID(MB_ID: DATA_DICT?["mb_id"] as Any)
                        APPEND_VALUE.SET_SC_CODE(SC_CODE: DATA_DICT?["sc_code"] as Any)
                        APPEND_VALUE.SET_SC_NAME(SC_NAME: DATA_DICT?["sc_name"] as Any)
                        // 데이터 추가
                        self.BEACON_LIST.append(APPEND_VALUE)
                        self.TABLEVIEW.reloadData()
                        self.TABLEVIEW.layer.removeAllAnimations()
                        self.TABLEVIEW.setContentOffset(self.TABLEVIEW.contentOffset, animated: false)
                    }
                }
                
                if NAME == "등록된가족" { self.GET_POST_DATA(NAME: "등록된조약돌", ACTION_TYPE: "") }
            case .failure(let ERROR):
                
                if NAME == "등록된가족" {
                    
                    self.GET_POST_DATA(NAME: "등록된조약돌", ACTION_TYPE: "")
                } else if NAME == "등록된조약돌" {
                    
                    // TIMEOUT
                    if ERROR._code == NSURLErrorTimedOut { self.VIEW_NOTICE("E: 서버 연결 실패 (408)") }
                    if ERROR._code == NSURLErrorNetworkConnectionLost { self.VIEW_NOTICE("E: 네트워크 연결 실패 (000)"); self.NETWORK_CHECK() }
                    
                    self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
                }
            }
            
            if NAME == "등록된조약돌" {
//                self.RF_CONTROL.endRefreshing()
                self.CLOSE_EFFECT_INDICATOR_VIEW(VIEW: self.VIEW)
            }
        })
    }
}

extension SOSIK_SC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 2 || section == 4 {
            return 1
        } else if section == 1 {
            if FAMILY_LIST.count == 0 { return 0 } else { return FAMILY_LIST.count }
        } else if section == 3 {
            if BEACON_LIST.count == 0 { return 0 } else { return BEACON_LIST.count }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SAFE_SCHOOL_TC_T", for: indexPath) as! SAFE_SCHOOL_TC
            
            return CELL
        } else if indexPath.section == 1 {
            
            // 등록된 가족
            let DATA = FAMILY_LIST[indexPath.item]
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SAFE_SCHOOL_TC_F", for: indexPath) as! SAFE_SCHOOL_TC
            
            CELL.SFSC_VIEW_F.layer.borderWidth = 2.0
            CELL.SFSC_VIEW_F.layer.borderColor = UIColor.systemBlue.cgColor
            CELL.SFSC_VIEW_F.layer.cornerRadius = 10.0
            CELL.SFSC_VIEW_F.clipsToBounds = true
            
            CELL.SFSC_IMAGE_F.layer.cornerRadius = 30.0
            CELL.SFSC_IMAGE_F.clipsToBounds = true
            if DATA.FAMILY_IMAGE != "" {
                NUKE(IMAGE_URL: DATA.FAMILY_IMAGE, PLACEHOLDER: UIImage(named: "profile.png")!, PROFILE: CELL.SFSC_IMAGE_F, FRAME_VIEW: CELL.SFSC_IMAGE_F, SCALE: .scaleAspectFit)
            }
            CELL.SFSC_NAME_F.text = DATA.FAMILY_NAME
            CELL.SFSC_PHONE_F.text = DATA.FAMILY_ID
            
            return CELL
        } else if indexPath.section == 2 {
            // 가족 추가
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SAFE_SCHOOL_TC_FA", for: indexPath) as! SAFE_SCHOOL_TC
            
            CELL.SFSC_ADD_VC_F.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 0.0, height: 2.5), SD_RADIUS: 5.0, OPACITY: 0.1, RADIUS: 5.0)
            CELL.SFSC_ADD_VC_F.backgroundColor = .systemBlue
            CELL.SFSC_ADD_VC_F.addTarget(self, action: #selector(AFSC_DETAIL_VC(_:)), for: .touchUpInside)
            
            return CELL
        } else if indexPath.section == 3 {
            
            // 등록된 조약돌
            let DATA = BEACON_LIST[indexPath.item]
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SAFE_SCHOOL_TC_B", for: indexPath) as! SAFE_SCHOOL_TC
            
            CELL.SFSC_VIEW_B.layer.borderWidth = 2.0
            CELL.SFSC_VIEW_B.layer.borderColor = UIColor.YELLOW_FFAC0F.cgColor
            CELL.SFSC_VIEW_B.layer.cornerRadius = 10.0
            CELL.SFSC_VIEW_B.clipsToBounds = true
            
            CELL.SFSC_IMAGE_B.layer.cornerRadius = 30.0
            CELL.SFSC_IMAGE_B.clipsToBounds = true
            CELL.SFSC_NAME_B.text = DATA.COIN_NAME
            CELL.SFSC_PHONE_B.text = DATA.SC_NAME
            
            return CELL
        } else {
            
            // 조약돌 등록
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SAFE_SCHOOL_TC_BA", for: indexPath) as! SAFE_SCHOOL_TC
            
            CELL.SFSC_ADD_VC_B.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 0.0, height: 2.5), SD_RADIUS: 5.0, OPACITY: 0.1, RADIUS: 5.0)
            CELL.SFSC_ADD_VC_B.backgroundColor = .YELLOW_FFAC0F
            CELL.SFSC_ADD_VC_B.addTarget(self, action: #selector(SFSC_DETAIL_VC(_:)), for: .touchUpInside)
            
            return CELL
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 등록된 가족
        if indexPath.section == 1 {
            
            // 진동 이벤트
            UIImpactFeedbackGenerator().impactOccurred()
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SETTING_SFSC_F") as! SETTING_SFSC_F
            VC.modalTransitionStyle = .crossDissolve
            VC.FAMILY_LIST = FAMILY_LIST
            VC.FAMILY_POSITION = indexPath.item
            present(VC, animated: true, completion: nil)
        // 등록된 조약돌
        } else if indexPath.section == 3 {
            
            // 진동 이벤트
            UIImpactFeedbackGenerator().impactOccurred()
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SETTING_SFSC_B") as! SETTING_SFSC_B
            VC.modalTransitionStyle = .crossDissolve
            VC.BEACON_LIST = BEACON_LIST
            VC.BEACON_POSITION = indexPath.item
            present(VC, animated: true, completion: nil)
        }
    }
    
    // 가족 추가
    @objc func AFSC_DETAIL_VC(_ sender: UIButton) {
        
        let TBC = self.storyboard?.instantiateViewController(withIdentifier: "SOSIK_FAMILY_TAB") as! UITabBarController
        TBC.modalTransitionStyle = .crossDissolve
        present(TBC, animated: true, completion: nil)
    }
    // 조약돌 등록
    @objc func SFSC_DETAIL_VC(_ sender: UIButton) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SEARCH_SFSC_B") as! SEARCH_SFSC_B
        VC.modalTransitionStyle = .crossDissolve
        VC.BEACON_LIST = BEACON_LIST
        present(VC, animated: true, completion: nil)
    }
}
