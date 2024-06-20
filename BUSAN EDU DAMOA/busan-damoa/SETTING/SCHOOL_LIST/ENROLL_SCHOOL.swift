//
//  ENROLL_SCHOOL.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/05/08.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class ENROLL_SCHOOL_TC: UITableViewCell {
    
    @IBOutlet weak var School_Symbol_Image: UIImageView!
    @IBOutlet weak var School_Name_Label: UILabel!
    @IBOutlet weak var School_Locate_Label: UILabel!
    @IBOutlet weak var School_Add_Button: UIButton!
}

class ENROLL_SCHOOL: UIViewController, UISearchBarDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // 화면 다른곳 터치하면 키보드 사라짐
        view.endEditing(true)
    }
    
    @IBAction func BACK_VC(_ sender: Any) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ENROLL") as! ENROLL
        VC.modalTransitionStyle = .crossDissolve
        present(VC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var Search_BG: UIView!
    @IBOutlet weak var Search_Bar: UISearchBar!
    
    var LOGO: String = ""
    var FILTER_SC_INFO = [SC_LIST]()        // 학교 코드
    var SC_INFO = [SC_LIST]()
    var POSITION = 0
    
    @IBOutlet weak var Navi_Title: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var TITLE_VIEW_BG: UIView!
    @IBOutlet weak var TITLE_VIEW: UIView!
    
    // 로딩인디케이터
    let VIEW = UIView()
    override func loadView() {
        super.loadView()
        
        EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "Logo.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
        CHECK_VERSION(Navi_Title)
    }
    var PickerView = UIPickerView()
    
    @IBOutlet weak var Sc_name: UITextField!        // 학교명
    @IBOutlet weak var Grade_Class: UITextField!    // 학급반
    
    var CLASS_API: [CLASS_DATA] = []
    var CLASS_POSITION = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navi_Title.alpha = 0.0
        
        Submit_BG.alpha = 0.0
        Submit_View.alpha = 0.0
        Submit_.alpha = 0.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        Search_BG.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 10.0, height: 10.0), SD_RADIUS: 7.5, OPACITY: 0.1, RADIUS: 10.0)
        if #available(iOS 13.0, *) { Search_Bar.searchTextField.textColor = .black }
        Search_Bar.placeholder = "학교명을 입력해주세요."
        Search_Bar.delegate = self
        
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
        } else {
            HTTP_SOSIK_LIST(SC_CODE: "", ACTION_TYPE: "list")
        }
        
        TableView.delegate = self
        TableView.dataSource = self
        TableView.backgroundColor = .white
        
        PickerView.delegate = self
        PickerView.dataSource = self
        Grade_Class.inputView = PickerView
        TOOL_BAR_DONE(TEXT_FILELD: Grade_Class)
    }
    
    func HTTP_SOSIK_LIST(SC_CODE: String, ACTION_TYPE: String) {
        
        let SOSIK_LIST = DATA_URL().SCHOOL_URL + "school/get_school_list.php"
        
        let PARAMETERS: Parameters = [
            "sc_code": SC_CODE,
            "action_type": ACTION_TYPE
        ]
        
        print("PARAMETERS -", PARAMETERS)
        
        Alamofire.request(SOSIK_LIST, method: .post, parameters: PARAMETERS).responseJSON { response in
            
//            print("[학교목록]", response)
            self.CLASS_API.removeAll()
            
            guard let SCHOOL_ARRAY = response.result.value as? Array<Any> else {
                
                let DATE_FORMATTER = DateFormatter()
                DATE_FORMATTER.dateFormat = "HH:mm"
                let START_TIME = UIViewController.USER_DATA.string(forKey: "START_TIME") ?? "00:00"
                let NOW_TIME = DATE_FORMATTER.string(from: Date())
                let END_TIME = UIViewController.USER_DATA.string(forKey: "END_TIME") ?? "24:00"
                
                if ACTION_TYPE == "class" {
                        
                    if self.FILTER_SC_INFO.count == 0 {
                        
                        let DATA = self.SC_INFO[self.POSITION]
                        let ENROLL_DATA = UIViewController.APPDELEGATE.ENROLL_LIST
                        var SC_CODE_BOOL = false
                        
                        for i in 0 ..< ENROLL_DATA.count {
                            
                            if ENROLL_DATA[i].value(forKey: "sc_code") as? String ?? "" == DATA.SC_CODE {
                                
                                self.NOTIFICATION_VIEW("F: 이미 등록된 학교")
                                SC_CODE_BOOL = true
                            }
                        }
                        
                        if SC_CODE_BOOL == false {
                            
                            self.LOGO.removeAll()
                            if DATA.SC_LOGO == "" || DATA.SC_LOGO == "Y" { if DATA.SC_CODE != "" { self.LOGO = DATA.SC_CODE } } else { self.LOGO = DATA.SC_LOGO }
                            if UIViewController.APPDELEGATE.ENROLL_SAVE(SC_LOGO: self.LOGO, SC_CODE: DATA.SC_CODE, SC_GRADE: DATA.SC_GRADE.replacingOccurrences(of: "　", with: ""), SC_GROUP: DATA.SC_GROUP.replacingOccurrences(of: "　", with: ""), SC_LOCATION: DATA.SC_LOCATION.replacingOccurrences(of: "　", with: ""), SC_NAME: DATA.SC_NAME, SC_ADDRESS: DATA.SC_ADDRESS, CL_CODE: "", CLASS_NAME: "학년/반") == true {

                                self.NOTIFICATION_VIEW("T: 학교등록 성공")
                                //MARK: PUSH 설정
                                self.MAIN_PUSH_CONTROL_CENTER()
                                self.SCHOOL_PUSH_CONTROL_CENTER()
                            }
                        }
                    } else {
                        
                        let DATA = self.FILTER_SC_INFO[self.POSITION]
                        let ENROLL_DATA = UIViewController.APPDELEGATE.ENROLL_LIST
                        var SC_CODE_BOOL = false
                        
                        for i in 0 ..< ENROLL_DATA.count {
                            
                            if ENROLL_DATA[i].value(forKey: "sc_code") as? String ?? "" == DATA.SC_CODE {
                                
                                self.NOTIFICATION_VIEW("F: 이미 등록된 학교")
                                SC_CODE_BOOL = true
                            }
                        }
                        
                        if SC_CODE_BOOL == false {
                            
                            self.LOGO.removeAll()
                            if DATA.SC_LOGO == "" || DATA.SC_LOGO == "Y" { if DATA.SC_CODE != "" { self.LOGO = DATA.SC_CODE } } else { self.LOGO = DATA.SC_LOGO }
                            if UIViewController.APPDELEGATE.ENROLL_SAVE(SC_LOGO: self.LOGO, SC_CODE: DATA.SC_CODE, SC_GRADE: DATA.SC_GRADE.replacingOccurrences(of: "　", with: ""), SC_GROUP: DATA.SC_GROUP.replacingOccurrences(of: "　", with: ""), SC_LOCATION: DATA.SC_LOCATION.replacingOccurrences(of: "　", with: ""), SC_NAME: DATA.SC_NAME, SC_ADDRESS: DATA.SC_ADDRESS, CL_CODE: "", CLASS_NAME: "학년/반") == true {

                                self.NOTIFICATION_VIEW("T: 학교등록 성공")
                                //MARK: PUSH 설정
                                self.MAIN_PUSH_CONTROL_CENTER()
                                self.SCHOOL_PUSH_CONTROL_CENTER()
                            }
                        }
                    }
                }
                
                self.CLOSE_EFFECT_INDICATOR_VIEW(VIEW: self.VIEW)
                print("[학교목록] FAIL")
                return
            }
            
            for (_, DATA) in SCHOOL_ARRAY.enumerated() {
                
                let DATADICT = DATA as? [String: Any]
                
                if ACTION_TYPE == "list" {
                    
                    self.SC_INFO.append(SC_LIST(
                        SC_CODE: DATADICT?["sc_code"] as? String ?? "",
                        SC_GRADE: DATADICT?["sc_grade"] as? String ?? "",
                        SC_GROUP: DATADICT?["sc_group"] as? String ?? "",
                        SC_LOCATION: DATADICT?["sc_location"] as? String ?? "",
                        SC_NAME: DATADICT?["sc_name"] as? String ?? "",
                        SC_ADDRESS: DATADICT?["sc_address"] as? String ?? ""))
                } else {
                    
                    let POST_CLASS_DATA = CLASS_DATA()
                    
                    POST_CLASS_DATA.SET_CL_CODE(CL_CODE: DATADICT?["cl_code"] as Any)
                    POST_CLASS_DATA.SET_CL_GRADE(CL_GRADE: DATADICT?["cl_grade"] as Any)
                    POST_CLASS_DATA.SET_CL_NAME(CL_NAME: DATADICT?["cl_name"] as Any)
                    POST_CLASS_DATA.SET_CL_NO(CL_NO: DATADICT?["cl_no"] as Any)
                    POST_CLASS_DATA.SET_CLASS_NAME(CLASS_NAME: DATADICT?["class_name"] as Any)
                    POST_CLASS_DATA.SET_IDX(IDX: DATADICT?["idx"] as Any)
                    POST_CLASS_DATA.SET_SC_CODE(SC_CODE: DATADICT?["sc_code"] as Any)
                    POST_CLASS_DATA.SET_SC_GRADE(SC_GRADE: (DATADICT?["sc_grade"] as Any))
                    POST_CLASS_DATA.SET_SC_GROUP(SC_GROUP: DATADICT?["sc_group"] as Any)
                    POST_CLASS_DATA.SET_SC_LOCATION(SC_LOCATION: DATADICT?["sc_location"] as Any)
                    POST_CLASS_DATA.SET_SC_LOGO(SC_LOGO: DATADICT?["sc_logo"] as Any)
                    POST_CLASS_DATA.SET_SC_NAME(SC_NAME: DATADICT?["sc_name"] as Any)
                    POST_CLASS_DATA.SET_SYS_ID(SYS_ID: DATADICT?["sys_id"] as Any)
                    
                    self.CLASS_API.append(POST_CLASS_DATA)
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.Submit_BG.alpha = 0.3
                        self.Submit_View.alpha = 1.0
                        self.Submit_.alpha = 1.0
                    })
                }
            }
            
            self.TableView.reloadData()
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                self.VIEW.alpha = 0.0
            }, completion: {(isCompleted) in
                self.VIEW.removeFromSuperview()
            })
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        FILTER_SC_INFO = searchText.isEmpty ? SC_INFO : SC_INFO.filter({(SC_INFO_STRING: SC_LIST) -> Bool in
            return SC_INFO_STRING.SC_NAME.lowercased().contains(searchText.lowercased())
        })
        
        TableView.reloadData()
    }
    
    @IBOutlet weak var Submit_BG: UIButton!
    @IBOutlet weak var Submit_View: UIView!
    @IBAction func Submit_BG(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.Submit_BG.alpha = 0.0
            self.Submit_View.alpha = 0.0
            self.Submit_.alpha = 0.0
        })
    }
    // 등록완료
    @IBAction func Submit(_ sender: UIButton) {
        
        Grade_Class.resignFirstResponder()
        
        if Sc_name.text == "" || Grade_Class.text == "" {
            
            NOTIFICATION_VIEW("미입력된 항목이 있습니다")
        } else {
            
            let DATE_FORMATTER = DateFormatter()
            DATE_FORMATTER.dateFormat = "HH:mm"
            let START_TIME = UIViewController.USER_DATA.string(forKey: "START_TIME") ?? "00:00"
            let NOW_TIME = DATE_FORMATTER.string(from: Date())
            let END_TIME = UIViewController.USER_DATA.string(forKey: "END_TIME") ?? "24:00"
            
            if FILTER_SC_INFO.count == 0 {
                
                let DATA = SC_INFO[POSITION]
                let DATA_ = CLASS_API[CLASS_POSITION]
                let ENROLL_DATA = UIViewController.APPDELEGATE.ENROLL_LIST
                var CLASS_NAME_BOOL = false
                var SC_CODE_BOOL = false
                
                for i in 0 ..< ENROLL_DATA.count {
                    
                    let SC_CODE = ENROLL_DATA[i].value(forKey: "sc_code") as? String ?? ""
                    let CL_CODE = ENROLL_DATA[i].value(forKey: "cl_code") as? String ?? ""
                    
                    if (SC_CODE == DATA.SC_CODE && CL_CODE == DATA_.CL_CODE) || (SC_CODE == "" && CL_CODE == DATA_.CL_CODE) {
                        
                        NOTIFICATION_VIEW("F: 이미 등록된 학교")
                        CLASS_NAME_BOOL = true
                    }
                }
                
                if CLASS_NAME_BOOL == false {
                    
                    for i in 0 ..< ENROLL_DATA.count {
                        
                        if ENROLL_DATA[i].value(forKey: "sc_code") as? String ?? "" == DATA.SC_CODE {
                            
                            LOGO.removeAll()
                            if DATA.SC_LOGO == "" || DATA.SC_LOGO == "Y" { if DATA.SC_CODE != "" { LOGO = DATA.SC_CODE } } else { LOGO = DATA.SC_LOGO }
                            if UIViewController.APPDELEGATE.ENROLL_SAVE(SC_LOGO: LOGO, SC_CODE: DATA.SC_CODE, SC_GRADE: "", SC_GROUP: "", SC_LOCATION: "", SC_NAME: DATA.SC_NAME, SC_ADDRESS: DATA.SC_ADDRESS, CL_CODE: DATA_.CL_CODE, CLASS_NAME: DATA_.CLASS_NAME) == true {
                                
                                NOTIFICATION_VIEW("T: 학교등록 성공")
                                SC_CODE_BOOL = true
                            }
                        }
                    }
                    
                    if SC_CODE_BOOL == false {
                        
                        LOGO.removeAll()
                        if DATA.SC_LOGO == "" || DATA.SC_LOGO == "Y" { if DATA.SC_CODE != "" { LOGO = DATA.SC_CODE } } else { LOGO = DATA.SC_LOGO }
                        if UIViewController.APPDELEGATE.ENROLL_SAVE(SC_LOGO: LOGO, SC_CODE: DATA.SC_CODE, SC_GRADE: DATA.SC_GRADE.replacingOccurrences(of: "　", with: ""), SC_GROUP: DATA.SC_GROUP.replacingOccurrences(of: "　", with: ""), SC_LOCATION: DATA.SC_LOCATION.replacingOccurrences(of: "　", with: ""), SC_NAME: DATA.SC_NAME, SC_ADDRESS: DATA.SC_ADDRESS, CL_CODE: DATA_.CL_CODE, CLASS_NAME: DATA_.CLASS_NAME) == true {
                            
                            NOTIFICATION_VIEW("T: 학교등록 성공")
                            //MARK: PUSH 설정
                            MAIN_PUSH_CONTROL_CENTER()
                            SCHOOL_PUSH_CONTROL_CENTER()
                        }
                    }
                }
            } else {
                
                let DATA = FILTER_SC_INFO[POSITION]
                let DATA_ = CLASS_API[CLASS_POSITION]
                let ENROLL_DATA = UIViewController.APPDELEGATE.ENROLL_LIST
                var CLASS_NAME_BOOL = false
                var SC_CODE_BOOL = false
                
                for i in 0 ..< ENROLL_DATA.count {
                    
                    let SC_CODE = ENROLL_DATA[i].value(forKey: "sc_code") as? String ?? ""
                    let CL_CODE = ENROLL_DATA[i].value(forKey: "cl_code") as? String ?? ""
                    
                    if (SC_CODE == DATA.SC_CODE && CL_CODE == DATA_.CL_CODE) || (SC_CODE == "" && CL_CODE == DATA_.CL_CODE) {
                        
                        self.NOTIFICATION_VIEW("F: 이미 등록된 학교")
                        CLASS_NAME_BOOL = true
                    }
                }
                
                if CLASS_NAME_BOOL == false {
                    
                    for i in 0 ..< ENROLL_DATA.count {
                        
                        if ENROLL_DATA[i].value(forKey: "sc_code") as? String ?? "" == DATA.SC_CODE {
                            
                            LOGO.removeAll()
                            if DATA.SC_LOGO == "" || DATA.SC_LOGO == "Y" { if DATA.SC_CODE != "" { LOGO = DATA.SC_CODE } } else { LOGO = DATA.SC_LOGO }
                            if UIViewController.APPDELEGATE.ENROLL_SAVE(SC_LOGO: LOGO, SC_CODE: DATA.SC_CODE, SC_GRADE: "", SC_GROUP: "", SC_LOCATION: "", SC_NAME: DATA.SC_NAME, SC_ADDRESS: DATA.SC_ADDRESS, CL_CODE: DATA_.CL_CODE, CLASS_NAME: DATA_.CLASS_NAME) == true {
                                
                                NOTIFICATION_VIEW("T: 학교등록 성공")
                                SC_CODE_BOOL = true
                            }
                        }
                    }
                    
                    if SC_CODE_BOOL == false {
                        
                        LOGO.removeAll()
                        if DATA.SC_LOGO == "" || DATA.SC_LOGO == "Y" { if DATA.SC_CODE != "" { LOGO = DATA.SC_CODE } } else { LOGO = DATA.SC_LOGO }
                        if UIViewController.APPDELEGATE.ENROLL_SAVE(SC_LOGO: LOGO, SC_CODE: DATA.SC_CODE, SC_GRADE: DATA.SC_GRADE.replacingOccurrences(of: "　", with: ""), SC_GROUP: DATA.SC_GROUP.replacingOccurrences(of: "　", with: ""), SC_LOCATION: DATA.SC_LOCATION.replacingOccurrences(of: "　", with: ""), SC_NAME: DATA.SC_NAME, SC_ADDRESS: DATA.SC_ADDRESS, CL_CODE: DATA_.CL_CODE, CLASS_NAME: DATA_.CLASS_NAME) == true {
                            
                            NOTIFICATION_VIEW("T: 학교등록 성공")
                            //MARK: PUSH 설정
                            MAIN_PUSH_CONTROL_CENTER()
                            SCHOOL_PUSH_CONTROL_CENTER()
                        }
                    }
                }
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.Submit_BG.alpha = 0.0
                self.Submit_View.alpha = 0.0
                self.Submit_.alpha = 0.0
            })
        }
    }
    // 학급반 정보 없이 등록
    @IBOutlet weak var Submit_: UIButton!
    @IBAction func Submit_(_ sender: UIButton) {
        
        Grade_Class.resignFirstResponder()
        
        let DATE_FORMATTER = DateFormatter()
        DATE_FORMATTER.dateFormat = "HH:mm"
        let START_TIME = UIViewController.USER_DATA.string(forKey: "START_TIME") ?? "00:00"
        let NOW_TIME = DATE_FORMATTER.string(from: Date())
        let END_TIME = UIViewController.USER_DATA.string(forKey: "END_TIME") ?? "24:00"
        
        if FILTER_SC_INFO.count == 0 {
            
            let DATA = SC_INFO[POSITION]
            let ENROLL_DATA = UIViewController.APPDELEGATE.ENROLL_LIST
            var SC_CODE_BOOL = false
            
            for i in 0 ..< ENROLL_DATA.count {
                
                if ENROLL_DATA[i].value(forKey: "sc_code") as? String ?? "" == DATA.SC_CODE {
                    
                    NOTIFICATION_VIEW("F: 이미 등록된 학교")
                    SC_CODE_BOOL = true
                }
            }
            
            if SC_CODE_BOOL == false {
                
                LOGO.removeAll()
                if DATA.SC_LOGO == "" || DATA.SC_LOGO == "Y" { if DATA.SC_CODE != "" { LOGO = DATA.SC_CODE } } else { LOGO = DATA.SC_LOGO }
                if UIViewController.APPDELEGATE.ENROLL_SAVE(SC_LOGO: LOGO, SC_CODE: DATA.SC_CODE, SC_GRADE: DATA.SC_GRADE.replacingOccurrences(of: "　", with: ""), SC_GROUP: DATA.SC_GROUP.replacingOccurrences(of: "　", with: ""), SC_LOCATION: DATA.SC_LOCATION.replacingOccurrences(of: "　", with: ""), SC_NAME: DATA.SC_NAME, SC_ADDRESS: DATA.SC_ADDRESS, CL_CODE: "", CLASS_NAME: "학년/반") == true {
                    
                    NOTIFICATION_VIEW("T: 학교등록 성공")
                    //MARK: PUSH 설정
                    MAIN_PUSH_CONTROL_CENTER()
                    SCHOOL_PUSH_CONTROL_CENTER()
                }
            }
        } else {
            
            let DATA = FILTER_SC_INFO[POSITION]
            let ENROLL_DATA = UIViewController.APPDELEGATE.ENROLL_LIST
            var SC_CODE_BOOL = false
            
            for i in 0 ..< ENROLL_DATA.count {
                
                if ENROLL_DATA[i].value(forKey: "sc_code") as? String ?? "" == DATA.SC_CODE {
                    
                    NOTIFICATION_VIEW("F: 이미 등록된 학교")
                    SC_CODE_BOOL = true
                }
            }
            
            if SC_CODE_BOOL == false {
                
                LOGO.removeAll()
                if DATA.SC_LOGO == "" || DATA.SC_LOGO == "Y" { if DATA.SC_CODE != "" { LOGO = DATA.SC_CODE } } else { LOGO = DATA.SC_LOGO }
                if UIViewController.APPDELEGATE.ENROLL_SAVE(SC_LOGO: LOGO, SC_CODE: DATA.SC_CODE, SC_GRADE: DATA.SC_GRADE.replacingOccurrences(of: "　", with: ""), SC_GROUP: DATA.SC_GROUP.replacingOccurrences(of: "　", with: ""), SC_LOCATION: DATA.SC_LOCATION.replacingOccurrences(of: "　", with: ""), SC_NAME: DATA.SC_NAME, SC_ADDRESS: DATA.SC_ADDRESS, CL_CODE: "", CLASS_NAME: "학년/반") == true {
                    
                    NOTIFICATION_VIEW("T: 학교등록 성공")
                    //MARK: PUSH 설정
                    MAIN_PUSH_CONTROL_CENTER()
                    SCHOOL_PUSH_CONTROL_CENTER()
                }
            }
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.Submit_BG.alpha = 0.0
            self.Submit_View.alpha = 0.0
            self.Submit_.alpha = 0.0
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        SCROLL_EDIT(TABLE_VIEW: TableView, NAVI_TITLE: Navi_Title)
    }
}

extension ENROLL_SCHOOL: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if CLASS_API.count == 0 { return 0 } else { return CLASS_API.count }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Grade_Class.text = CLASS_API[row].CLASS_NAME
        CLASS_POSITION = row
        return CLASS_API[row].CLASS_NAME
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Grade_Class.text = CLASS_API[row].CLASS_NAME
        CLASS_POSITION = row
    }
}

extension ENROLL_SCHOOL: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if FILTER_SC_INFO.count == 0 {
            if SC_INFO.count == 0 {
                TableView.separatorStyle = .none
                return 0
            } else {
                TableView.separatorStyle = .singleLine
                return SC_INFO.count
            }
        } else {
            if FILTER_SC_INFO.count == 0 {
                return 0
            } else {
                return FILTER_SC_INFO.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "ENROLL_SCHOOL_TC", for: indexPath) as! ENROLL_SCHOOL_TC
        
        if FILTER_SC_INFO.count == 0 {
            
            let DATA = SC_INFO[indexPath.item]
            
            if DATA.SC_LOGO == "" || DATA.SC_LOGO == "Y" {
                if DATA.SC_CODE != "" {
                    let IMAGE_URL = DATA_URL().SCHOOL_LOGO_URL + DATA.SC_CODE
                    NUKE_IMAGE(IMAGE_URL: IMAGE_URL, PLACEHOLDER: UIImage(named: "school_logo.png")!, PROFILE: CELL.School_Symbol_Image, FRAME_SIZE: CELL.School_Symbol_Image.frame.size)
                }
            } else {
                let IMAGE_URL = DATA_URL().SCHOOL_LOGO_URL + DATA.SC_LOGO
                NUKE_IMAGE(IMAGE_URL: IMAGE_URL, PLACEHOLDER: UIImage(named: "school_logo.png")!, PROFILE: CELL.School_Symbol_Image, FRAME_SIZE: CELL.School_Symbol_Image.frame.size)
            }
            CELL.School_Symbol_Image.layer.cornerRadius = 25.0
            CELL.School_Symbol_Image.clipsToBounds = true
            CELL.School_Name_Label.text = DATA.SC_NAME
            CELL.School_Locate_Label.text = DATA.SC_ADDRESS
            CELL.School_Add_Button.layer.cornerRadius = 12.5
            CELL.School_Add_Button.clipsToBounds = true
            CELL.School_Add_Button.tag = indexPath.item
            CELL.School_Add_Button.addTarget(self, action: #selector(SCHOOL_ADD(_:)), for: .touchUpInside)
        } else {
            
            let DATA = FILTER_SC_INFO[indexPath.item]
            
            if DATA.SC_LOGO == "" || DATA.SC_LOGO == "Y" {
                if DATA.SC_CODE != "" {
                    let IMAGE_URL = DATA_URL().SCHOOL_LOGO_URL + DATA.SC_CODE
                    NUKE_IMAGE(IMAGE_URL: IMAGE_URL, PLACEHOLDER: UIImage(named: "school_logo.png")!, PROFILE: CELL.School_Symbol_Image, FRAME_SIZE: CELL.School_Symbol_Image.frame.size)
                }
            } else {
                let IMAGE_URL = DATA_URL().SCHOOL_LOGO_URL + DATA.SC_LOGO
                NUKE_IMAGE(IMAGE_URL: IMAGE_URL, PLACEHOLDER: UIImage(named: "school_logo.png")!, PROFILE: CELL.School_Symbol_Image, FRAME_SIZE: CELL.School_Symbol_Image.frame.size)
            }
            CELL.School_Symbol_Image.layer.cornerRadius = 25.0
            CELL.School_Symbol_Image.clipsToBounds = true
            CELL.School_Name_Label.text = DATA.SC_NAME
            CELL.School_Locate_Label.text = DATA.SC_ADDRESS
            CELL.School_Add_Button.layer.cornerRadius = 12.5
            CELL.School_Add_Button.clipsToBounds = true
            CELL.School_Add_Button.tag = indexPath.item
            CELL.School_Add_Button.addTarget(self, action: #selector(SCHOOL_ADD(_:)), for: .touchUpInside)
        }
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        Search_Bar.resignFirstResponder()
        Grade_Class.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func SCHOOL_ADD(_ sender: UIButton) {
        
        if FILTER_SC_INFO.count == 0 {
            POSITION = sender.tag
            let DATA = SC_INFO[sender.tag]
            Sc_name.text = DATA.SC_NAME
            if !SYSTEM_NETWORK_CHECKING() {
                NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
            } else {
                HTTP_SOSIK_LIST(SC_CODE: DATA.SC_CODE, ACTION_TYPE: "class")
            }
        } else {
            POSITION = sender.tag
            let DATA = FILTER_SC_INFO[sender.tag]
            Sc_name.text = DATA.SC_NAME
            if !SYSTEM_NETWORK_CHECKING() {
                NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
            } else {
                HTTP_SOSIK_LIST(SC_CODE: DATA.SC_CODE, ACTION_TYPE: "class")
            }
        }
        
        Grade_Class.text = ""
    }
}
