//
//  SETTING_BASE.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/18.
//

import UIKit
import AFNetworking

//MARK: - 기본 설정
extension UIViewController {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        self.modalPresentationStyle = .fullScreen
    }
    
    static var USER_DATA = UserDefaults.standard
    static var APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
    static var FEEDBACK_GENERATOR = UINotificationFeedbackGenerator()
    static var DOCUMENT_INTERACTION: UIDocumentInteractionController!
    
    func VIEWCONTROLLER_VC(IDENTIFIER: String) {
        
        if IDENTIFIER == "ENROLL" {
            UserDefaults.standard.set(1, forKey: "PUSH_SC")
            UserDefaults.standard.synchronize()
        }
        
        DispatchQueue.main.async {
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: IDENTIFIER)
            VC!.modalTransitionStyle = .crossDissolve
            self.present(VC!, animated: true, completion: nil)
        }
    }
    
    //MARK: - 소식 (미디어)
    func SET_ATTACHED_DATA(ATTACHED_ARRAY: [Any]) -> [ATTACHED] {
        
        var ATTACHED_LIST: [ATTACHED] = []
        
        for (_, DATA) in ATTACHED_ARRAY.enumerated() {
            
            let DATA_DICT = DATA as? [String: Any]
            let APPEND_VALUE = ATTACHED()
            
            APPEND_VALUE.SET_DATETIME(DATETIME: DATA_DICT?["datetime"] as Any)
            APPEND_VALUE.SET_DT_FROM(DT_FROM: DATA_DICT?["dt_from"] as Any)
            APPEND_VALUE.SET_DOWNLOAD_URL(DOWNLOAD_URL: DATA_DICT?["dwldUrl"] as Any)
            APPEND_VALUE.SET_FILE_NAME(FILE_NAME: DATA_DICT?["file_name"] as Any)
            APPEND_VALUE.SET_FILE_NAME_ORG(FILE_NAME_ORG: DATA_DICT?["file_name_org"] as Any)
            APPEND_VALUE.SET_FILE_SIZE(FILE_SIZE: DATA_DICT?["sysId"] as Any)
            APPEND_VALUE.SET_IDX(IDX: DATA_DICT?["idx"] as Any)
            APPEND_VALUE.SET_IN_SEQ(IN_SEQ: DATA_DICT?["in_seq"] as Any)
            APPEND_VALUE.SET_LAT(LAT: DATA_DICT?["lat"] as Any)
            APPEND_VALUE.SET_LNG(LNG: DATA_DICT?["lng"] as Any)
            APPEND_VALUE.SET_MEDIA_FILES(MEDIA_FILES: DATA_DICT?["media_files"] as Any)
            APPEND_VALUE.SET_MEDIA_TYPE(MEDIA_TYPE: DATA_DICT?["media_type"] as Any)
            APPEND_VALUE.SET_MSG_GROUP(MSG_GROUP: DATA_DICT?["msg_group"] as Any)
            
            ATTACHED_LIST.append(APPEND_VALUE)
        }
        
        return ATTACHED_LIST
    }
    
    // 로딩 프로그레스
    static let VIEW = UIView()
    static let INDICATOR = UIActivityIndicatorView()
    
    //MARK: - 첨부파일
    func FILE(SOSIK_LIST: [SOSIK_API], TAG: Int) {
        
        var MEDIA_LIST: [ATTACHED] = []
        
        for (_, DATA) in SOSIK_LIST[TAG].ATTACHED.enumerated() {
            
            let APPEND_VALUE = ATTACHED()
            
            if DATA.MEDIA_TYPE == "f" {
            
                APPEND_VALUE.SET_DATETIME(DATETIME: DATA.DATETIME as Any)
                APPEND_VALUE.SET_DT_FROM(DT_FROM: DATA.DT_FROM as Any)
                APPEND_VALUE.SET_DOWNLOAD_URL(DOWNLOAD_URL: DATA.DOWNLOAD_URL as Any)
                APPEND_VALUE.SET_FILE_NAME(FILE_NAME: DATA.FILE_NAME as Any)
                APPEND_VALUE.SET_FILE_NAME_ORG(FILE_NAME_ORG: DATA.FILE_NAME_ORG as Any)
                APPEND_VALUE.SET_FILE_SIZE(FILE_SIZE: DATA.FILE_SIZE as Any)
                APPEND_VALUE.SET_IDX(IDX: DATA.IDX as Any)
                APPEND_VALUE.SET_IN_SEQ(IN_SEQ: DATA.IN_SEQ as Any)
                APPEND_VALUE.SET_LAT(LAT: DATA.LAT as Any)
                APPEND_VALUE.SET_LNG(LNG: DATA.LNG as Any)
                APPEND_VALUE.SET_MEDIA_FILES(MEDIA_FILES: DATA.MEDIA_FILES as Any)
                APPEND_VALUE.SET_MEDIA_TYPE(MEDIA_TYPE: DATA.MEDIA_TYPE as Any)
                APPEND_VALUE.SET_MSG_GROUP(MSG_GROUP: DATA.MSG_GROUP as Any)
                
                MEDIA_LIST.append(APPEND_VALUE)
            }
        }
        
        let ALERT = UIAlertController(title: "미리보기 및 다운로드하고 싶은 파일을 선택해주세요", message: nil, preferredStyle: .actionSheet)
        
        for (_, DATA) in MEDIA_LIST.enumerated() {
            
            if DATA.FILE_SIZE == "" || DATA.FILE_SIZE == "Y" {
                // 다운로드
                ALERT.addAction(UIAlertAction(title: DATA.FILE_NAME_ORG, style: .default) { (_) in
                    //MARK: - 첨부파일 다운로드
                    self.FILE_DOWNLOAD(FILE_URL: DATA.MEDIA_FILES, FILE_NAME: DATA.FILE_NAME_ORG)
                })
            } else {
                // 미리보기
                ALERT.addAction(UIAlertAction(title: DATA.FILE_NAME_ORG, style: .default) { (_) in
                    //MARK: - 뷰어
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "FILE_VIEWER") as! FILE_VIEWER
                    VC.SOSIK_LIST = SOSIK_LIST
                    VC.SOSIK_POSITION = TAG
                    VC.IDX = DATA.IDX
                    VC.MSG_GROUP = DATA.MSG_GROUP
                    VC.DT_FROM = DATA.DT_FROM
                    VC.MEDIA_FILES = DATA.MEDIA_FILES
                    VC.FILE_NAME_ORG = DATA.FILE_NAME_ORG
                    self.present(VC, animated: true, completion: nil)
                })
            }
        }
        let CANCEL = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        CANCEL.setValue(UIColor.systemRed, forKey: "titleTextColor")
        ALERT.addAction(CANCEL)
        
        present(ALERT, animated: true, completion: nil)
    }
    
    //MARK: - 첨부파일 다운로드
    func FILE_DOWNLOAD(FILE_URL: String, FILE_NAME: String) {
        
        let NAME = "\(FILE_URL[FILE_URL.index(FILE_URL.endIndex, offsetBy: -3)])\(FILE_URL[FILE_URL.index(FILE_URL.endIndex, offsetBy: -2)])\(FILE_URL[FILE_URL.index(FILE_URL.endIndex, offsetBy: -1)])"
        
        if (NAME == "bmp") || (NAME == "BMP") {
            
            let ALERT = UIAlertController(title: "지원하지 않는 첨부파일입니다.", message: nil, preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(ALERT, animated: true)
        } else {
            
            let KOREAN_URL = FILE_URL.replacingOccurrences(of: "&2520", with: "%20").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            let MEDIA_FILE = URL(string: KOREAN_URL ?? "")
            var REQUEST: URLRequest? = nil
            if let MEDIA_FILE = MEDIA_FILE { REQUEST = URLRequest(url: MEDIA_FILE) }
            
            let SECURITY_POLICY = AFSecurityPolicy(pinningMode: AFSSLPinningMode.none)
            SECURITY_POLICY.allowInvalidCertificates = true
            SECURITY_POLICY.validatesDomainName = false
            
            let SESSION = AFHTTPSessionManager()
            SESSION.securityPolicy = SECURITY_POLICY
            
            let PROGRESS: Progress? = nil
            
            if REQUEST != nil {
                
                let DOWNLOAD_TAST = SESSION.downloadTask(with: REQUEST!, progress: nil, destination: { targetPath, response in
                    
                    let DOCUMENTS_DIRECTORY_PATH = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "")
                    return DOCUMENTS_DIRECTORY_PATH.appendingPathComponent(response.suggestedFilename!)
                }, completionHandler: { response, filePath, error in
                    
                    PROGRESS?.removeObserver(self, forKeyPath: "fractionCompleted", context: nil)
                    
                    UIViewController.DOCUMENT_INTERACTION = UIDocumentInteractionController()
                    UIViewController.DOCUMENT_INTERACTION = UIDocumentInteractionController(url: filePath!)
                    UIViewController.DOCUMENT_INTERACTION.name = FILE_NAME
                    UIViewController.DOCUMENT_INTERACTION.presentOpenInMenu(from: .zero, in: self.view, animated: true)
                })
                
                DOWNLOAD_TAST.resume()
                
                PROGRESS?.addObserver(self, forKeyPath: "fractionCompleted", options: .new, context: nil)
            } else {
                
                VIEW_NOTICE("E: 첨부파일 열 수 없음")
            }
        }
    }
    
    //MARK: - 공유하기
    func SHARE(SOSIK_LIST: [SOSIK_API], TAG: Int) {
        
        let DATA = SOSIK_LIST[TAG]
        
        if DATA.BOARD_KEY != "" {
            
            let TEXT = "[\(DATA.SC_NAME)]\n\n\(ENCODE(DATA.SUBJECT))\nhttps://damoaapp.pen.go.kr/card/_view.php?board_key=\(DATA.BOARD_KEY)&board_type=\(DATA.BOARD_TYPE)"
            
            let ACTIVITY_VC = UIActivityViewController(activityItems: [TEXT], applicationActivities: nil)
            ACTIVITY_VC.popoverPresentationController?.sourceView = self.view
            present(ACTIVITY_VC, animated: true, completion: nil)
        } else {
            
            VIEW_NOTICE("E: 공유할 수 없음")
        }
    }
}

extension UITableViewCell {
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
