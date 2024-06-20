//
//  REVIEW.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/10/20.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit

class REVIEW: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK(_ sender: UIButton) {
        
        if LikeView.alpha == 1.0 || DisikeView.alpha == 1.0 {
            
            UIViewController.USER_DATA.set(true, forKey: "review")
            UIViewController.USER_DATA.synchronize()
            dismiss(animated: true, completion: nil)
        } else {
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var REVIEW: UIView!
    @IBOutlet weak var REVIEW_CLOSE: UIButton!
    
    @IBOutlet weak var LikeView: UIView!
    @IBOutlet weak var DisikeView: UIView!
    
    @IBOutlet weak var CLOSE_IMAGE: UIView!
    @IBOutlet weak var CLOSE_BUTTON: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        REVIEW.layer.cornerRadius = 10.0
        REVIEW.clipsToBounds = true
        REVIEW_CLOSE.addTarget(self, action: #selector(CLOSE_FALSE(_:)), for: .touchUpInside)
        CLOSE_BUTTON.addTarget(self, action: #selector(CLOSE_TRUE(_:)), for: .touchUpInside)
        
        LikeView.alpha = 0.0
        DisikeView.alpha = 0.0
        CLOSE_IMAGE.alpha = 0.0
        CLOSE_BUTTON.alpha = 0.0
    }
    
    @IBAction func LIKE(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.LikeView.alpha = 1.0
            self.CLOSE_IMAGE.alpha = 1.0
            self.CLOSE_BUTTON.alpha = 1.0
        })
    }
    
    @IBAction func DISLIKE(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.DisikeView.alpha = 1.0
            self.CLOSE_IMAGE.alpha = 1.0
            self.CLOSE_BUTTON.alpha = 1.0
        })
    }
    
    @objc func CLOSE_FALSE(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func CLOSE_TRUE(_ sender: UIButton) {

        UIViewController.USER_DATA.set(true, forKey: "review")
        UIViewController.USER_DATA.synchronize()

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func APP_STORE_VC(_ sender: UIButton) {
        
        dismiss(animated: true, completion: {
            
            UIViewController.USER_DATA.set(true, forKey: "review")
            UIViewController.USER_DATA.synchronize()
            
            if let STORE_URL = URL(string: "itms-apps://itunes.apple.com/app/id1378854278?action=write-review"), UIApplication.shared.canOpenURL(STORE_URL) {

                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(STORE_URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(STORE_URL)
                }
            }
        })
    }
    
    @IBAction func FEEDBACK_VC(_ sender: UIButton) {
        
        guard let PVC = self.presentingViewController else { return }
        
        dismiss(animated: true, completion: {
        
            UIViewController.USER_DATA.set(true, forKey: "review")
            UIViewController.USER_DATA.synchronize()
            
//            UIApplication.shared.open(URL(string: DATA_URL().SCHOOL_URL+"message/usr_ask.php")!)
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "AS_CALL") as! AS_CALL
            VC.modalTransitionStyle = .crossDissolve
            PVC.present(VC, animated: true, completion: nil)
        })
    }
}
