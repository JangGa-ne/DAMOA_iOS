//
//  DETAIL_SOSIK_WEB.swift
//  busan-damoa
//
//  Created by 장 제현 on 2021/03/13.
//  Copyright © 2021 장제현. All rights reserved.
//

import UIKit
import WebKit

class DETAIL_SOSIK_WEB: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var TITLE: String = ""
    var REQUEST_URL: URLRequest? = nil
    
    @IBOutlet weak var NAVI_BG: UIVisualEffectView!
    @IBOutlet weak var NAVI_TITLE: UILabel!
    @IBOutlet weak var PROGRESSVIEW: UIProgressView!
    @IBOutlet weak var WKWEBVIEW: WKWebView!
    @IBOutlet weak var FOOTER_BG: UIVisualEffectView!
    
    @IBOutlet weak var BACK_WEB: UIButton!
    @IBOutlet weak var NEXT_WEB: UIButton!
    @IBOutlet weak var REFRESH_WEB: UIButton!
    
    let VIEW = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NAVI_TITLE.text = TITLE
        
        WKWEBVIEW.uiDelegate = self
        WKWEBVIEW.navigationDelegate = self
        WKWEBVIEW.allowsBackForwardNavigationGestures = true
        WKWEBVIEW.scrollView.showsHorizontalScrollIndicator = false
        WKWEBVIEW.scrollView.showsVerticalScrollIndicator = false
        WKWEBVIEW.load(REQUEST_URL ?? URLRequest(url: URL(string: "https://home.pen.go.kr")!))
        
        WKWEBVIEW.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        BACK_WEB.addTarget(self, action: #selector(BACK_WEB(_:)), for: .touchUpInside)
        NEXT_WEB.addTarget(self, action: #selector(NEXT_WEB(_:)), for: .touchUpInside)
        REFRESH_WEB.addTarget(self, action: #selector(REFRESH_WEB(_:)), for: .touchUpInside)
    }
    
    deinit {
        WKWEBVIEW.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
    
    @objc func BACK_WEB(_ sender: UIButton) {
        WKWEBVIEW.goBack()//; WKWEBVIEW.reload()
    }
    @objc func NEXT_WEB(_ sender: UIButton) {
        WKWEBVIEW.goForward()//; WKWEBVIEW.reload()
    }
    @objc func REFRESH_WEB(_ sender: UIButton) {
        WKWEBVIEW.reload()
    }
}

extension DETAIL_SOSIK_WEB: WKUIDelegate, WKNavigationDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if WKWEBVIEW.estimatedProgress > 0 && WKWEBVIEW.estimatedProgress < 1 {
            PROGRESSVIEW.isHidden = false
            PROGRESSVIEW.progress = Float(WKWEBVIEW.estimatedProgress)
        } else {
            PROGRESSVIEW.isHidden = true
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        EFFECT_INDICATOR_VIEW(VIEW, UIImage(named: "Logo.png")!, "데이터 불러오는 중", "잠시만 기다려 주세요")
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        if navigationAction.targetFrame == nil { webView.load(navigationAction.request) }
        return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        webView.evaluateJavaScript("document.documentElement.outerHTML") { (value, error) in
            let DOWNLOAD = "\(navigationAction.request)".contains("fileDownload")
            
            if navigationAction.navigationType == .linkActivated && DOWNLOAD {
                self.FILE_DOWNLOAD(FILE_URL: "\(navigationAction.request)", FILE_NAME: "\(navigationAction.request)")
                
                decisionHandler(.cancel)
                return
            } else {
                decisionHandler(.allow)
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        ALERT(TITLE: "", BODY: message, STYLE: .alert)
        completionHandler()
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let ALERT = UIAlertController(title: "", message: message, preferredStyle: .alert)
        ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in completionHandler(true) }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (_) in completionHandler(false) }))
        present(ALERT, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let ALERT = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        ALERT.addTextField { (TEXTFIELD) in TEXTFIELD.text = defaultText }
        ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
            if let TEXT = ALERT.textFields?.first?.text { completionHandler(TEXT) } else { completionHandler(defaultText) }
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (_) in completionHandler(nil) }))
        present(ALERT, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        CLOSE_EFFECT_INDICATOR_VIEW(VIEW: VIEW)
        BACK_WEB.isEnabled = webView.canGoBack
        NEXT_WEB.isEnabled = webView.canGoForward
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        CLOSE_EFFECT_INDICATOR_VIEW(VIEW: VIEW)
        BACK_WEB.isEnabled = webView.canGoBack
        NEXT_WEB.isEnabled = webView.canGoForward
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        CLOSE_EFFECT_INDICATOR_VIEW(VIEW: VIEW)
        BACK_WEB.isEnabled = webView.canGoBack
        NEXT_WEB.isEnabled = webView.canGoForward
    }
}
