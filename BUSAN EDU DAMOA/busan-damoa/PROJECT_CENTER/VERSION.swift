//
//  VERSION.swift
//  부산교육 다모아
//
//  Created by i-Mac on 2020/07/02.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit

class VERSION: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }

    @IBOutlet weak var NEW_VERSION: UILabel!
    @IBOutlet weak var NOW_VERSION: UILabel!
    
    @IBOutlet weak var UPDATE_VC: UIView!
    @IBOutlet weak var VC_BUTTON: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let STORE_VERSION = UIViewController.APPDELEGATE.NEW_VERSION
        let APP_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String // 현재 버전

        print("최신 버전: \(STORE_VERSION)")
        print("현재 버전: \(APP_VERSION)")
        
        NEW_VERSION.text = "최신버전 : \(STORE_VERSION)"
        NOW_VERSION.text = "현재버전 : \(APP_VERSION)"
        
        if APP_VERSION < STORE_VERSION {
            UPDATE_VC.backgroundColor = .systemBlue
            VC_BUTTON.addTarget(self, action: #selector(OPEN_UPDATE(_:)), for: .touchUpInside)
        } else {
            UPDATE_VC.backgroundColor = .darkGray
        }
    }
}
