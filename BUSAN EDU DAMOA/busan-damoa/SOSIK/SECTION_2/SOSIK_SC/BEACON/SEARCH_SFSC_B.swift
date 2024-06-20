//
//  SEARCH_SFSC_B.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/18.
//

import UIKit
import CoreLocation

class SEARCH_SFSC_B_TC: UITableViewCell {
    
    @IBOutlet weak var LOCATION_SWITCH: UISwitch!                       // 위치설정 스위치
    @IBOutlet weak var LOADING_TITLE: UILabel!                          // 로딩 인디케이터
    @IBOutlet weak var LOADING_INDICATOR: UIActivityIndicatorView!      // 로딩 인디케이터
    @IBOutlet weak var COIN_NAME: UILabel!                              // 조약돌 이름
    @IBOutlet weak var CHECK_SELECTED: UILabel!                         // 등록 확인
    @IBOutlet weak var COIN_INFO: UIButton!                             // 조약돌 정보
    @IBOutlet weak var REFRESH: UIButton!                               // 새로고침
}

//MARK: - 조약돌 검색
class SEARCH_SFSC_B: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { STOP_BEACON_SEARCH(); dismiss(animated: true, completion: nil) }
    
    let TRANSITION = SLIDE_IN_TRANSITION()
    
    var BEACON_LIST: [FAMILY_BEACON] = []
    var BEACON_POSITION: Int = 0
    
    // 위치(조약돌)
    var LOC_MANAGER = CLLocationManager()
    var BEACONS: [CLBeaconRegion] = []
    var TIMER: Timer?
    var INDICATOR_ANIMATION: Bool = true
    var FIND_BEACON_LIST: [String: CLBeacon] = [:]
    var BEACON_KEY: Array<Any> = []
    
    // 내비게이션바
    @IBOutlet weak var NAVI_BG: UIView!
    @IBOutlet weak var NAVI_VIEW: UIView!
    @IBOutlet weak var NAVI_TITLE: UILabel!
    // 테이블뷰
    @IBOutlet weak var TABLEVIEW: UITableView!
    // 위치 설정
    @IBOutlet weak var LOCATION_SETTING: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 내비게이션바
        NAVI_TITLE.alpha = 0.0
        
        // 위치(조약돌)
        LOC_MANAGER.delegate = self
        LOC_MANAGER.pausesLocationUpdatesAutomatically = false
        LOC_MANAGER.requestWhenInUseAuthorization()
        // 조약돌(UUID)
        BEACONS.append(CLBeaconRegion(proximityUUID: UUID(uuidString: "684C5008-F4C7-4065-88A3-CEFB951448C9")!, identifier: "MILK"))
//        BEACONS.append(CLBeaconRegion(proximityUUID: UUID(uuidString: "8B5A3D0F-83F2-4232-AA92-CC53E59754DF")!, identifier: "CHECK"))
        //MARK: - 조약돌 검색 시작
        START_BEACON_SEARCH()
        
        // 테이블뷰 연결
        TABLEVIEW.delegate = self
        TABLEVIEW.dataSource = self
        TABLEVIEW.separatorStyle = .none
        
        // 위치 설정
        LOCATION_SETTING.addTarget(self, action: #selector(LOCATION_SETTING(_:)), for: .touchUpInside)
    }
    
    //MARK: - 조약돌 검색 시작
    @objc func START_BEACON_SEARCH() {
        
        let STATUS = CLLocationManager.authorizationStatus()
        if !((STATUS == .authorizedWhenInUse) || (STATUS == .authorizedAlways)) {
            
            INDICATOR_ANIMATION = false
            
            DispatchQueue.main.async {
                
                let ALERT = UIAlertController(title: "검색 할 수 없음.", message: "\'조약돌\'을(를) 검색하기 위해 위치 접근 권한을 \'앱을 사용하는 동안\' 또는 \'항상 허용\'으로 설정해 주세요.", preferredStyle: .alert)
                ALERT.addAction(UIAlertAction(title: "설정", style: .default, handler: { (_) in
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                }))
                ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                self.present(ALERT, animated: true, completion: nil)
            }
            
            TABLEVIEW.reloadData()
        } else {
            
            INDICATOR_ANIMATION = true
            
            FIND_BEACON_LIST.removeAll()
            BEACON_KEY.removeAll()
            
            for i in 0 ..< BEACONS.count {
                LOC_MANAGER.startMonitoring(for: BEACONS[i])
                LOC_MANAGER.startRangingBeacons(in: BEACONS[i])
            }
            
            TABLEVIEW.reloadData()
        }
    }
    
    //MARK: - 조약돌 검색 종료
    @objc func STOP_BEACON_SEARCH() {
        
        INDICATOR_ANIMATION = false
        
        for i in 0 ..< BEACONS.count {
            LOC_MANAGER.stopMonitoring(for: BEACONS[i])
            LOC_MANAGER.stopRangingBeacons(in: BEACONS[i])
        }
        
        TABLEVIEW.reloadData()
    }
    
    //MARK: - 위치 설정
    @objc func LOCATION_SETTING(_ sender: UIButton) {
        
        // 진동 이벤트
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        let ALERT = UIAlertController(title: "\'부산교육 다모아\'이(가) \'위치설정\'을(를) 열려고 합니다", message: "\'조약돌\'을(를) 검색하기 위해 위치 접근 권한을 \'앱을 사용하는 동안\' 또는 \'항상 허용\'으로 설정해 주세요.", preferredStyle: .alert)
        ALERT.addAction(UIAlertAction(title: "열기", style: .default, handler: { (_) in
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(ALERT, animated: true, completion: nil)
    }
}

extension SEARCH_SFSC_B: UIScrollViewDelegate {
    
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

extension SEARCH_SFSC_B: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        TIMER = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(STOP_BEACON_SEARCH), userInfo: nil, repeats: false)
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        STOP_BEACON_SEARCH()
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        STOP_BEACON_SEARCH()
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        for BEACON in beacons {
            if BEACON.accuracy < 2 {
                let BC: String = "\(BEACON.major),\(BEACON.minor)"
                if !(FIND_BEACON_LIST.keys.contains(BC)) { FIND_BEACON_LIST[BC] = BEACON; BEACON_KEY.append(BC) }
                TABLEVIEW.reloadData()
            }
        }
    }
}

extension SEARCH_SFSC_B: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let SWITCH = UserDefaults.standard.bool(forKey: "loc_switch")
        
        if section == 0 {
            return 1
        } else if SWITCH == true && section == 1 {
            if FIND_BEACON_LIST.count == 0 {
                return 0
            } else {
                return FIND_BEACON_LIST.count
            }
        } else if SWITCH == true && section == 2 && INDICATOR_ANIMATION == false {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SEARCH_SFSC_B_TC_T", for: indexPath) as! SEARCH_SFSC_B_TC
            
            // 위치설정 스위치
            CELL.LOCATION_SWITCH.isOn = UserDefaults.standard.bool(forKey: "loc_switch")
            CELL.LOCATION_SWITCH.addTarget(self, action: #selector(SWITCH(_:)), for: .touchUpInside)
            
            if UserDefaults.standard.bool(forKey: "loc_switch") == true {
                CELL.LOADING_TITLE.isHidden = false
                CELL.LOADING_INDICATOR.isHidden = false
                // 로딩 인디케이터
                if INDICATOR_ANIMATION == true {
                    CELL.LOADING_INDICATOR.isHidden = false
                    CELL.LOADING_INDICATOR.startAnimating()
                } else {
                    CELL.LOADING_INDICATOR.isHidden = true
                    CELL.LOADING_INDICATOR.stopAnimating()
                }
            } else {
                CELL.LOADING_TITLE.isHidden = true
                CELL.LOADING_INDICATOR.isHidden = true
            }
            
            return CELL
        } else if indexPath.section == 1 {
            
            let DATA = FIND_BEACON_LIST["\(BEACON_KEY[indexPath.item])"]!
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SEARCH_SFSC_B_TC", for: indexPath) as! SEARCH_SFSC_B_TC
            
            // 조약돌 이름
            CELL.COIN_NAME.text = "MILK (major: \(DATA.major), minor: \(DATA.minor))"
            // 등록확인
            var CHECK: Bool = false
            for BEACON in BEACON_LIST {
            
                if "\(DATA.major)".contains(BEACON.DEVICE_MAJOR) && "\(DATA.minor)".contains(BEACON.DEVICE_MINOR) {
                    CHECK = true
                }
            }
            if CHECK == true { CELL.CHECK_SELECTED.text = "등록됨" } else { CELL.CHECK_SELECTED.text = "등록 안 됨" }
            
            return CELL
        } else {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SEARCH_SFSC_B_TC_R", for: indexPath) as! SEARCH_SFSC_B_TC
            
            CELL.REFRESH.addTarget(self, action: #selector(START_BEACON_SEARCH), for: .touchUpInside)
            
            return CELL
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let DATA = FIND_BEACON_LIST["\(BEACON_KEY[indexPath.item])"]!
            
            // 등록 확인
            var CHECK: Bool = false
            for BEACON in BEACON_LIST {
            
                if "\(DATA.major)".contains(BEACON.DEVICE_MAJOR) && "\(DATA.minor)".contains(BEACON.DEVICE_MINOR) {
                    CHECK = true
                }
            }
            
            if CHECK == true {
                
                VIEW_NOTICE("F: 이미 등록된 조약돌")
            } else {
                
                // 진동 이벤트
                UIImpactFeedbackGenerator().impactOccurred()
                
                let ALERT = UIAlertController(title: "조약돌(iBeacon) 등록 요청", message: "'MILK (major: \(DATA.major), minor: \(DATA.minor))'이(가) 사용자의 iPhone에 등록하려고 합니다.", preferredStyle: .alert)
                ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                ALERT.addAction(UIAlertAction(title: "등록", style: .default) { (_) in

                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "SUBMIT_SFSC_B") as! SUBMIT_SFSC_B
                    VC.modalPresentationStyle = .overCurrentContext
                    VC.transitioningDelegate = self
                    VC.FIND_BEACON_LIST = self.FIND_BEACON_LIST
                    VC.BEACON_KEY = self.BEACON_KEY
                    VC.BC_POSITION = indexPath.item
                    VC.didTabBackType = { BACK_TYPE in if BACK_TYPE.rawValue == 0 { self.dismiss(animated: true, completion: nil) } }
                    self.present(VC, animated: true, completion: nil)
                })
                present(ALERT, animated: true, completion: nil)
            }
        }
    }
    
    // 위치설정 스위치
    @objc func SWITCH(_ sender: UISwitch) {
        
        if sender.isOn == true { START_BEACON_SEARCH() } else { STOP_BEACON_SEARCH() }
        UserDefaults.standard.setValue(sender.isOn, forKey: "loc_switch")
        UserDefaults.standard.synchronize()
        TABLEVIEW.reloadData()
    }
}
