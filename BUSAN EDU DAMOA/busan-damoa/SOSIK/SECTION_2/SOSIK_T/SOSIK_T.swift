//
//  SOSIK_T.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/05/13.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

// 학부모연수
class SOSIK_T: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    var PARENT_API: [PARENT_TRAINING] = []
    
    @IBAction func HOME_PAGE(_ sender: UIButton) { UIApplication.shared.open(URL(string: "https://home.pen.go.kr/yeyak/main.do")!) }
    
    @IBOutlet weak var NAVI_TITLE: UILabel!
    @IBOutlet weak var WKWEBVIEW_1: WKWebView!
    @IBOutlet weak var WKWEBVIEW_2: WKWebView!
    
    let BACK = UIButton()
    let POPUP = WKWebView()
    
    // 로딩인디케이터
    let VIEW = UIView()
    
    // 학부모지원센터연수
    @IBOutlet weak var CENTER_BG: UIView!
    @IBOutlet weak var CENTER_IMAGE: UIImageView!
    @IBOutlet weak var CENTER: UIButton!
    @IBAction func CENTER(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.WKWEBVIEW_2.alpha = 0.0
            self.CENTER_BG.backgroundColor = .systemTeal
            self.CENTER_IMAGE.image = UIImage(named: "house.png")
            
            self.WKWEBVIEW_1.alpha = 1.0
            self.OFFICE_BG.backgroundColor = .GRAY_F1F1F1
            self.OFFICE_IMAGE.image = UIImage(named: "house_off.png")
            
            self.BACK.alpha = 0.0
        }, completion: { (isCompleted) in
            
            self.BACK.removeFromSuperview()
        })
    }
    
    // 교육청연수
    @IBOutlet weak var OFFICE_BG: UIView!
    @IBOutlet weak var OFFICE_IMAGE: UIImageView!
    @IBOutlet weak var OFFICE: UIButton!
    @IBAction func OFFICE(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.WKWEBVIEW_1.alpha = 0.0
            self.OFFICE_BG.backgroundColor = .systemTeal
            self.OFFICE_IMAGE.image = UIImage(named: "house.png")
            
            self.WKWEBVIEW_2.alpha = 1.0
            self.CENTER_BG.backgroundColor = .GRAY_F1F1F1
            self.CENTER_IMAGE.image = UIImage(named: "house_off.png")
            
            self.BACK.alpha = 0.0
        }, completion: { (isCompleted) in
            
            self.BACK.removeFromSuperview()
        })
    }
    
    override func loadView() {
        super.loadView()
        
        UIViewController.APPDELEGATE.T_CHECK = false
        
        let STORE_VERSION = UIViewController.APPDELEGATE.NEW_VERSION
        let NOW_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String // 현재 버전
        
        if NOW_VERSION < STORE_VERSION {
            if !DEVICE_RATIO() {
                EFFECT_UPDATE_NOTI(UIView(), NAVI_TITLE, "iOS 새로운 버전 업데이트 알림", "버전 \(STORE_VERSION) 으로 업데이트 해주세요", Y: 20.0)
            } else {
                EFFECT_UPDATE_NOTI(UIView(), NAVI_TITLE, "iOS 새로운 버전 업데이트 알림", "버전 \(STORE_VERSION) 으로 업데이트 해주세요", Y: 34.0)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.APPDELEGATE.SOSIK_T_VC = self
        
        PUSH_BADGE(BOARD_TYPE: "T", false)
        
        WKWEBVIEW_2.alpha = 0.0
        
        // 교육연수
        WKWEBVIEW_1.uiDelegate = self
        WKWEBVIEW_1.navigationDelegate = self
        WKWEBVIEW_1.scrollView.showsHorizontalScrollIndicator = false
        WKWEBVIEW_1.scrollView.showsVerticalScrollIndicator = false
        WKWEBVIEW_1.load(URLRequest(url: URL(string: "https://home.pen.go.kr/yeyak/edu/instt/selectDamoaEduList.do")!))
        // 평생교육
        WKWEBVIEW_2.uiDelegate = self
        WKWEBVIEW_2.navigationDelegate = self
        WKWEBVIEW_2.scrollView.showsHorizontalScrollIndicator = false
        WKWEBVIEW_2.scrollView.showsVerticalScrollIndicator = false
        WKWEBVIEW_2.load(URLRequest(url: URL(string: "https://home.pen.go.kr/yeyak/edu/lib/selectDamoaEduList.do")!))
    }
}

extension SOSIK_T: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "Logo.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil { webView.load(navigationAction.request) }
        return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        webView.evaluateJavaScript("document.documentElement.outerHTML") { (value, error) in
            
            let INFO_1 = "\(navigationAction.request)".contains("selectEduInfo")
            let INFO_2 = "\(navigationAction.request)".contains("selectEduInfo")
            
            if navigationAction.navigationType == .formSubmitted && (INFO_1 || INFO_2) {
                
                // 진동 이벤트
                UIImpactFeedbackGenerator().impactOccurred()
                
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "DETAIL_SOSIK_WEB") as! DETAIL_SOSIK_WEB
                if webView == self.WKWEBVIEW_1 { VC.TITLE = "학부모연수(교육연수)" } else { VC.TITLE = "학부모연수(평생교육)" }
                VC.REQUEST_URL = navigationAction.request
                self.present(VC, animated: true, completion: nil)
                
                decisionHandler(.cancel)
                return
            } else {
                
                decisionHandler(.allow)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        CLOSE_EFFECT_INDICATOR_VIEW(VIEW: VIEW)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        CLOSE_EFFECT_INDICATOR_VIEW(VIEW: VIEW)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        CLOSE_EFFECT_INDICATOR_VIEW(VIEW: VIEW)
    }
}
