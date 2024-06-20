//
//  FILE_VIEWER.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/29.
//

import UIKit
import WebKit
import Alamofire

//MARK: - 소식 파일 뷰어
class FILE_VIEWER: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var SOSIK_LIST: [SOSIK_API] = []
    var SOSIK_POSITION: Int = 0
    
    var IDX: String = ""
    var MSG_GROUP: String = ""
    var DT_FROM: String = ""
    var MEDIA_FILES: String = ""
    var FILE_NAME_ORG: String = ""
    
    // 웹뷰
    @IBOutlet weak var WKWEBVIEW: WKWebView!
    // 첨부파일 다운로드
    @IBOutlet weak var DOWNLOAD: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로딩 화면
        ON_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR, "데이터 불러오는 중...")
        
        // 네트워크 연결 확인
        NETWORK_CHECK()
        
        // 웹뷰 연결
        WKWEBVIEW.uiDelegate = self
        WKWEBVIEW.navigationDelegate = self
        WKWEBVIEW.scrollView.showsVerticalScrollIndicator = false
        WKWEBVIEW.scrollView.showsHorizontalScrollIndicator = false
        WKWEBVIEW.scrollView.bouncesZoom = false
        
        // 첨부파일 다운로드
        DOWNLOAD.addTarget(self, action: #selector(DOWNLOAD(_:)), for: .touchUpInside)
    }
    
    // 네트워크 연결 확인
    @objc func NETWORK_CHECK() {
        
        if SYSTEM_NETWORK_CHECKING() {
            GET_POST_DATA(NAME: "파일뷰어", ACTION_TYPE: "")
        } else {
            VIEW_NOTICE("N: 네트워크 상태를 확인해 주세요")
            DispatchQueue.main.async {
                let ALERT = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                ALERT.addAction(UIAlertAction(title: "새로고침", style: .default) { (_) in self.NETWORK_CHECK() })
                self.present(ALERT, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - 파일뷰어 불러오기
    func GET_POST_DATA(NAME: String, ACTION_TYPE: String) {
        
        let POST_URL: String = "https://damoaapp.pen.go.kr/viewer/index.php"
        let PARAMETERS: Parameters = [
            "idx": IDX,
            "msg_group": MSG_GROUP,
            "dt_from": DT_FROM
        ]
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 30.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseString(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
//            print(response)
            
            switch response.result {
            case .success(_):
            
                guard let DATA_STRING = response.result.value else { return }
                // 데이터 추가
                self.WKWEBVIEW.loadHTMLString(DATA_STRING, baseURL: nil)
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.VIEW_NOTICE("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.VIEW_NOTICE("E: 네트워크 연결 실패 (000)"); self.NETWORK_CHECK() }
                
                self.ALAMOFIRE_ERROR(ERROR: response.result.error as? AFError)
            }
        })
    }
    
    // 첨부파일 다운로드
    @objc func DOWNLOAD(_ sender: UIButton) {
        
        // 진동 이벤트
        UIImpactFeedbackGenerator().impactOccurred()
        
//        FILE(SOSIK_LIST: SOSIK_LIST, TAG: SOSIK_POSITION)
        FILE_DOWNLOAD(FILE_URL: MEDIA_FILES, FILE_NAME: FILE_NAME_ORG)
    }
}

extension FILE_VIEWER: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil { webView.load(navigationAction.request) }
        return nil
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.OFF_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.OFF_VIEW_LOADING(UIViewController.VIEW, UIViewController.INDICATOR)
    }
}
