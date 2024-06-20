//
//  DETAIL_SFSC.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/20.
//

import UIKit
import MapKit
import Alamofire

//MARK: - 실시간위치, 이동경로
class DETAIL_SFSC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var REALTIME_LOACTION: Bool = true
    
    var FAMILY_LIST: [FAMILY_BEACON] = []
    var FAMILY_POSITION: Int = 0
    var LOCATION_LIST: [FAMILY_BEACON] = []
    
    var COORDINATE: [CLLocationCoordinate2D] = []
    
    // 내비게이션바
    @IBOutlet weak var NAVI_BG: UIView!
    @IBOutlet weak var NAVI_VIEW: UIView!
    @IBOutlet weak var NAVI_TITLE: UILabel!
    // 맵뷰
    @IBOutlet weak var MAPVIEW: MKMapView!
    
    @IBOutlet weak var BG_VIEW: UIView!
    // 현위치
    @IBOutlet weak var TK_VIEW: UIView!
    @IBOutlet weak var TK_IMAGE: UIImageView!
    @IBOutlet weak var TK_TITLE: UILabel!
    @IBOutlet weak var TRACKING: UIButton!
    // 안내
    @IBOutlet weak var DV_ViEW: UIView!
    @IBOutlet weak var DV_IMAGE: UIImageView!
    @IBOutlet weak var DV_TITLE: UILabel!
    @IBOutlet weak var DRIVING: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로딩 화면
        ON_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR, "데이터 불러오는 중...")
        
        // 내비게이션바
        if REALTIME_LOACTION == true {
            NAVI_TITLE.text = "실시간 위치."
        } else {
            NAVI_TITLE.text = "이동 경로."
        }
        
        // 데이터 삭제
        COORDINATE.removeAll()
        
        // 등급확인
//        if UserDefaults.standard.string(forKey: "mb_type") ?? "c" == "c" {
//            
            // 네트워크 연결 확인
            NETWORK_CHECK()
//        } else {
//
//            OFF_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR)
//
//            DispatchQueue.main.async {
//                let ALERT = UIAlertController(title: "", message: "상대방의 등급이 학부모 또는 교직원으로 되어 있어 위치정보를 볼 수 없습니다.", preferredStyle: .alert)
//                self.present(ALERT, animated: true) {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                }
//            }
//        }
        
        // 맵뷰 연결
        MAPVIEW.delegate = self
        MAPVIEW.showsScale = true
        MAPVIEW.isRotateEnabled = true
        if #available(iOS 13.0, *) { MAPVIEW.overrideUserInterfaceStyle = .light }
        
        BG_VIEW.layer.cornerRadius = 5.0
        BG_VIEW.clipsToBounds = true
        // 현위치
        TK_VIEW.layer.cornerRadius = 5.0
        TK_VIEW.clipsToBounds = true
        TK_VIEW.backgroundColor = .white
        TK_IMAGE.tintColor = .systemBlue
        TK_TITLE.textColor = .systemBlue
        TRACKING.addTarget(self, action: #selector(TRACKING(_:)), for: .touchUpInside)
        // 안내
        DV_ViEW.layer.cornerRadius = 5.0
        DV_ViEW.clipsToBounds = true
        DV_ViEW.backgroundColor = .white
        TK_IMAGE.tintColor = .systemBlue
        TK_TITLE.textColor = .systemBlue
        DRIVING.addTarget(self, action: #selector(DRIVING(_:)), for: .touchUpInside)
    }
    
    // 현위치
    @objc func TRACKING(_ sender: UIButton) {
        
        // 진동 이벤트
        UIImpactFeedbackGenerator().impactOccurred()
        
        switch MAPVIEW.userTrackingMode {
        case .none:
            TK_VIEW.backgroundColor = .systemBlue
            TK_IMAGE.tintColor = .white
            TK_TITLE.textColor = .white
            MAPVIEW.setUserTrackingMode(.follow, animated: true)
            break
        case .follow:
            TK_VIEW.backgroundColor = .YELLOW_FFAC0F
            TK_IMAGE.tintColor = .white
            TK_TITLE.textColor = .white
            MAPVIEW.setUserTrackingMode(.followWithHeading, animated: true)
            break
        case .followWithHeading:
            TK_VIEW.backgroundColor = .white
            TK_IMAGE.tintColor = .systemBlue
            TK_TITLE.textColor = .systemBlue
            MAPVIEW.setUserTrackingMode(.none, animated: true)
            break
        default:
            break
        }
    }
    
    @objc func DRIVING(_ sender: UIButton) {
        
        if LOCATION_LIST.count == 0 {
            
            let ALERT = UIAlertController(title: "위치 데이터 없음", message: "자녀의 위치 데이터가 없을 경우 안내 기능을 사용할 수 없습니다.", preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            present(ALERT, animated: true)
        } else {
            
            let ALERT = UIAlertController(title: "\'부산교육 다모아\'이(가)\n\'지도\'을(를) 열려고 합니다", message: nil, preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "열기", style: .default, handler: { (_) in
                
                let LOCATE = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(self.LOCATION_LIST[0].LAT) ?? 0.0, longitude: Double(self.LOCATION_LIST[0].LNG) ?? 0.0)))
                LOCATE.name = "최근 자녀 위치"
                MKMapItem.openMaps(with: [LOCATE], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }))
            ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            present(ALERT, animated: true, completion: nil)
        }
    }
    
    // 네트워크 연결 확인
    func NETWORK_CHECK() {
        
        if SYSTEM_NETWORK_CHECKING() {
            if REALTIME_LOACTION == true {
                GET_POST_DATA(NAME: "실시간위치", ACTION_TYPE: "")
            } else {
                GET_POST_DATA(NAME: "이동경로", ACTION_TYPE: "")
            }
        } else {
            VIEW_NOTICE("N: 네트워크 상태를 확인해 주세요")
            DispatchQueue.main.async {
                let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                ALERT.addAction(UIAlertAction(title: "새로고침", style: .default) { (_) in self.NETWORK_CHECK() })
                self.present(ALERT, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - 위치 (실시간, 이동경로) 불러오기
    func GET_POST_DATA(NAME: String, ACTION_TYPE: String) {
        
        // 데이터 삭제
        LOCATION_LIST.removeAll()
        
        var POST_URL: String = ""
        
        if REALTIME_LOACTION == true {
            POST_URL = "https://damoalbs.pen.go.kr/conn/location/get_location.php"
        } else {
            POST_URL = "https://damoalbs.pen.go.kr/conn/location/get_history_request.php"
        }
        
        let PARAMETERS: Parameters = [
            "mb_id": FAMILY_LIST[FAMILY_POSITION].FAMILY_ID,
            "req_name": FAMILY_LIST[FAMILY_POSITION].FAMILY_NAME
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
                    if self.LOCATION_LIST.count != 0 { self.LOAD_LOACTION() }
                    self.OFF_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR)
                    return
                }
                
                for (_, DATA) in DATA_ARRAY.enumerated() {
                    
                    let DATA_DICT = DATA as? [String: Any]
                    let APPEND_VALUE = FAMILY_BEACON()
                    
                    APPEND_VALUE.SET_ACCURACY(ACCURACY: DATA_DICT?["accuracy"] as Any)
                    APPEND_VALUE.SET_LAT(LAT: DATA_DICT?["lat"] as Any)
                    APPEND_VALUE.SET_LNG(LNG: DATA_DICT?["lng"] as Any)
                    APPEND_VALUE.SET_MB_ID(MB_ID: DATA_DICT?["mb_id"] as Any)
                    APPEND_VALUE.SET_MB_NAME(MB_NAME: DATA_DICT?["mb_name"] as Any)
                    APPEND_VALUE.SET_REG_DATE(REG_DATE: DATA_DICT?["reg_date"] as Any)
                    // 데이터 추가
                    self.LOCATION_LIST.append(APPEND_VALUE)
                }
                
                if self.LOCATION_LIST.count != 0 { self.LOAD_LOACTION() }
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.VIEW_NOTICE("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.VIEW_NOTICE("E: 네트워크 연결 실패 (000)"); self.NETWORK_CHECK() }
                
                self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
            }
            
            self.OFF_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR)
        })
    }
    
    func LOAD_LOACTION() {
        
        if LOCATION_LIST.count == 0 {
            
//            Last_Time.text = "최근 업데이트 없음."
        } else {
            
            // 특수 효과 제거
            let ANNOTATIONS = MAPVIEW.annotations
            MAPVIEW.removeAnnotations(ANNOTATIONS)
            
            for i in 0 ..< LOCATION_LIST.count {

                let DATA = LOCATION_LIST[i]

                // 특수 효과 만들기
                let ANNOTATION = MKPointAnnotation()
                ANNOTATION.title = DATA.REG_DATE
                ANNOTATION.subtitle = "오차범위 \(Int(floor(Double(DATA.ACCURACY) ?? 0.0)))m"
                ANNOTATION.coordinate = CLLocationCoordinate2D(latitude: Double(DATA.LAT) ?? 0.0, longitude: Double(DATA.LNG) ?? 0.0)
                MAPVIEW.addAnnotation(ANNOTATION)
                
                COORDINATE.append(CLLocationCoordinate2D(latitude: Double(DATA.LAT) ?? 0.0, longitude: Double(DATA.LNG) ?? 0.0))
            }
            
            let DATA = LOCATION_LIST[0]
            
//            Accuracy.text = "오차범위 \(Int(floor(Double(DATA.ACCURACY) ?? 0.0)))m"
//            Last_Time.text = "최근 업데이트 : \(DATA.REG_DATE)"
            
            // 특수 효과 확대
            let CENTER = CLLocationCoordinate2D(latitude: Double(DATA.LAT) ?? 0.0, longitude: Double(DATA.LNG) ?? 0.0)
            let SPAN = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let REGION = MKCoordinateRegion(center: CENTER, span: SPAN)
            MAPVIEW.setRegion(REGION, animated: true)
            
            // 라인
            let LINE = MKPolyline(coordinates: COORDINATE, count: COORDINATE.count)
            MAPVIEW.addOverlay(LINE)
        }
    }
    
//    //MARK: - 내비게이션
//    func LOAD_LOACTION_2() {
//
//        for i in 0 ..< LOCATION_LIST.count {
//
//            if i == 0 || i == LOCATION_LIST.count - 1 {
//                COORDINATE.append(CLLocationCoordinate2D(latitude: Double(LOCATION_LIST[i].LAT) ?? 0.0, longitude: Double(LOCATION_LIST[i].LNG) ?? 0.0))
//            }
//        }
//
//        if COORDINATE.count >= 2 {
//
//            let SOURCE_PLACEMARK = MKPlacemark(coordinate: COORDINATE[0], addressDictionary: nil)
//            let SOURCE_MAPITEM = MKMapItem(placemark: SOURCE_PLACEMARK)
//            let SOURCE_ANNTATION = MKPointAnnotation()
//            if let LOCATION = SOURCE_PLACEMARK.location { SOURCE_ANNTATION.coordinate = LOCATION.coordinate }
//
//            let DESTINATION_PLACEMARK = MKPlacemark(coordinate: COORDINATE[1], addressDictionary: nil)
//            let DESTINATION_MAPITEM = MKMapItem(placemark: DESTINATION_PLACEMARK)
//            let DESTINATION_ANNTATION = MKPointAnnotation()
//            if let LOCATION = SOURCE_PLACEMARK.location { DESTINATION_ANNTATION.coordinate = LOCATION.coordinate }
//
//            MAPVIEW.showAnnotations([SOURCE_ANNTATION, DESTINATION_ANNTATION], animated: true)
//
//            let DIRECTION_REQUEST = MKDirections.Request()
//            DIRECTION_REQUEST.source = SOURCE_MAPITEM
//            DIRECTION_REQUEST.destination = DESTINATION_MAPITEM
//            DIRECTION_REQUEST.transportType = .automobile
//
//            let DIRECTIONS = MKDirections(request: DIRECTION_REQUEST)
//            DIRECTIONS.calculate { (response, error) in
//
//                guard let RESPONSE = response else { if let ERROR = error { print("ERROR: \(ERROR)") }; return }
//
//                let ROUTE = RESPONSE.routes[0]
//                self.MAPVIEW.addOverlay((ROUTE.polyline), level: .aboveRoads)
//
//                let RECT = ROUTE.polyline.boundingMapRect
//                self.MAPVIEW.setRegion(MKCoordinateRegion(RECT), animated: true)
//            }
//        }
//    }
}

extension DETAIL_SFSC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let LINE_RENDER = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        LINE_RENDER.strokeColor = .systemBlue
        LINE_RENDER.lineWidth = 4.0
        return LINE_RENDER
    }
}
