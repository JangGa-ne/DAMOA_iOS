//
//  SETTING_UPDATE_LOC.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2021/01/28.
//

import UIKit

class SETTING_UPDATE_LOC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var BG_VIEW: UIView!
    // 업데이트 주기
    @IBOutlet weak var SLIDER: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BG_VIEW.layer.cornerRadius = 20.0
        BG_VIEW.clipsToBounds = true
        // 업데이트 주기
        SLIDER.minimumValue = 1
        SLIDER.maximumValue = 10
        if UserDefaults.standard.integer(forKey: "loc_slider") == 0 {
            SLIDER.value = 3
        } else {
            SLIDER.value = Float(UserDefaults.standard.integer(forKey: "loc_slider"))
        }
        SLIDER.addTarget(self, action: #selector(SLIDER(_:)), for: .touchUpInside)
    }
    
    @objc func SLIDER(_ sender: UISlider) {
        
        UserDefaults.standard.setValue(Int(round(sender.value)), forKey: "loc_slider")
        UserDefaults.standard.synchronize()
    }
}
