//
//  SETTING.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/05/13.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Nuke
import WebKit
import Alamofire
import FirebaseMessaging

// 환경설정
class SETTING_TC: UITableViewCell {
    
    var PROTOCOL: UIViewController?
    
    @IBOutlet weak var Setting_title: UILabel!
    @IBOutlet weak var Setting_name: UILabel!
    
    @IBOutlet weak var Switch_button: UISwitch!
    
    @IBOutlet weak var Profile_view: UIView!
    @IBOutlet weak var Profile_image: UIImageView!
    @IBOutlet weak var Profile_name: UILabel!
    
    @IBOutlet weak var Time_view: UIView!
    @IBOutlet weak var Time_hidden: UIView!
    @IBOutlet weak var Start_time: UITextField!
    @IBOutlet weak var End_time: UITextField!
    
    @IBOutlet weak var Password: UILabel!
    
    @objc func SWITCH(_ sender: UISwitch) {
        
        if sender.tag == 0 {    // 긴급알림
            
            Switch_button.isOn = true
            PROTOCOL!.NOTIFICATION_VIEW("긴급 알림은 끌 수 없습니다")
        }
        if sender.tag == 1 {
            
            UIViewController.USER_DATA.set(sender.isOn, forKey: "switch_dt") // 시간설정
            UIViewController.USER_DATA.synchronize()
            
            let DATE_FORMATTER = DateFormatter()
            DATE_FORMATTER.dateFormat = "HH:mm"
            let START_TIME = UIViewController.USER_DATA.string(forKey: "START_TIME") ?? "00:00"
            let NOW_TIME = DATE_FORMATTER.string(from: Date())
            let END_TIME = UIViewController.USER_DATA.string(forKey: "END_TIME") ?? "24:00"
            
            if Switch_button.isOn == true {
                Time_hidden.isHidden = false
//                if (START_TIME > NOW_TIME) && (NOW_TIME <= END_TIME) {
//                    // firebase 구독
//                    USER_DEFAULT_PUSH(TIME: true)
//                } else {
//                    // firebase 구독취소
//                    USER_DEFAULT_PUSH(TIME: false)
//                }
            } else {
                Time_hidden.isHidden = true
//                // firebase 구독취소
//                USER_DEFAULT_PUSH(TIME: true)
            }
        }
        if sender.tag == 2 { UserDefaults.standard.setValue(sender.isOn, forKey: "switch_n") } // 공지사항
        if sender.tag == 3 { UserDefaults.standard.setValue(sender.isOn, forKey: "switch_m") } // 가정통신문
        if sender.tag == 4 { UserDefaults.standard.setValue(sender.isOn, forKey: "switch_c") } // 학급알림장
        if sender.tag == 5 { UserDefaults.standard.setValue(sender.isOn, forKey: "switch_f") } // 오늘의식단
        if sender.tag == 6 { UserDefaults.standard.setValue(sender.isOn, forKey: "switch_t") } // 학부모연수
        if sender.tag == 7 { UserDefaults.standard.setValue(sender.isOn, forKey: "switch_et") } // 진로도움방
        if sender.tag == 8 { UserDefaults.standard.setValue(sender.isOn, forKey: "switch_sc") } // 자녀안심+
        if sender.tag == 9 { UserDefaults.standard.setValue(sender.isOn, forKey: "switch_s") } // 학사일정
        if sender.tag == 10 { UserDefaults.standard.setValue(sender.isOn, forKey: "switch_ns") } // 학교뉴스
        if sender.tag == 11 { UserDefaults.standard.setValue(sender.isOn, forKey: "switch_en") } // 교육뉴스
        if sender.tag == 12 { UserDefaults.standard.setValue(sender.isOn, forKey: "switch_cs") } // 행사체험
        if sender.tag == 13 { UserDefaults.standard.setValue(sender.isOn, forKey: "switch_sv") } // 설문조사
        if sender.tag == 14 { // 저데이터 모드 지원
            if #available(iOS 13.0, *) {
                if sender.isOn == true {
                    URLSessionConfiguration.default.allowsConstrainedNetworkAccess = false
                    URLSessionConfiguration.default.allowsExpensiveNetworkAccess = false
                    PROTOCOL!.NOTIFICATION_VIEW("저데이터 모드 활설화")
                } else {
                    URLSessionConfiguration.default.allowsConstrainedNetworkAccess = true
                    URLSessionConfiguration.default.allowsExpensiveNetworkAccess = true
                    PROTOCOL!.NOTIFICATION_VIEW("저데이터 모드 비활설화")
                }
                UserDefaults.standard.set(sender.isOn, forKey: "switch_ld")
                UserDefaults.standard.synchronize()
            } else {
                sender.isOn = false
                PROTOCOL!.NOTIFICATION_VIEW("iOS 13.0 미만 버전 미지원")
            }
        }
        UserDefaults.standard.synchronize()
        
        //MARK: PUSH 설정
        PROTOCOL!.MAIN_PUSH_CONTROL_CENTER()
        PROTOCOL!.SCHOOL_PUSH_CONTROL_CENTER()
    }
    
    // 시간 설정
    @objc func START_TIME(DATE_PICKER: UIDatePicker) {
        
        let DATE_FORMATTER = DateFormatter()
        DATE_FORMATTER.dateFormat = "HH:mm"
        let DATE = DATE_FORMATTER.string(from: DATE_PICKER.date)
        Start_time.text = DATE
        UIViewController.USER_DATA.set("\(DATE)", forKey: "START_TIME")
        UIViewController.USER_DATA.synchronize()
    }
    
    @objc func END_TIME(DATE_PICKER: UIDatePicker) {
        
        let DATE_FORMATTER = DateFormatter()
        DATE_FORMATTER.dateFormat = "HH:mm"
        let DATE = DATE_FORMATTER.string(from: DATE_PICKER.date)
        End_time.text = DATE
        UIViewController.USER_DATA.set("\(DATE)", forKey: "END_TIME")
        UIViewController.USER_DATA.synchronize()
    }
}

class SETTING: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    let TRANSITION = SLIDE_IN_TRANSITION()
    
    var SETTING_TIELE: [String] = ["프로필 정보", "알림 설정", "알림 설정 - 우리학교 알림장", "알림 설정 - 학부모 참여방", "알림 설정 - 부산교육 소식", "실험실 - 소식 보관함, 위치 설정, 화면 잠금 설정, 저데이터 모드 설정", "기타 설정", "Copyright © EUMCREATIVE All rights reserved."]
    var SETTING_NAME_1: [String] = ["프로필 변경", "학교등록"]
    var SETTING_NAME_2: [String] = ["교육청 긴급"]//, "시간설정"]
    var SETTING_NAME_3: [String] = ["공지사항", "가정통신문", "학급알림장", "오늘의식단"]
    var SETTING_NAME_4: [String] = ["학부모연수","진로도움방", "자녀안심+", "학사일정"]
    var SETTING_NAME_5: [String] = ["학교뉴스", "교육뉴스", "행사체험", "설문조사"]
    var SETTING_NAME_6: [String] = ["소식 보관함", "위치 업로드 주기", "생체인증 (Touch ID, Face ID)", "저데이터 모드 설정", "부산 교육수첩"]
    var SETTING_NAME_7: [String] = ["앱 버전 정보", "개인정보처리방침", "오픈소스 라이선스", "이용안내 및 문의", "회원탈퇴"]
    
    // 로딩인디케이터
    let VIEW = UIView()

    @IBOutlet weak var Navi_BG: UIView!
    @IBOutlet weak var Navi_Title: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var TITLE_VIEW_BG: UIView!
    @IBOutlet weak var TITLE_VIEW: UIView!
    
    @IBOutlet weak var AGREE_VIEW: UIView!
    @IBOutlet weak var CLOSE_VC: UIButton!
    @IBAction func CLOSE_VC(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.CLOSE_VC.alpha = 0.0
            self.AGREE_VIEW.alpha = 0.0
        })
    }
    @IBOutlet weak var WKWebView: WKWebView!
    
    override func loadView() {
        super.loadView()
        
        CHECK_VERSION(Navi_Title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.APPDELEGATE.PF_UPDATE = false
        
        CLOSE_VC.alpha = 0.0
        AGREE_VIEW.alpha = 0.0
        AGREE_VIEW.layer.cornerRadius = 10.0
        AGREE_VIEW.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if !DEVICE_RATIO() {
            Navi_Title.alpha = 1.0
            TITLE_VIEW.frame.size.height = 0.0
            TITLE_VIEW.clipsToBounds = true
        } else {
            Navi_Title.alpha = 0.0
            TITLE_VIEW.frame.size.height = 52.0
            TITLE_VIEW.clipsToBounds = false
        }
        
        TableView.separatorStyle = .none
        TableView.delegate = self
        TableView.dataSource = self
        TableView.backgroundColor = .GRAY_F1F1F1
        
        WKWebView.uiDelegate = self
        WKWebView.navigationDelegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if DEVICE_RATIO() { SCROLL_EDIT(TABLE_VIEW: TableView, NAVI_TITLE: Navi_Title) }
    }
    
    // 시간 설정
    var START_PICKER = UIDatePicker()
    var END_PICKER = UIDatePicker()
    
    var IMAGE_DATA: Data?
    
    override func viewWillAppear(_ animated: Bool) {
        TableView.reloadData()
    }
}

extension SETTING: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SETTING_TIELE.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return SETTING_NAME_1.count
        } else if section == 1 {
            return SETTING_NAME_2.count
        } else if section == 2 {
            return SETTING_NAME_3.count
        } else if section == 3 {
            return SETTING_NAME_4.count
        } else if section == 4 {
            return SETTING_NAME_5.count
        } else if section == 5 {
            return SETTING_NAME_6.count - 2
        } else if section == 6 {
            return SETTING_NAME_7.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
        let CELL = tableView.dequeueReusableCell(withIdentifier: "SETTING_TC_T") as! SETTING_TC
        CELL.Setting_title.text = SETTING_TIELE[section]
        if section == 7 { CELL.Setting_title.textAlignment = .right; CELL.Setting_title.font = UIFont.systemFont(ofSize: 9.0) }
        return CELL
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "SETTING_TC_N", for: indexPath) as! SETTING_TC
        
        CELL.PROTOCOL = self
        
        if indexPath.section == 1 && indexPath.item == 0 { CELL.Switch_button.onTintColor = .systemRed } else { CELL.Switch_button.onTintColor = .systemBlue }
        if indexPath.section == 6 && indexPath.item == 4 { CELL.Setting_name.textColor = .systemRed } else { CELL.Setting_name.textColor = .black }
        
        // 프로필정보
        if indexPath.section == 0 {
            
            CELL.Setting_name.text = SETTING_NAME_1[indexPath.item]
            CELL.Switch_button.isHidden = true
            CELL.Time_view.isHidden = true
            CELL.Password.isHidden = true
            
            if indexPath.item == 0 {
                
                CELL.Profile_image.layer.cornerRadius = 27.5
                CELL.Profile_image.clipsToBounds = true
                CELL.Profile_view.isHidden = false
                
                if UIViewController.APPDELEGATE.LOGIN_API.count != 0 {
                    
                    let DATA = UIViewController.APPDELEGATE.LOGIN_API
                    NUKE_IMAGE(IMAGE_URL: DATA[0].MB_IMG, PLACEHOLDER: UIImage(named: "profile")!, PROFILE: CELL.Profile_image, FRAME_SIZE: CGSize(width: 55.0, height: 55.0))
                    if DATA[0].MB_TYPE == "t" {
                        CELL.Profile_name.text = "\(DATA[0].MB_NAME) (교직원)"
                    } else if DATA[0].MB_TYPE == "p" {
                        CELL.Profile_name.text = "\(DATA[0].MB_NAME) (학부모)"
                    } else {
                        CELL.Profile_name.text = "\(DATA[0].MB_NAME) (학생)"
                    }
                }
            } else {
                CELL.Profile_view.isHidden = true
            }
        // 알림설정
        } else if indexPath.section == 1 {
            
            CELL.Setting_name.text = SETTING_NAME_2[indexPath.item]
            CELL.Switch_button.isHidden = false
            CELL.Profile_view.isHidden = true
            CELL.Time_view.isHidden = true
            CELL.Password.isHidden = true
            
            if indexPath.item == 0 { // 교육청긴급
                
                CELL.Switch_button.tag = 0
                CELL.Switch_button.isOn = true
//                CELL.Switch_button.onTintColor = .systemBlue
            } else {
                
                CELL.Switch_button.tag = 1
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_dt") // 시간설정
                
                START_PICKER.datePickerMode = .time
                START_PICKER.locale = Locale(identifier: "ko_kr")
                START_PICKER.addTarget(CELL, action: #selector(CELL.START_TIME(DATE_PICKER:)), for: .valueChanged)
                CELL.Start_time.inputView = START_PICKER
                TOOL_BAR_DONE(TEXT_FILELD: CELL.Start_time)
                
                END_PICKER.datePickerMode = .time
                END_PICKER.locale = Locale(identifier: "ko_kr")
                END_PICKER.addTarget(CELL, action: #selector(CELL.END_TIME(DATE_PICKER:)), for: .valueChanged)
                CELL.End_time.inputView = END_PICKER
                TOOL_BAR_DONE(TEXT_FILELD: CELL.End_time)
                
                if UIViewController.USER_DATA.bool(forKey: "switch_dt") == true {
                    
                    CELL.Time_hidden.isHidden = false
                    
                    // 시간 설정
                    if UIViewController.USER_DATA.string(forKey: "START_TIME") == "" {
                        CELL.Start_time.text = "00:00"
                    } else {
                        CELL.Start_time.text = UIViewController.USER_DATA.string(forKey: "START_TIME")
                    }
                    
                    if UIViewController.USER_DATA.string(forKey: "END_TIME") == "" {
                        CELL.End_time.text = "24:00"
                    } else {
                        CELL.End_time.text = UIViewController.USER_DATA.string(forKey: "END_TIME")
                    }
                    
                    // Firebase 구독
                } else {
                    
                    CELL.Time_hidden.isHidden = true
                    
                    // 시간 설정
                    CELL.Start_time.text = "00:00"
                    UIViewController.USER_DATA.set(CELL.Start_time.text!, forKey: "START_TIME")
                    CELL.End_time.text = "24:00"
                    UIViewController.USER_DATA.set(CELL.End_time.text!, forKey: "END_TIME")
                    
                    // Firebase 구독취소
                }
                
                CELL.Profile_view.isHidden = true
                CELL.Time_view.isHidden = false
            }
            
            CELL.Switch_button.addTarget(CELL, action: #selector(CELL.SWITCH(_:)), for: .valueChanged)
        } else if indexPath.section == 2 {
            
            CELL.Setting_name.text = SETTING_NAME_3[indexPath.item]
            CELL.Switch_button.isHidden = false
            CELL.Profile_view.isHidden = true
            CELL.Time_view.isHidden = true
            CELL.Password.isHidden = true
            
            if indexPath.item == 0 {
                CELL.Switch_button.tag = 2
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_n") // 공지사항
            } else if indexPath.item == 1 {
                CELL.Switch_button.tag = 3
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_m") // 가정통신문
            } else if indexPath.item == 2 {
                CELL.Switch_button.tag = 4
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_c") // 학급알림장
            } else {
                CELL.Switch_button.tag = 5
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_f") // 오늘의식단
            }
            
            CELL.Switch_button.addTarget(CELL, action: #selector(CELL.SWITCH(_:)), for: .valueChanged)
        } else if indexPath.section == 3 {
            
            CELL.Setting_name.text = SETTING_NAME_4[indexPath.item]
            CELL.Switch_button.isHidden = false
            CELL.Profile_view.isHidden = true
            CELL.Time_view.isHidden = true
            CELL.Password.isHidden = true
            
            if indexPath.item == 0 {
                CELL.Switch_button.tag = 6
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_t") // 학부모연수
            } else if indexPath.item == 1 {
                CELL.Switch_button.tag = 7
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_et") // 진로도움방
            } else if indexPath.item == 2 {
                CELL.Switch_button.tag = 8
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_sc") // 자녀안심+
            } else {
                CELL.Switch_button.tag = 9
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_s") // 학사일정
            }
            
            CELL.Switch_button.addTarget(CELL, action: #selector(CELL.SWITCH(_:)), for: .valueChanged)
        } else if indexPath.section == 4 {
            
            CELL.Setting_name.text = SETTING_NAME_5[indexPath.item]
            CELL.Switch_button.isHidden = false
            CELL.Profile_view.isHidden = true
            CELL.Time_view.isHidden = true
            CELL.Password.isHidden = true
            
            if indexPath.item == 0 {
                CELL.Switch_button.tag = 10
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_ns") // 학교뉴스
            } else if indexPath.item == 1 {
                CELL.Switch_button.tag = 11
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_en") // 교육뉴스
            } else if indexPath.item == 2 {
                CELL.Switch_button.tag = 12
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_cs") // 행사체험
            } else {
                CELL.Switch_button.tag = 13
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_sv") // 설문조사
            }
            
            CELL.Switch_button.addTarget(CELL, action: #selector(CELL.SWITCH(_:)), for: .valueChanged)
        // 실험실 - 소식보관함, 위치업로드주기, 생체인증, 저데이터모드, 부산교육수첩
        } else if indexPath.section == 5 {
            
            CELL.Setting_name.text = SETTING_NAME_6[indexPath.item]
            
            if indexPath.item == 2 {
                
                CELL.Switch_button.isHidden = true
                CELL.Profile_view.isHidden = true
                CELL.Time_view.isHidden = true
                CELL.Password.isHidden = false
                
                if UIViewController.USER_DATA.bool(forKey: "switch_pw") == true {
                    CELL.Password.text = "켜짐"
                } else {
                    CELL.Password.text = "꺼짐"
                }
            } else if indexPath.item == 3 {
                
                CELL.Switch_button.isHidden = false
                CELL.Profile_view.isHidden = true
                CELL.Time_view.isHidden = true
                CELL.Password.isHidden = true
                
                CELL.Switch_button.tag = 14
                CELL.Switch_button.isOn = UIViewController.USER_DATA.bool(forKey: "switch_ld") // 저데이터 모드
                
                CELL.Switch_button.addTarget(CELL, action: #selector(CELL.SWITCH(_:)), for: .valueChanged)
            } else {
                
                CELL.Switch_button.isHidden = true
                CELL.Profile_view.isHidden = true
                CELL.Time_view.isHidden = true
                CELL.Password.isHidden = true
            }
        // 기타설정
        } else {
                    
            CELL.Setting_name.text = SETTING_NAME_7[indexPath.item]
            CELL.Switch_button.isHidden = true
            CELL.Profile_view.isHidden = true
            CELL.Time_view.isHidden = true
            CELL.Password.isHidden = true
        }
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 프로필설정
        if indexPath.section == 0 {
            
            if indexPath.item == 0 {
                /// 프로필 설정
                let ACTION_SHEET = UIAlertController(title: "프로필 변경", message: nil, preferredStyle: .actionSheet)
                
                ACTION_SHEET.addAction(UIAlertAction(title: "프로필 사진 변경", style: .default) { (_) in
                    
                    if UIViewController.APPDELEGATE.LOGIN_API.count == 0 {
                        
                        self.NOTIFICATION_VIEW("로그인을 해주세요")
                    } else {
                        
                        let ALERT = UIAlertController(title: "프로필 사진 변경", message: nil, preferredStyle: .actionSheet)
                                                
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            ALERT.addAction(UIAlertAction(title: "카메라", style: .default) { (_) in self.IMAGE_PICKER(.camera) })
                        }
                        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                            ALERT.addAction(UIAlertAction(title: "저장된 앨범", style: .default) { (_) in self.IMAGE_PICKER(.savedPhotosAlbum) })
                        }
                        let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                        
                        ALERT.addAction(CANCEL)
                        CANCEL.setValue(UIColor.red, forKey: "titleTextColor")
                    
                        self.present(ALERT, animated: true)
                    }
                })
                
                ACTION_SHEET.addAction(UIAlertAction(title: "프로필 닉네임 변경", style: .default) { (_) in
                    
                    if UIViewController.APPDELEGATE.LOGIN_API.count == 0 {
                        
                        self.NOTIFICATION_VIEW("로그인을 해주세요")
                    } else {
                    
                        let ALERT = UIAlertController(title: "프로필 닉네임 변경", message: nil, preferredStyle: .alert)
                        
                        ALERT.addTextField() { (textField) in textField.placeholder = "닉네임" }
                        ALERT.addAction(UIAlertAction(title: "수정하기", style: .default) { (_) in
                            
                            if ALERT.textFields?[0].text ?? "" == "" {
                                self.NOTIFICATION_VIEW("미입력된 항목이 있습니다")
                            } else {
                                if !self.SYSTEM_NETWORK_CHECKING() {
                                    self.NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
                                } else {
                                    self.PUT_POST_DATA(NAME: "환경설정(업데이트)", ACTION_TYPE: "update", MB_NAME: ALERT.textFields?[0].text ?? "")
                                }
                            }
                        })
                        let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                        
                        ALERT.addAction(CANCEL)
                        CANCEL.setValue(UIColor.red, forKey: "titleTextColor")
                    
                        self.present(ALERT, animated: true)
                    }
                })
                let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                ACTION_SHEET.addAction(CANCEL)
                CANCEL.setValue(UIColor.red, forKey: "titleTextColor")
                
                present(ACTION_SHEET, animated: true)
            } else {
                /// 학교추가
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ENROLL") as! ENROLL
                VC.modalTransitionStyle = .crossDissolve
                present(VC, animated: true, completion: nil)
            }
        // 실험실 - 소식보관함, 위치업로드주기, 생체인증, 저데이터모드, 부산교육수첩
        } else if indexPath.section == 5 {
            
            if indexPath.item == 0 {
                /// 소식보관함
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "SOSIK_SCRAP") as! SOSIK_SCRAP
                VC.modalTransitionStyle = .crossDissolve
                present(VC, animated: true, completion: nil)
            } else if indexPath.item == 1 {
                /// 위치업로드주기
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "SETTING_UPDATE_LOC") as! SETTING_UPDATE_LOC
                VC.modalPresentationStyle = .overCurrentContext
                VC.transitioningDelegate = self
                present(VC, animated: true, completion: nil)
            } else if indexPath.item == 2 {
                /// 생체인증
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "PASSWORD") as! PASSWORD
                VC.DID_TAP_PASSWORD_TYPE = { PASSWORD_TYPE in
                    if PASSWORD_TYPE.rawValue == 0 {
                        UIViewController.USER_DATA.set(true, forKey: "switch_pw")
                        UIViewController.USER_DATA.synchronize()
                    } else {
                        UIViewController.USER_DATA.set(false, forKey: "switch_pw")
                        UIViewController.USER_DATA.synchronize()
                    }
                    self.TableView.reloadData()
                }
                VC.modalPresentationStyle = .overCurrentContext
                VC.transitioningDelegate = self
                present(VC, animated: true, completion: nil)
            } else if indexPath.item == 3 {
                /// 저데이터모드
            } else if indexPath.item == 4 {
                /// 부산교육수첩
                let EDUBOOK_APP_OPEN = URL(string: "BUSANEDUBOOK://a.edubook")
                let EDUBOOK_APP_INSTALL = URL(string: "https://apps.apple.com/kr/app/busan-edubook/id1370801825")
                
                if UIApplication.shared.canOpenURL(EDUBOOK_APP_OPEN!) == true {
                    
                    let ALERT = UIAlertController(title: "\'부산교육다모아\'이(가) \'부산교육수첩\'을(를) 열려고 합니다", message: "부산교육수첩으로 이동하시겠습니까?", preferredStyle: .alert)
                    ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    ALERT.addAction(UIAlertAction(title: "열기", style: .default, handler: { (_) in UIApplication.shared.open(EDUBOOK_APP_OPEN!) }))
                    present(ALERT, animated: true, completion: nil)
                } else {
                    
                    let ALERT = UIAlertController(title: "\'부산교육다모아\'이(가) \'부산교육수첩\'을(를) 설치하려고 합니다", message: "앱스토어로 이동하시겠습니까?", preferredStyle: .alert)
                    ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                    ALERT.addAction(UIAlertAction(title: "열기", style: .default, handler: { (_) in UIApplication.shared.open(EDUBOOK_APP_INSTALL!) }))
                    present(ALERT, animated: true, completion: nil)
                }
            }
        // 기타설정
        } else if indexPath.section == 6 {
            
            if indexPath.item == 0 {
                /// 앱 버전 확인
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "VERSION") as! VERSION
                VC.modalTransitionStyle = .crossDissolve
                present(VC, animated: true, completion: nil)
//            } else if indexPath.item == 1 {
//
//                let VC = self.storyboard?.instantiateViewController(withIdentifier: "INFOMATION") as! INFOMATION
//                VC.modalTransitionStyle = .crossDissolve
//                present(VC, animated: true, completion: nil)
            } else if indexPath.item == 1 {
                /// 개인정보처리방침
                EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "Logo.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
                AGREE_HTML(AGREE: 1)
                UIView.animate(withDuration: 0.2, animations: {
                    self.CLOSE_VC.alpha = 0.3
                    self.AGREE_VIEW.alpha = 1.0
                })
            } else if indexPath.item == 2 {
                /// 오픈소스 라이센스
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "OPEN_SOURCE_LICENSE") as! OPEN_SOURCE_LICENSE
                VC.modalTransitionStyle = .crossDissolve
                present(VC, animated: true, completion: nil)
            } else if indexPath.item == 3 {
                /// 이용안내 및 문의
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "AS_CALL") as! AS_CALL
                VC.modalTransitionStyle = .crossDissolve
                present(VC, animated: true, completion: nil)
            } else {
                /// 회원탈퇴
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "WITHDRAWAL") as! WITHDRAWAL
                VC.modalTransitionStyle = .crossDissolve
                present(VC, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func AGREE_HTML(AGREE: Int) {
        
        let HTML_PATH = Bundle.main.path(forResource: "terms\(AGREE)", ofType: "html")
        var HTML_STIRNG: String = ""
        do { HTML_STIRNG = try String(contentsOfFile: HTML_PATH!, encoding: .utf8) } catch { }
        let HTML_URL = URL(fileURLWithPath: HTML_PATH!)
        WKWebView.loadHTMLString(HTML_STIRNG, baseURL: HTML_URL)
    }
}

extension SETTING: WKUIDelegate, WKNavigationDelegate {

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil { webView.load(navigationAction.request) }
        return nil
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        CLOSE_EFFECT_INDICATOR_VIEW(VIEW: VIEW)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        CLOSE_EFFECT_INDICATOR_VIEW(VIEW: VIEW)
    }
}

class MENUAL: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var WKWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WKWebView.uiDelegate = self
        WKWebView.navigationDelegate = self
        WKWebView.scrollView.contentInsetAdjustmentBehavior = .never
        
        let HTML_PATH = Bundle.main.path(forResource: "damoa-info", ofType: "html")
        var HTML_STIRNG: String = ""
        do { HTML_STIRNG = try String(contentsOfFile: HTML_PATH!, encoding: .utf8) } catch { }
        let HTML_URL = URL(fileURLWithPath: HTML_PATH!)
        WKWebView.loadHTMLString(HTML_STIRNG, baseURL: HTML_URL)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil { webView.load(navigationAction.request) }
        return nil
    }
}
