//
//  SCHOOL_VIOLENCE_COUNSELING.swift
//  부산교육 다모아
//
//  Created by i-Mac on 2020/06/26.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class SCHOOL_VIOLENCE_COUNSELING: UIViewController, UIScrollViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    var WEECENTER_API: [WEECENTER_DATA] = []
    var WEECENTER_POSITION = 0
    
    @IBOutlet weak var Navi_Title: UILabel!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var TITLE_VIEW_BG: UIView!
    @IBOutlet weak var TITLE_VIEW: UIView!
    var ALERT = UIAlertController()
    
    let VIEW = UIView()
    override func loadView() {
        super.loadView()
        
        CHECK_VERSION(Navi_Title)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navi_Title.alpha = 0.0
        ScrollView.delegate = self
        
//        if !DEVICE_RATIO() {
//            Navi_Title.alpha = 1.0
//            TITLE_VIEW.frame.size.height = 0.0
//            TITLE_VIEW.clipsToBounds = true
//        } else {
//            Navi_Title.alpha = 0.0
//            TITLE_VIEW.frame.size.height = 52.0
//            TITLE_VIEW.clipsToBounds = false
//        }
        
//        WeeClassSchool_Name.text = ""
        
        Search_WeeClassSchool_Button.layer.cornerRadius = 5.0
        Search_WeeClassSchool_Button.clipsToBounds = true
    }
    
    // 117전화
    @IBAction func Call_Button(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "tel://" + "117")!)
    }
    // 117문자
    @IBAction func Message_Button(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "sms://" + "117")!)
    }
    // 117CHAT
    @IBAction func Chat_Button(_ sender: UIButton) {
        
        let CHAT_URL: Bool = UIApplication.shared.canOpenURL(URL(string: "117chat://")!)
        
        if CHAT_URL {
            
            UIApplication.shared.open(URL(string: "117chat://")!)
        } else {
            
            let ALERT = UIAlertController(title: "스키마가 등록되지 않았습니다.", message: nil, preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            present(ALERT, animated: true)
        }
        
    }
    
    // 117학교폭력상담
    @IBAction func CallCenter_Button(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "tel://" + "1388")!)
    }
    
    // WEE센터검색
    @IBOutlet weak var WeeClassSchool_Name: UILabel!
    @IBOutlet weak var Search_WeeClassSchool_Button: UIButton!
    @IBAction func Search_WeeClassSchool_Button(_ sender: UIButton) {
        
        let WEE_CENTER = DATA_URL().SCHOOL_URL + "school/wee_center.php"
                    
        let PARAMETERS: Parameters = [ "sc_name": "" ] // WeeClassSchool_Name.text! ]
        
        print("PARAMETERS -", PARAMETERS)
        
        Alamofire.request(WEE_CENTER, method: .post, parameters: PARAMETERS).responseJSON { response in
            
//            print("[WEE센터]", response)
            self.WEECENTER_API.removeAll()
            
            guard let WEECENTER_ARRAY = response.result.value as? Array<Any> else {
                
                print("[WEE센터] FAIL")
                return
            }
            
            for (_, DATA) in WEECENTER_ARRAY.enumerated() {
                
                let DATADICT = DATA as? [String: Any]
                
                let POST_WEECENTER_DATA = WEECENTER_DATA()
                
                POST_WEECENTER_DATA.SET_SC_NAME(SC_NAME: DATADICT?["sc_name"] as Any)
                POST_WEECENTER_DATA.SET_CENTER_ADDRESS(CENTER_ADDRESS: DATADICT?["center_address"] as Any)
                POST_WEECENTER_DATA.SET_CENTER_LAT(CENTER_LAT: DATADICT?["center_lat"] as Any)
                POST_WEECENTER_DATA.SET_CENTER_LNG(CENTER_LNG: DATADICT?["center_lng"] as Any)
                POST_WEECENTER_DATA.SET_CENTER_NUM(CENTER_NUM: DATADICT?["center_num"] as Any)
                POST_WEECENTER_DATA.SET_CENTER_NAME(CENTER_NAME: DATADICT?["center_name"] as Any)
                
                self.WEECENTER_API.append(POST_WEECENTER_DATA)
            }
            
            let VC = UIViewController()
            let TV = UITableView()

            self.ALERT = UIAlertController(title: "학교 목록", message: "학교를 선택해 주세요.", preferredStyle: .alert)

            if WEECENTER_ARRAY.count < 4 {

                let RECT: CGRect = CGRect(x: 0, y: 0, width: self.ALERT.view.frame.size.width, height: 100)
                VC.preferredContentSize = RECT.size
                TV.frame = RECT
            } else if WEECENTER_ARRAY.count < 6 {

                let RECT: CGRect = CGRect(x: 0, y: 0, width: self.ALERT.view.frame.size.width, height: 150)
                VC.preferredContentSize = RECT.size
                TV.frame = RECT
            } else {

                let RECT: CGRect = CGRect(x: 0, y: 0, width: self.ALERT.view.frame.size.width, height: 200)
                VC.preferredContentSize = RECT.size
                TV.frame = RECT
            }

            VC.view.addSubview(TV)
            VC.view.bringSubviewToFront(TV)

            self.ALERT.setValue(VC, forKey: "contentViewController")

            TV.reloadData()

            let CANCEL = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
            self.ALERT.addAction(CANCEL)
            CANCEL.setValue(UIColor.red, forKey: "titleTextColor")

            self.present(self.ALERT, animated: true)

            TV.delegate = self
            TV.dataSource = self
        }
    }
    
    var CENTER_NUM: String = ""
    var CENTER_LAT: String = ""
    var CENTER_LNG: String = ""
    
    // 전화걸기
    @IBAction func Weecenter_Call(_ sender: UIButton) {
        
        if CENTER_NUM == "" {
            let ALERT = UIAlertController(title: "학교를 선택해 주세요.", message: nil, preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(ALERT, animated: true)
        } else {
            UIApplication.shared.open(URL(string: "tel://" + CENTER_NUM)!)
        }
    }
    // 위치찾기
    @IBAction func Weecenter_Map(_ sender: UIButton) {
        
        if CENTER_LAT == "" || CENTER_LNG == "" {
            let ALERT = UIAlertController(title: "학교를 선택해 주세요.", message: nil, preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(ALERT, animated: true)
        } else {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SOSIK_SC_2") as! SOSIK_SC_2
            VC.modalTransitionStyle = .crossDissolve
            VC.WEECENTER_API = WEECENTER_API
            VC.WEECENTER_POSITION = WEECENTER_POSITION
            present(VC, animated: true, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        if DEVICE_RATIO() {
            if ScrollView.contentOffset.y <= 0 {
                Navi_Title.alpha = 0.0
            } else if ScrollView.contentOffset.y <= 34 {
                Navi_Title.alpha = 0.0
            } else if ScrollView.contentOffset.y <= 38 {
                Navi_Title.alpha = 0.2
            } else if ScrollView.contentOffset.y <= 42 {
                Navi_Title.alpha = 0.4
            } else if ScrollView.contentOffset.y <= 46 {
                Navi_Title.alpha = 0.6
            } else if ScrollView.contentOffset.y <= 50 {
                Navi_Title.alpha = 0.8
            } else {
                Navi_Title.alpha = 1.0
            }
//        }
    }
}

extension SCHOOL_VIOLENCE_COUNSELING: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if WEECENTER_API.count == 0 { return 0 } else { return WEECENTER_API.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var CELL: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")

        if CELL == nil { CELL = UITableViewCell(style: .default, reuseIdentifier: "cell") }
        CELL!.textLabel!.text = WEECENTER_API[indexPath.item].SC_NAME

        return CELL!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let DATA = WEECENTER_API[indexPath.item]
        
        WeeClassSchool_Name.text = DATA.SC_NAME
        CENTER_NUM = DATA.CENTER_NUM
        CENTER_LAT = DATA.CENTER_LAT
        CENTER_LNG = DATA.CENTER_LNG
        WEECENTER_POSITION = indexPath.item
        ALERT.dismiss(animated: true, completion: nil)
    }
}
