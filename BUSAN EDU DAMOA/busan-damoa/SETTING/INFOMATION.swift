//
//  INFOMATION.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/05/13.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import MapKit

class INFOMATION_TC: UITableViewCell {
    
}

class INFOMATION: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func Back_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }

    @IBOutlet weak var Navi_BG: UIView!
    @IBOutlet weak var Navi_Title: UILabel!
    
    @IBOutlet weak var TableView: UITableView!
    
    override func loadView() {
        super.loadView()
        
        CHECK_VERSION(Navi_Title)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navi_Title.alpha = 0.0
        
        TableView.delegate = self
        TableView.dataSource = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        SCROLL_EDIT(TABLE_VIEW: TableView, NAVI_TITLE: Navi_Title)
    }
}

extension INFOMATION: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "INFOMATION_TC_T", for: indexPath) as! INFOMATION_TC
            
            return CELL
        } else {
            
            if indexPath.item == 0 {
                
                let CELL = tableView.dequeueReusableCell(withIdentifier: "INFOMATION_TC", for: indexPath) as! INFOMATION_TC
                
                return CELL
            // 전화
            } else if indexPath.item == 1 {
                
                let CELL = tableView.dequeueReusableCell(withIdentifier: "INFOMATION_TC_1", for: indexPath) as! INFOMATION_TC
                
                return CELL
            // 사이트
            } else if indexPath.item == 2 {
                
                let CELL = tableView.dequeueReusableCell(withIdentifier: "INFOMATION_TC_2", for: indexPath) as! INFOMATION_TC
                
                return CELL
            // 지도
            } else if indexPath.item == 3 {
                
                let CELL = tableView.dequeueReusableCell(withIdentifier: "INFOMATION_TC_3", for: indexPath) as! INFOMATION_TC
                
                return CELL
            } else {
                
                let CELL = tableView.dequeueReusableCell(withIdentifier: "INFOMATION_TC_4", for: indexPath) as! INFOMATION_TC
                
                return CELL
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            // 전화
            if indexPath.item == 1 {
                UIApplication.shared.open(URL(string: "tel://" + "051-860-0114")!)
            // 사이트
            } else if indexPath.item == 2 {
                UIApplication.shared.open(URL(string: "http://pen.go.kr")!)
            // 지도
            } else if indexPath.item == 3 {
                
                let OFFICE = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 35.176284, longitude: 129.06477)))
                OFFICE.name = "장 제현"
                
                MKMapItem.openMaps(with: [OFFICE], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
