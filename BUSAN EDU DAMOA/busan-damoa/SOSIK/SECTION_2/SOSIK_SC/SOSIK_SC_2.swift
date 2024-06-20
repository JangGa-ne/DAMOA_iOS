//
//  SOSIK_SC_2.swift
//  busan-damoa
//
//  Created by 장제현 on 2020/05/23.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import MapKit

// 자녀안심_학교폭력신고상담
class SOSIK_SC_2: UIViewController, MKMapViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    var WEECENTER_API: [WEECENTER_DATA] = []
    var WEECENTER_POSITION = 0

    @IBOutlet weak var MapView: MKMapView!
    
    @IBOutlet weak var Center_Name: UILabel!
    @IBOutlet weak var Center_Address: UILabel!
    
    @IBAction func Center_Call(_ sender: UIButton) {
        
        let DATA = WEECENTER_API[WEECENTER_POSITION]
        UIApplication.shared.open(URL(string: "tel://" + DATA.CENTER_NUM)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapView.delegate = self
        // 스케일을 표시한다.
        MapView.showsScale = true
        // 회전 가능 여부
        MapView.isRotateEnabled = true
        if #available(iOS 13.0, *) { MapView.overrideUserInterfaceStyle = .light }
        
        let DATA = WEECENTER_API[WEECENTER_POSITION]
        
        Center_Name.text = DATA.CENTER_NAME
        Center_Address.text = DATA.CENTER_ADDRESS
        
        // 특수 효과 제거
        let ANNOTATIONS = MapView.annotations
        MapView.removeAnnotations(ANNOTATIONS)
        
        // 특수 효과 만들기
        let ANNOTATION = MKPointAnnotation()
        ANNOTATION.title = DATA.CENTER_NAME
        ANNOTATION.coordinate = CLLocationCoordinate2D(latitude: Double(DATA.CENTER_LAT) ?? 0.0, longitude: Double(DATA.CENTER_LNG) ?? 0.0)
        MapView.addAnnotation(ANNOTATION)
        
        // 특수 효과 확대
        let coordinate = CLLocationCoordinate2D(latitude: Double(DATA.CENTER_LAT) ?? 0.0, longitude: Double(DATA.CENTER_LNG) ?? 0.0)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        MapView.setRegion(region, animated: true)
    }
}
