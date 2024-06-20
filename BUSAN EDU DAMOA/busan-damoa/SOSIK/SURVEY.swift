//
//  SURVEY.swift
//  busan-damoa
//
//  Created by 장 제현 on 2020/10/31.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import WebKit

class SURVEY: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    var POLL_NUM: String = ""
    
    // 로딩인디케이터
    let VIEW = UIView()
    
    @IBOutlet weak var Navi_Title: UILabel!
    @IBOutlet weak var WKWebView: WKWebView!
    
    override func loadView() {
        super.loadView()
        
        CHECK_VERSION(Navi_Title)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let MB_ID = UIViewController.USER_DATA.string(forKey: "mb_id") ?? ""
        
        WKWebView.uiDelegate = self
        WKWebView.navigationDelegate = self
        WKWebView.scrollView.showsHorizontalScrollIndicator = false
        WKWebView.scrollView.showsVerticalScrollIndicator = false
        WKWebView.translatesAutoresizingMaskIntoConstraints = false
        WKWebView.load(URLRequest(url: URL(string: "https://damoaapp.pen.go.kr/card/_sv.php?poll_num=\(POLL_NUM)&mb_id=\(MB_ID)&po_index=1")!))
    }
}

extension SURVEY: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil { webView.load(navigationAction.request) }
        return nil
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "Logo.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
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
