//
//  SETTING_ENROLL.swift
//  busan-damoa
//
//  Created by 장 제현 on 2021/03/16.
//  Copyright © 2021 장제현. All rights reserved.
//

import UIKit

class SETTING_ENROLL: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { VIEWCONTROLLER_VC(IDENTIFIER: "HOME") }
    @IBAction func NEXT_VC(_ sender: UIButton) { VIEWCONTROLLER_VC(IDENTIFIER: "ENROLL") }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue(true, forKey: "enroll")
        UserDefaults.standard.synchronize()
    }
}
