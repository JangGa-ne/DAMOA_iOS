//
//  SETTING_LOC_UPDATE.swift
//  busan-damoa
//
//  Created by 장 제현 on 2021/03/08.
//  Copyright © 2021 장제현. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

//MARK: 위치 업로드
extension AppDelegate: CLLocationManagerDelegate {
    
    func LOC_UPDATE() {
        
        let MB_ID = UserDefaults.standard.string(forKey: "mb_id") ?? ""
        let MB_TYPE = UserDefaults.standard.string(forKey: "mb_type") ?? ""
        
        if MB_ID != "" && MB_TYPE == "c" {
            
            LOC_MANAGER.requestWhenInUseAuthorization()
            
            // 백그라운드 위치 업데이트 허용
            LOC_MANAGER.allowsBackgroundLocationUpdates = true
            // 자동으로 위치 업데이트 일시 중지
            LOC_MANAGER.pausesLocationUpdatesAutomatically = false
            // 최소 이동 거리
            if UserDefaults.standard.integer(forKey: "loc_slider") == 0 {
                LOC_MANAGER.distanceFilter = 300
            } else {
                LOC_MANAGER.distanceFilter = CLLocationDistance(UserDefaults.standard.integer(forKey: "loc_slider") * 100)
            }
            
            LOC_MANAGER.delegate = self
            LOC_MANAGER.requestAlwaysAuthorization()
            // 위치 업데이트 시작
            LOC_MANAGER.startUpdatingLocation()
            // 중요한 위치 변경 모니터링 시작
            LOC_MANAGER.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        TASK_ID = APP.beginBackgroundTask(expirationHandler: {
            // 백그라운드 시작
            DispatchQueue.main.async { if self.TASK_ID != .invalid { self.APP.endBackgroundTask(self.TASK_ID); self.TASK_ID = .invalid } }
        })
        
        for LOCATION in locations { 
            PUT_POST_DATA(NAME: "자녀위치업로드", ACTION_TYPE: "", COORDINATE: LOCATION.coordinate, ACCURACY: LOCATION.horizontalAccuracy)
        }
        
        // 백그라운드 종료
        DispatchQueue.global(qos: .default).async { DispatchQueue.main.async { self.APP.endBackgroundTask(self.TASK_ID); self.TASK_ID = .invalid } }
    }
    
    //MARK: 위치 업로드
    func PUT_POST_DATA(NAME: String, ACTION_TYPE: String, COORDINATE: CLLocationCoordinate2D, ACCURACY: CLLocationAccuracy) {
        
        let POST_URL: String = "http://damoalbs.pen.go.kr/conn/location/update_loc.php"
        var PARAMETERS: Parameters = [
            "lat": COORDINATE.latitude,
            "lng": COORDINATE.longitude,
            "accuracy": ACCURACY,
            "app_name": "부산교육_다모아_iOS",
            "etc": "s",
        ]
        
        if UIViewController.APPDELEGATE.LOGIN_API.count == 0 {
            PARAMETERS["mb_id"] = UserDefaults.standard.string(forKey: "mb_id") ?? ""
            PARAMETERS["mb_name"] = UserDefaults.standard.string(forKey: "mb_name") ?? ""
        } else {
            PARAMETERS["mb_id"] = UIViewController.APPDELEGATE.LOGIN_API[0].MB_ID
            PARAMETERS["mb_name"] = UIViewController.APPDELEGATE.LOGIN_API[0].MB_NAME
        }
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 15.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseString(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
            print(response)
//
            self.LOCAL_NOTIFICATION(TITLE: "부산교육 다모아", BODY: "[알림] 위치 업로드\nLAT: \(COORDINATE.latitude), LNG: \(COORDINATE.longitude)")
        })
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    // LOCAL
    func LOCAL_NOTIFICATION(TITLE: String, BODY: String) {
        
        let CHECK_CONTENT = UNMutableNotificationContent()
        CHECK_CONTENT.title = TITLE
        CHECK_CONTENT.body = BODY
        CHECK_CONTENT.sound = .default
        
        let TRIGGER = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let REQUEST = UNNotificationRequest(identifier: "\(Int.random(in: 0...10000000))", content: CHECK_CONTENT, trigger: TRIGGER)
        UNUserNotificationCenter.current().add(REQUEST)
    }
}

extension UIViewController {
    
    // 위치 항상 허용
    func LOC_CHECK_ALERT() {
        
        let MB_ID = UserDefaults.standard.string(forKey: "mb_id") ?? ""
        let MB_TYPE = UserDefaults.standard.string(forKey: "mb_type") ?? ""
        
        if MB_ID != "" && MB_TYPE == "c" {
        
            let BADGE = UIButton()
            BADGE.frame = CGRect(x: 47.5, y: 10.0, width: 10.0, height: 10.0)
            BADGE.backgroundColor = .systemRed
            BADGE.layer.cornerRadius = 5.0
            BADGE.clipsToBounds = true
            
            if CLLocationManager.authorizationStatus() != .authorizedAlways {
                
                let ALERT = UIAlertController(title: "\'부산교육다모아\'이(가) \'위치설정\'을(를) 열려고 합니다", message: "자녀안심 서비스를 이용하기 위해 위치 접근 권한을 \'항상\'으로 설정해주세요.", preferredStyle: .alert)
                
                ALERT.addAction(UIAlertAction(title: "열기", style: .default, handler: { (_) in
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                }))
                ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                
                present(ALERT, animated: true, completion: nil)
                
                BADGE.alpha = 1.0
            }
            
            UIViewController.APPDELEGATE.SOSIK_SC_VC?.LOCATION_SETTING.addSubview(BADGE)
            
            if CLLocationManager.authorizationStatus() == .authorizedAlways {
                
                BADGE.alpha = 0.0
                BADGE.removeFromSuperview()
            }
        }
    }
}
