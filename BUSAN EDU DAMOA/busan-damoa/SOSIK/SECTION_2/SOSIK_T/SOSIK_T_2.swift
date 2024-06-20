//
//  SOSIK_T_2.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/06/12.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class SOSIK_T_2: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // 화면 다른곳 터치하면 키보드 사라짐
        view.endEditing(true)
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    var WEECENTER_API: [WEECENTER_DATA] = []
    var WEECENTER_POSITION = 0
    
    var IDX: String = ""
    
    var CLASS_TITLE: [String] = ["연수명", "연수일시", "장소", "상태"]
    var CLASS_CONTENT: [String] = []
    var CONTENT: [String] = []
    
    @IBOutlet weak var Navi_Title: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var TITLE_VIEW_BG: UIView!
    @IBOutlet weak var TITLE_VIEW: UIView!
    
    @IBOutlet weak var Password: UITextField!
    
    // 수정하기
    @IBOutlet weak var Modify_Button: UIButton!
    @IBAction func Modify_Button(_ sender: UIButton) {
        
        if Password.text == "" {
            NOTIFICATION_VIEW("비밀번호를 입력해주세요")
        } else {
            if !SYSTEM_NETWORK_CHECKING() {
                NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
            } else {
                HTTP_MODIFY(IDX: IDX, INSERT_APPLY: DATA_URL().SCHOOL_URL + "school/insert_apply_edit.php", MODIFY: true)
            }
        }
    }
    
    // 수강취소
    @IBOutlet weak var Cancel_Button: UIButton!
    @IBAction func Cancel_Button(_ sender: UIButton) {
        
        if Password.text == "" {
            NOTIFICATION_VIEW("비밀번호를 입력해주세요")
        } else {
            if !SYSTEM_NETWORK_CHECKING() {
                NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
            } else {
                HTTP_MODIFY(IDX: IDX, INSERT_APPLY: DATA_URL().SCHOOL_URL + "school/insert_apply_delete.php", MODIFY: false)
            }
        }
    }
    
    func HTTP_MODIFY(IDX: String, INSERT_APPLY: String, MODIFY: Bool) {
        
        let PARAMETERS: Parameters = [
            "ch_phone": "",
            "ch_idx": IDX,
            "ch_passwd": ""
        ]
        
        Alamofire.request(INSERT_APPLY, method: .post, parameters: PARAMETERS).responseJSON { response in
            
//            print("[수정/취소]", response)
            
            guard let EDITDICT = response.result.value as? [String: Any] else {
                
                print("[수정/취소] FAIL")
                self.NOTIFICATION_VIEW("비밀번호가 맞지 않습니다")
                return
            }
            
            if EDITDICT["result"] as? String ?? "fail" == "success" {
                
                if MODIFY == true {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.Submit_view.alpha = 1.0
                        self.Submit_BG.alpha = 0.3
                    })
                } else {
                    
                    let ALERT = UIAlertController(title: "수강신청 취소되었습니다.", message: nil, preferredStyle: .alert)
                    ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(ALERT, animated: true)
                }
            } else {
                
                self.NOTIFICATION_VIEW("비밀번호가 맞지 않습니다")
            }
        }
    }
    
    var ALERT = UIAlertController()
    
    var CH_GRADE: String = "1"  // 학년
    var CH_GENDER: String = ""  // 성별
    
    // 수강신청수정
    @IBOutlet weak var Submit_view: UIView!
    @IBOutlet weak var Submit_BG: UIButton!
    @IBAction func Submit_BG(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.Submit_view.alpha = 0.0
            self.Submit_BG.alpha = 0.0
        })
    }
    @IBOutlet weak var Title_name: UILabel!             // 수강명
    @IBOutlet weak var Mb_name: UITextField!            // 성명
    @IBOutlet weak var Sc_name: UITextField!            // 학교명
    @IBAction func Sc_name(_ sender: UIButton) {        // 학교명
        
        let SC_NAME = DATA_URL().SCHOOL_URL + "school/wee_center.php"
        
        Alamofire.request(SC_NAME, method: .post, parameters: nil).responseJSON { response in
            
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

            self.ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

            self.present(self.ALERT, animated: true)

            TV.delegate = self
            TV.dataSource = self
        }
    }
    @IBOutlet weak var Class_name: UIButton!            // 학년
    @IBAction func Class_name(_ sender: UIButton) {     // 학년
        
        if Sc_name.text == "" {
        
            NOTIFICATION_VIEW("학교명을 입력해주세요")
        } else {

            let ALERT = UIAlertController(title: "학년 선택", message: nil, preferredStyle: .actionSheet)
            
            for i in 1 ... 6 {

                ALERT.addAction(UIAlertAction(title: "\(i)학년", style: .default) { (_) in
                    self.Class_name.setTitle("\(i)학년", for: .normal)
                    self.CH_GRADE = "\(i)"
                })
            }
            let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            ALERT.addAction(CANCEL)
            CANCEL.setValue(UIColor.red, forKey: "titleTextColor")

            present(ALERT, animated: true)
        }
    }
    @IBOutlet weak var Man: UIButton!            // 남자
    @IBAction func Man(_ sender: UIButton) {     // 성별
        
        if sender.isSelected == false {
            sender.isSelected = true
            Woman.isSelected = false
            CH_GENDER = "1"
        } else {
            sender.isSelected = false
            CH_GENDER = ""
        }
    }
    @IBOutlet weak var Woman: UIButton!            // 여자
    @IBAction func Woman(_ sender: UIButton) {     // 성별
        
        if sender.isSelected == false {
            sender.isSelected = true
            Man.isSelected = false
            CH_GENDER = "2"
        } else {
            sender.isSelected = false
            CH_GENDER = ""
        }
    }
    @IBOutlet weak var Mb_num: UITextField!             // 전화번호
    @IBOutlet weak var Mb_password: UITextField!        // 비밀번호
    @IBAction func Submit(_ sender: UIButton) {         // 수강신청
        
        if (Sc_name.text == "") || (CH_GRADE == "") || (CH_GENDER == "") || (Mb_name.text == "") || (Mb_password.text == "") {
            
            NOTIFICATION_VIEW("미입력된 항목이 있습니다")
        } else {
            
            if !SYSTEM_NETWORK_CHECKING() {
                NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
            } else {
                
                HTTP_INSERT(IDX: IDX, SC_NAME: Sc_name.text!, CH_GRADE: CH_GRADE, CH_GENDER: CH_GENDER, CH_PHONE: Mb_name.text!, CH_PASSWORD: Mb_password.text!)
            }
        }
    }
    @IBAction func Cancel(_ sender: UIButton) {         // 취소하기
        
        UIView.animate(withDuration: 0.2, animations: {
            self.Submit_view.alpha = 0.0
            self.Submit_BG.alpha = 0.0
        })
    }
    
    let VIEW = UIView()
    override func loadView() {
        super.loadView()
        
        CHECK_VERSION(Navi_Title)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0 ..< 3 { CONTENT.append(CLASS_CONTENT[i]) }
        CONTENT.append("접수완료")
        
        Submit_view.alpha = 0.0
        Submit_BG.alpha = 0.0
        
        Submit_view.layer.cornerRadius = 10.0
        Submit_view.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        TOOL_BAR_DONE(TEXT_FILELD: Password)
        PLACEHOLDER(TEXT_FILELD: Password, PLACEHOLDER: "ex) 1234")
        
        Title_name.text = CLASS_CONTENT[0]
        
        TOOL_BAR_DONE(TEXT_FILELD: Mb_name)
        PLACEHOLDER(TEXT_FILELD: Mb_name, PLACEHOLDER: "ex) 홍길동")
        TOOL_BAR_DONE(TEXT_FILELD: Sc_name)
        PLACEHOLDER(TEXT_FILELD: Sc_name, PLACEHOLDER: "ex) 부산초등학교")
        TOOL_BAR_DONE(TEXT_FILELD: Mb_num)
        PLACEHOLDER(TEXT_FILELD: Mb_num, PLACEHOLDER: "ex) 01012345678")
        TOOL_BAR_DONE(TEXT_FILELD: Mb_password)
        PLACEHOLDER(TEXT_FILELD: Mb_password, PLACEHOLDER: "ex) 1234")
        
        Mb_num.text = UIViewController.USER_DATA.string(forKey: "mb_id")
        
        TableView.delegate = self
        TableView.dataSource = self
    }
    
    // 수강신청 수정
    func HTTP_INSERT(IDX: String, SC_NAME: String, CH_GRADE: String, CH_GENDER: String, CH_PHONE: String, CH_PASSWORD: String) {
        
        let PARAMETERS: Parameters = [
            "idx": IDX,
            "sc_name": SC_NAME,
            "ch_grade": CH_GRADE,
            "ch_gender": CH_GENDER,
            "ch_phone": CH_PHONE,
            "ch_passwd": CH_PASSWORD
        ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in

            for (key, value) in PARAMETERS {
                
                print("key: \(key)", "value: \(value)")
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, to: DATA_URL().SCHOOL_URL + "school/insert_apply.php") { (result) in
        
            switch result {
            case .success(let upload, _, _):
            
            upload.responseJSON { response in

                print("[수강신청수정] ", response)
                
                guard let INSERT_DICT = response.result.value as? [String: Any] else {

                    print("[수강신청수정] FAIL")
                    return
                }
                
                if INSERT_DICT["result"] as? String ?? "fail" == "success" {
                    
                    let DATE_FORMATTER = DateFormatter()
                    DATE_FORMATTER.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let ALERT = UIAlertController(title: "수정되었습니다.", message: DATE_FORMATTER.string(from: Date()), preferredStyle: .alert)
                    ALERT.addAction(UIAlertAction(title: "확인", style: .default) { (_) in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.Submit_view.alpha = 0.0
                            self.Submit_BG.alpha = 0.0
                        })
                    })
                    self.present(ALERT, animated: true)
                }
            }
            case .failure(let encodingError):
                
                print(encodingError)
                break
            }
        }
    }
}

extension SOSIK_T_2: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == TableView {
            
            if CONTENT.count == 0 {
                TableView.isHidden = true
                return 0
            } else {
                TableView.isHidden = false
                return CONTENT.count
            }
        } else {
            
            if WEECENTER_API.count == 0 { return 0 } else { return WEECENTER_API.count }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == TableView {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "SOSIK_DETAIL_TC", for: indexPath) as! SOSIK_DETAIL_TC
            
            CELL.Title.text = CLASS_TITLE[indexPath.item]
            CELL.Content.text = CONTENT[indexPath.item]
            CELL.Content.isEditable = false
            CELL.Content.isScrollEnabled = false
            CELL.Content.dataDetectorTypes = .link
            
            if indexPath.item == 3 { CELL.Content.textColor = .systemGreen }
            
            Modify_Button.layer.cornerRadius = 5.0
            Modify_Button.clipsToBounds = true
            
            return CELL
        } else {
            
            var CELL: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")

            if CELL == nil { CELL = UITableViewCell(style: .default, reuseIdentifier: "cell") }
            CELL!.textLabel!.text = WEECENTER_API[indexPath.item].SC_NAME

            return CELL!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView != TableView {
            
            let DATA = WEECENTER_API[indexPath.item]
            
            Sc_name.text = DATA.SC_NAME
            WEECENTER_POSITION = indexPath.item
            ALERT.dismiss(animated: true, completion: nil)
        }
    }
}
