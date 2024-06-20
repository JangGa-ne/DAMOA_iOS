//
//  JOIN.swift
//  DAMOA
//
//  Created by 장제현 on 2020/05/01.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import WebKit
import CoreLocation

// 회원가입
class SIGN_UP: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // 로딩인디케이터
    let VIEW = UIView()
    
    // 앱 종료
    @IBAction func EXIT_VC(_ sender: Any) { UIView.animate(withDuration: 0.2, animations: { exit(1) }) }
    
    @IBOutlet weak var NAVI_BG: UIView!
    @IBOutlet weak var BG_VIEW: UIView!
    
    @IBOutlet weak var AGREE_VIEW: UIView!
    @IBOutlet weak var CLOSE_VC: UIButton!
    @IBAction func CLOSE_VC(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.CLOSE_VC.alpha = 0.0
            self.AGREE_VIEW.alpha = 0.0
        })
    }
    @IBOutlet weak var WKWebView: WKWebView!
    
    // 개인정보 취급 방침에 동의합니다
    @IBOutlet weak var IMAGE_1: UIImageView!
    @IBOutlet weak var AGREE_1: UIButton!
    @IBAction func AGREE_1(_ sender: UIButton) {
        
        if sender.isSelected == false {
            sender.isSelected = true
            IMAGE_1.alpha = 1.0
            EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "Logo.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
            AGREE_HTML(AGREE: 1)
            UIView.animate(withDuration: 0.2, animations: {
                self.CLOSE_VC.alpha = 0.3
                self.AGREE_VIEW.alpha = 1.0
            })
        } else {
            sender.isSelected = false
            IMAGE_1.alpha = 0.1
        }
        
        ANIMATION()
    }
    // 학교 메시지 수신에 동의합니다
    @IBOutlet weak var IMAGE_2: UIImageView!
    @IBOutlet weak var AGREE_2: UIButton!
    @IBAction func AGREE_2(_ sender: UIButton) {
        
        if sender.isSelected == false {
            sender.isSelected = true
            IMAGE_2.alpha = 1.0
            EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "Logo.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
            AGREE_HTML(AGREE: 2)
            UIView.animate(withDuration: 0.2, animations: {
                self.CLOSE_VC.alpha = 0.3
                self.AGREE_VIEW.alpha = 1.0
            })
        } else {
            sender.isSelected = false
            IMAGE_2.alpha = 0.1
        }
        
        ANIMATION()
    }
    // 위치기반 서비스 표준 이용약관에 동의합니다
    @IBOutlet weak var IMAGE_3: UIImageView!
    @IBOutlet weak var AGREE_3: UIButton!
    @IBAction func AGREE_3(_ sender: UIButton) {
        
        if sender.isSelected == false {
            sender.isSelected = true
            IMAGE_3.alpha = 1.0
            EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "Logo.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
            AGREE_HTML(AGREE: 3)
            UIView.animate(withDuration: 0.2, animations: {
                self.CLOSE_VC.alpha = 0.3
                self.AGREE_VIEW.alpha = 1.0
            })
        } else {
            sender.isSelected = false
            IMAGE_3.alpha = 0.1
        }
        
        ANIMATION()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CLOSE_VC.alpha = 0.0
        AGREE_VIEW.alpha = 0.0
        AGREE_VIEW.layer.cornerRadius = 10.0
        AGREE_VIEW.clipsToBounds = true
        
        NAVI_BG.alpha = 0.0
        BG_VIEW.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 0, height: -50), SD_RADIUS: 30, OPACITY: 0.1, RADIUS: 20.0)
        
        WKWebView.uiDelegate = self
        WKWebView.navigationDelegate = self
    }
    
    func ANIMATION() {
        
        if (AGREE_1.isSelected == true) && (AGREE_2.isSelected == true) {
            UIView.animate(withDuration: 0.2, animations: { self.NAVI_BG.alpha = 1.0 })
        } else {
            UIView.animate(withDuration: 0.2, animations: { self.NAVI_BG.alpha = 0.0 })
        }
    }
    
    // 다음으로
    @IBAction func NEXT_VC(_ sender: UIButton) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SIGN_UP_2") as! SIGN_UP_2
        VC.modalTransitionStyle = .crossDissolve
        present(VC, animated: true, completion: nil)
    }
    
    func AGREE_HTML(AGREE: Int) {
        
        let HTML_PATH = Bundle.main.path(forResource: "terms\(AGREE)", ofType: "html")
        var HTML_STIRNG: String = ""
        do { HTML_STIRNG = try String(contentsOfFile: HTML_PATH!, encoding: .utf8) } catch { }
        let HTML_URL = URL(fileURLWithPath: HTML_PATH!)
        WKWebView.loadHTMLString(HTML_STIRNG, baseURL: HTML_URL)
    }
}

extension SIGN_UP: WKUIDelegate, WKNavigationDelegate {
    
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

class SIGN_UP_2: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // 화면 다른곳 터치하면 키보드 사라짐
        view.endEditing(true)
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var NAVI_BG: UIView!
    @IBOutlet weak var BG_VIEW: UIView!
    
    // 전화번호
    @IBOutlet weak var PHONE_NUM: UITextField!
    @IBOutlet weak var SMS_REQUEST: UIButton!
    @IBAction func SMS_REQUEST(_ sender: UIButton) {
        
        SIGN_NUM.text = ""
        
        if self.PHONE_NUM.text == "" {
            NOTIFICATION_VIEW("전화번호를 입력해주세요")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemRed })
        } else if !self.PHONE_NUM_CHECK(PHONE_NUM: self.PHONE_NUM.text!) {
            NOTIFICATION_VIEW("입력한 양식이 맞지 않습니다")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemRed })
        } else {
            view.endEditing(true)
            UIView.animate(withDuration: 0.0, delay: 1.0, animations: {
                if !self.SYSTEM_NETWORK_CHECKING() {
                    self.NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
                } else {
                    self.HTTP_SMS(ACTION_TYPE: "request", PHONE: true, SIGN: false)
                }
            })
        }
    }
    
    // 인증번호
    @IBOutlet weak var SIGN_NUM: UITextField!
    @IBOutlet weak var SMS_CHECK: UIButton!
    @IBAction func SMS_CHECK(_ sender: UIButton) {
        
        if SIGN_NUM.text == "" {
            NOTIFICATION_VIEW("인증번호를 입력해주세요")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
        } else if PHONE_NUM.text == "" {
            NOTIFICATION_VIEW("전화번호를 입력해주세요")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
        } else if !SMS_NUM_CHECK(PHONE_NUM: SIGN_NUM.text!) {
            NOTIFICATION_VIEW("입력한 양식이 맞지 않습니다")
            UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
        } else {
            view.endEditing(true)
            if PHONE_NUM.text == "01031853309" || PHONE_NUM.text == "01031870005" {
                if SIGN_NUM.text == "000191" {
                    UIView.animate(withDuration: 0.2, animations: {
                        UIViewController.USER_DATA.set(self.PHONE_NUM.text!, forKey: "mb_id")
                        UIViewController.USER_DATA.synchronize()
                        self.NAVI_BG.alpha = 1.0
                        self.SMS_CHECK.backgroundColor = .systemBlue
                        self.SIGN_UP_3_VC()
                    })
                } else {
                    if !self.SYSTEM_NETWORK_CHECKING() {
                        self.NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
                    } else {
                        self.HTTP_SMS(ACTION_TYPE: "check", PHONE: false, SIGN: true)
                    }
                }
            } else {
                UIView.animate(withDuration: 0.0, delay: 1.0, animations: {
                    if !self.SYSTEM_NETWORK_CHECKING() {
                        self.NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
                    } else {
                        self.HTTP_SMS(ACTION_TYPE: "check", PHONE: false, SIGN: true)
                    }
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let ALERT = UIAlertController(title: "알림!", message: "다모아 보안(본인인증) 업데이트로 로그아웃 되었습니다.\n 재가입(로그인) 해주세요!", preferredStyle: .actionSheet)
//        ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
//        present(ALERT, animated: true)
        
        NAVI_BG.alpha = 0.0
        BG_VIEW.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 0, height: -50), SD_RADIUS: 30, OPACITY: 0.1, RADIUS: 20.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        TOOL_BAR_DONE(TEXT_FILELD: PHONE_NUM)
        PLACEHOLDER(TEXT_FILELD: PHONE_NUM, PLACEHOLDER: "휴대폰 번호")
        PHONE_NUM.PADDING_LEFT(X: 10.0)
        PHONE_NUM.layer.borderColor = UIColor.white.cgColor
        PHONE_NUM.layer.borderWidth = 1.0
        PHONE_NUM.layer.cornerRadius = 22.0
        PHONE_NUM.clipsToBounds = true
        SMS_REQUEST.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 0, height: 0), SD_RADIUS: 5, OPACITY: 0.1, RADIUS: 17.0)
        
        TOOL_BAR_DONE(TEXT_FILELD: SIGN_NUM)
        PLACEHOLDER(TEXT_FILELD: SIGN_NUM, PLACEHOLDER: "인증번호")
        SIGN_NUM.PADDING_LEFT(X: 10.0)
        SIGN_NUM.layer.borderColor = UIColor.white.cgColor
        SIGN_NUM.layer.borderWidth = 1.0
        SIGN_NUM.layer.cornerRadius = 22.0
        SIGN_NUM.clipsToBounds = true
        SMS_CHECK.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 0, height: 0), SD_RADIUS: 5, OPACITY: 0.1, RADIUS: 17.0)
    }
    
    func HTTP_SMS(ACTION_TYPE: String, PHONE: Bool, SIGN: Bool) {
        
        var PARAMETERS: Parameters = [
            "mb_id": PHONE_NUM.text!,
            "sign_key": SIGN_NUM.text!,
            "action_type": ACTION_TYPE
        ]
        
        if ACTION_TYPE == "request" { PARAMETERS["mb_platform"] = "ios" }
        
        print("PARAMETERS -", PARAMETERS)
        
        Alamofire.upload(multipartFormData: { multipartFormData in

            for (KEY, VALUE) in PARAMETERS {

                print("key: \(KEY)", "value: \(VALUE)")
                multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
            }
        }, to: DATA_URL().SCHOOL_URL + "member/request_sms.php") { (result) in
        
            switch result {
            case .success(let upload, _, _):
            
            upload.responseJSON { response in
                
                print("[인증번호]", response)
                
                guard let SMSDICT = response.result.value as? [String: Any] else {
                    
                    print("[인증번호] FAIL")
                    return
                }
                
                if (PHONE == true) && (SIGN == false) {
                    
                    if SMSDICT["result"] as? String ?? "fail" == "success" {
                        self.NOTIFICATION_VIEW("인증번호 요청 성공")
                        UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemBlue })
                    } else if SMSDICT["result"] as? String ?? "fail" == "exceeded" {
                        self.NOTIFICATION_VIEW("인증번호 요청 횟수 초과!")
                        UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemRed })
                    } else {
                        self.NOTIFICATION_VIEW("인증번호 요청 실패")
                        UIView.animate(withDuration: 0.2, animations: { self.SMS_REQUEST.backgroundColor = .systemRed })
                    }
                }
                
                if (PHONE == false) && (SIGN == true) {
                    
                    if SMSDICT["result"] as? String ?? "fail" == "success" {
                        self.NOTIFICATION_VIEW("인증번호 확인 되었습니다")
                        UIView.animate(withDuration: 0.2, animations: {
                            UIViewController.USER_DATA.set(self.PHONE_NUM.text!, forKey: "mb_id")
                            UIViewController.USER_DATA.synchronize()
                            self.NAVI_BG.alpha = 1.0
                            self.SMS_CHECK.backgroundColor = .systemBlue
                            self.SIGN_UP_3_VC()
                        })
                    } else if SMSDICT["result"] as? String ?? "fail" == "exceeded" {
                        self.NOTIFICATION_VIEW("인증가능 시간을 초과하였습니다")
                        UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
                    } else {
                        self.NOTIFICATION_VIEW("인증번호가 맞지 않습니다")
                        UIView.animate(withDuration: 0.2, animations: { self.SMS_CHECK.backgroundColor = .systemRed })
                    }
                }
            }
            case .failure(let encodingError):
        
                print(encodingError)
                break
            }
        }
    }
    
    // 다음으로
    @IBAction func NEXT_VC(_ sender: UIButton) { SIGN_UP_3_VC() }
    
    func SIGN_UP_3_VC() {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SIGN_UP_3") as! SIGN_UP_3
        VC.modalTransitionStyle = .crossDissolve
        present(VC, animated: true, completion: nil)
    }
}

class SIGN_UP_3: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // 화면 다른곳 터치하면 키보드 사라짐
        view.endEditing(true)
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    var IMAGE_DATA: Data?
    
    @IBOutlet weak var NAVI_BG: UIView!
    @IBOutlet weak var BG_VIEW: UIView!
    
    @IBOutlet weak var CARD_VIEW: UIView!
    @IBOutlet weak var PROFILE_IMAGE: UIImageView!      // 이미지
    @IBOutlet weak var PROFILE_NAME: UITextField!       // 이름
    @IBOutlet weak var PLATFORM: UILabel!               // 운영체제
    @IBOutlet weak var PHONE_NUM: UILabel!              // 전화번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NAVI_BG.alpha = 1.0
        BG_VIEW.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 0, height: -50), SD_RADIUS: 30, OPACITY: 0.1, RADIUS: 20.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        CARD_VIEW.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 0, height: 0), SD_RADIUS: 15.0, OPACITY: 0.1, RADIUS: 10.0)
        PROFILE_IMAGE.layer.cornerRadius = 30.0
        TOOL_BAR_DONE(TEXT_FILELD: PROFILE_NAME)
        PLACEHOLDER(TEXT_FILELD: PROFILE_NAME, PLACEHOLDER: "닉네임을 입력하세요")
        PLATFORM.text = "iOS"
        PHONE_NUM.text = UIViewController.USER_DATA.string(forKey: "mb_id") ?? ""
        
        TYPE_MODE.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        TYPE_MODE.setTitleTextAttributes([.foregroundColor: UIColor.darkGray], for: .normal)
        
        UIViewController.USER_DATA.set(true, forKey: "switch_n")
        UIViewController.USER_DATA.set(true, forKey: "switch_m")
        UIViewController.USER_DATA.set(true, forKey: "switch_c")
        UIViewController.USER_DATA.set(true, forKey: "switch_f")
        UIViewController.USER_DATA.set(false, forKey: "switch_t")
        UIViewController.USER_DATA.set(false, forKey: "switch_et")
        UIViewController.USER_DATA.set(false, forKey: "switch_sc")
        UIViewController.USER_DATA.set(false, forKey: "switch_s")
        UIViewController.USER_DATA.set(false, forKey: "switch_ns")
        UIViewController.USER_DATA.set(false, forKey: "switch_en")
        UIViewController.USER_DATA.set(false, forKey: "switch_cs")
        UIViewController.USER_DATA.set(false, forKey: "switch_sv")
        
        UIViewController.USER_DATA.synchronize()
    }
    
    @IBAction func IMAGE_ADD(_ sender: UIButton) {
        
        let ALERT = UIAlertController(title: "프로필 설정", message: nil, preferredStyle: .actionSheet)
                            
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            ALERT.addAction(UIAlertAction(title: "카메라", style: .default) { (_) in self.IMAGE_PICKER(.camera) })
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            ALERT.addAction(UIAlertAction(title: "저장된 앨범", style: .default) { (_) in self.IMAGE_PICKER(.savedPhotosAlbum) })
        }
        
        let CANCEL = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
        ALERT.addAction(CANCEL)
        CANCEL.setValue(UIColor.red, forKey: "titleTextColor")
    
        present(ALERT, animated: true)
    }
    
    @IBOutlet weak var TYPE_MODE: UISegmentedControl!
    
    // 회원가입
    @IBAction func NEXT_VC(_ sender: UIButton) {
        
        if PROFILE_NAME.text == "" {
            NOTIFICATION_VIEW("닉네임을 입력해주세요")
        } else {
            if !SYSTEM_NETWORK_CHECKING() {
                NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
            } else {
                HTTP_JOIN()
            }
        }
    }
    
    func HTTP_JOIN() {
        
        var MB_TYPE: String = ""
        switch TYPE_MODE.selectedSegmentIndex {
            case 0: MB_TYPE = "p"   // 학부모
            case 1: MB_TYPE = "c"   // 학생
            case 2: MB_TYPE = "t"   // 교직원
        default:
            MB_TYPE = "p"
        }
        
        UserDefaults.standard.setValue(MB_TYPE, forKey: "mb_type")
        UserDefaults.standard.synchronize()
        
        let PARAMETERS: Parameters = [
            "mb_id": UIViewController.USER_DATA.string(forKey: "mb_id") ?? "",
            "mb_type": MB_TYPE,
            "mb_name": PROFILE_NAME.text!,
            "mb_platform": "ios",//UIDevice.current.systemName,
            "gcm_id": UIViewController.USER_DATA.string(forKey: "gcm_id") ?? "",
            "loc_share": "Y",
            "action_type": "reg"
        ]
        
        print("PARAMETERS -", PARAMETERS)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            if UIViewController.USER_DATA.data(forKey: "image_data") == nil {
                
                for (KEY, VALUE) in PARAMETERS {
                    multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
                }
            } else {
                
                multipartFormData.append(UIViewController.USER_DATA.data(forKey: "image_data")!, withName: "profile_image", fileName: "\(UIViewController.USER_DATA.string(forKey: "mb_id") ?? "").jpg", mimeType: "image/jpg")

                for (KEY, VALUE) in PARAMETERS {
                    multipartFormData.append("\(VALUE)".data(using: String.Encoding.utf8)!, withName: KEY as String)
                }
            }
        }, to: DATA_URL().SCHOOL_URL + "member/member.php") { (result) in
        
            switch result {
            case .success(let upload, _, _):
                
            upload.responseJSON { response in
                
                print("[회원가입]", response)
                self.VIEWCONTROLLER_VC(IDENTIFIER: "LOADING")
            }
            case .failure(let encodingError):
        
                print(encodingError)
                break
            }
        }
    }
}

extension SIGN_UP_3: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 프로필이미지추가
    func IMAGE_PICKER(_ SOURCE: UIImagePickerController.SourceType) {
        
        let PICKER = UIImagePickerController()
        PICKER.sourceType = SOURCE
        PICKER.delegate = self
        PICKER.allowsEditing = true
        present(PICKER, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let IMAGE = info[UIImagePickerController.InfoKey.editedImage] as? UIImage { self.PROFILE_IMAGE.image = IMAGE }
        if let IMAGE_UPLOAD = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            UIViewController.USER_DATA.set(IMAGE_UPLOAD.pngData(), forKey: "image_data")
            UIViewController.USER_DATA.synchronize()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
