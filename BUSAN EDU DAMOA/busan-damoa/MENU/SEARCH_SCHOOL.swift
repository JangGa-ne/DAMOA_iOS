//
//  SEARCH_SCHOOL.swift
//  부산교육 다모아
//
//  Created by 장제현 on 2020/06/29.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class SEARCH_SCHOOL: UIViewController, MKMapViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    var SEARCH_SCHOOL_API: [SEARCH_SOSIK_API] = []
    
    let LOCATION_MANAGER = CLLocationManager()
    var MY_LOCATION = CLLocationCoordinate2D()
    
    @IBOutlet weak var Navi_Title: UILabel!
    @IBOutlet weak var MapView: MKMapView!
    
    // 로딩인디케이터
    let VIEW = UIView()
    override func loadView() {
        super.loadView()
        
        EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "Logo.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
        CHECK_VERSION(Navi_Title)
    }

    @IBOutlet weak var DETAIL_VIEW: UIView!
    @IBOutlet weak var DETAIL_STACKVIEW: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DETAIL_VIEW.alpha = 0.0
        DETAIL_STACKVIEW.alpha = 0.0
        
        LOCATION_MANAGER.pausesLocationUpdatesAutomatically = false
        LOCATION_MANAGER.requestWhenInUseAuthorization()
        
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
        } else {
            HTTP_SEARCH_SCHOOL(LAT: LOCATION_MANAGER.location?.coordinate.latitude ?? 0.0, LNG: LOCATION_MANAGER.location?.coordinate.longitude ?? 0.0)
        }
        
        // 트래킹 지원
        MapView.setUserTrackingMode(.follow, animated: true)
        
        MapView.delegate = self
        // 스케일을 표시한다.
        MapView.showsScale = true
        // 회전 가능 여부
        MapView.isRotateEnabled = true
        if #available(iOS 13.0, *) { MapView.overrideUserInterfaceStyle = .light }
    }
    
    func HTTP_SEARCH_SCHOOL(LAT: Double, LNG: Double) {
        
        let GET_LOACTION = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(LAT),\(LNG)&radius=3000&sensor=false&language=ko&key=AIzaSyB7LDRjki-RZgn8X7Fr9S0GYZnbyHMGnrQ&types=school"
        
        print(GET_LOACTION)
        
        Alamofire.request(GET_LOACTION, method: .post, parameters: nil).responseJSON { response in
            
            print("주변학교찾기", response)
            
            guard let SEARCHDICT = response.result.value as? [String: Any] else {
                
                self.CLOSE_EFFECT_INDICATOR_VIEW(VIEW: self.VIEW)
                print("주변학교찾기 [FAIL]")
                return
            }
            
            guard let SEARCH_ARRAY = SEARCHDICT["results"] as? Array<Any> else {
                
                self.CLOSE_EFFECT_INDICATOR_VIEW(VIEW: self.VIEW)
                self.NOTIFICATION_VIEW("주변에 학교가 없습니다")
                print("주변학교찾기 [FAIL]")
                return
            }
            
            for (_, DATA) in SEARCH_ARRAY.enumerated() {
                
                let POST_SEARCH_SOSIK_API = SEARCH_SOSIK_API()
                
                let DATADICT = DATA as? [String: Any]
                
                let GEOMETRY = DATADICT?["geometry"] as? [String: Any]
                let LOCATION = GEOMETRY?["location"] as? [String: Any]
                POST_SEARCH_SOSIK_API.SET_LAT(LAT: LOCATION?["lat"] as Any)
                POST_SEARCH_SOSIK_API.SET_LNG(LNG: LOCATION?["lng"] as Any)
                
                POST_SEARCH_SOSIK_API.SET_PLACE_NAME(PLACE_NAME: DATADICT?["name"] as Any)
                POST_SEARCH_SOSIK_API.SET_PLACE_ADDRESS(PLACE_ADDRESS: DATADICT?["vicinity"] as Any)
                
                self.SEARCH_SCHOOL_API.append(POST_SEARCH_SOSIK_API)
            }
            
            self.LOAD_LOACTION()
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.VIEW.alpha = 0.0
            }, completion: {(isCompleted) in
                self.VIEW.removeFromSuperview()
            })
        }
    }
    
    func LOAD_LOACTION() {
        
        // 특수 효과 제거
        let ANNOTATIONS = self.MapView.annotations
        self.MapView.removeAnnotations(ANNOTATIONS)
        
        for i in 0 ..< SEARCH_SCHOOL_API.count {
            
            let DATA = SEARCH_SCHOOL_API[i]
            
            if DATA.PLACE_NAME.contains("유치원") || DATA.PLACE_NAME.contains("초등학교") || DATA.PLACE_NAME.contains("중학교") || DATA.PLACE_NAME.contains("고등학교") {
            
                let ANNOTATION = MKPointAnnotation()
                ANNOTATION.title = DATA.PLACE_NAME
                ANNOTATION.subtitle = DATA.PLACE_ADDRESS
                ANNOTATION.coordinate = CLLocationCoordinate2D(latitude: DATA.LAT, longitude: DATA.LNG)
                self.MapView.addAnnotation(ANNOTATION)
            }
        }
        
        // 특수 효과 확대
        let COORDINATE = CLLocationCoordinate2D(latitude: LOCATION_MANAGER.location?.coordinate.latitude ?? 0.0, longitude: LOCATION_MANAGER.location?.coordinate.longitude ?? 0.0)
        let SPAN = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let REGION = MKCoordinateRegion(center: COORDINATE, span: SPAN)
        MapView.setRegion(REGION, animated: true)
    }
    
    var LAT: Double = 0.0
    var LNG: Double = 0.0
    var SCHOOL_NAME: String = ""
    @IBOutlet weak var SC_NAME: UILabel!
    @IBOutlet weak var SC_ADDRESS: UILabel!
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        LAT = view.annotation?.coordinate.latitude ?? 0.0
        LNG = view.annotation?.coordinate.longitude ?? 0.0
        SCHOOL_NAME = view.annotation?.title as? String ?? ""
        SC_NAME.text = view.annotation?.title as? String ?? ""
        SC_ADDRESS.text = view.annotation?.subtitle as? String ?? ""
        
        UIView.animate(withDuration: 0.2, animations: {
            self.DETAIL_VIEW.alpha = 1.0
            self.DETAIL_STACKVIEW.alpha = 1.0
        })
    }
    
    @IBAction func Load_Driving(_ sender: UIButton) {

        if SEARCH_SCHOOL_API.count == 0 {

            let ALERT = UIAlertController(title: "위치 데이터 없음", message: "학교 위치 데이터가 없을 경우 안내 기능을 사용할 수 없습니다.", preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            present(ALERT, animated: true)
        } else {

            if LAT != 0.0 && LNG != 0.0 && SCHOOL_NAME != "" {
                
                let OFFICE = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: LAT, longitude: LNG)))
                OFFICE.name = SCHOOL_NAME
                MKMapItem.openMaps(with: [OFFICE], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }
        }
    }
}
