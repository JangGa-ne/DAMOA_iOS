//
//  PASSWORD.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/09/08.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import LocalAuthentication

enum PASSWORD_TYPE: Int {
    case SUBSCRIBE
    case UNSUBSCRIBE
}

class PASSWORD: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var PLACE: String = ""
    var DID_TAP_PASSWORD_TYPE: ((PASSWORD_TYPE) -> Void)?
    
    @IBAction func BACK(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var VIEW: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VIEW.layer.cornerRadius = 20.0
        VIEW.clipsToBounds = true
        
        SUBSCRIBE.layer.cornerRadius = 10.0
        SUBSCRIBE.clipsToBounds = true
        
        if DEVICE_RATIO() {
            PLACE = "[설정 > Face ID 및 암호]"
        } else {
            PLACE = "[설정 > Touch ID 및 암호]"
        }
    }
    
    @IBOutlet weak var SUBSCRIBE: UIButton!
    @IBAction func SUBSCRIBE(_ sender: UIButton) {
        
        // 생체인증 확인
        var ERROR: NSError?
        let EVALUATED = LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: &ERROR)
        
        if EVALUATED == true {
            guard let PASSWORD_TYPE_ = PASSWORD_TYPE(rawValue: 0) else { return }
            self.dismiss(animated: true) { [weak self] in self?.DID_TAP_PASSWORD_TYPE?(PASSWORD_TYPE_) }
        } else {
            let ALERT = UIAlertController(title: "생체인증 설정 오류", message: "\(PLACE)에서 생체인증 확인해 주시기 바랍니다.", preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "확인", style: .default) { (_) in
                guard let PASSWORD_TYPE_ = PASSWORD_TYPE(rawValue: 1) else { return }
                self.dismiss(animated: true) { [weak self] in self?.DID_TAP_PASSWORD_TYPE?(PASSWORD_TYPE_) }
            })
            self.present(ALERT, animated: true)
        }
    }
    @IBOutlet weak var UNSUBSCRIBE: UIButton!
    @IBAction func UNSUBSCRIBE(_ sender: UIButton) {
    
        guard let PASSWORD_TYPE_ = PASSWORD_TYPE(rawValue: 1) else { return }
        dismiss(animated: true) { [weak self] in self?.DID_TAP_PASSWORD_TYPE?(PASSWORD_TYPE_) }
    }
}
