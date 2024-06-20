//
//  AS_CALL.swift
//  busan-damoa
//
//  Created by 장 제현 on 2021/04/15.
//  Copyright © 2021 장제현. All rights reserved.
//

import UIKit

class AS_CALL: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    @IBOutlet weak var CALL: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CALL.addTarget(self, action: #selector(CALL(_:)), for: .touchUpInside)
    }
    
    @objc func CALL(_ sender: UIButton) {
        
        UIApplication.shared.open(URL(string: "tel://" + "0518600885")!)
    }
}
