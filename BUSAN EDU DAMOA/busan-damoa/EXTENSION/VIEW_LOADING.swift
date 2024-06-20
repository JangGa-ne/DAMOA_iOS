//
//  VIEW_LOADING.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/31.
//

import UIKit

//MARK: - 데이터 로딩 화면
extension UIViewController {
    
    func ON_VIEW_LOADING(_ VIEW: UIView, _ INDICATOR: UIActivityIndicatorView,_ TEXT: String) {
        
        VIEW.frame = view.bounds
        VIEW.backgroundColor = UIColor.init(white: 0.0, alpha: 0.3)
        
        let PROGRESS = UIVisualEffectView()
        PROGRESS.frame = CGRect(x: VIEW.frame.width / 2 - 120, y: VIEW.frame.height / 2 - 30, width: 240.0, height: 60.0)
        PROGRESS.layer.cornerRadius = 10.0
        PROGRESS.clipsToBounds = true
        PROGRESS.effect = UIBlurEffect(style: .regular)
        if #available(iOS 13.0, *) {
            PROGRESS.backgroundColor = .systemBackground
        } else {
            PROGRESS.backgroundColor = .white
        }
        VIEW.addSubview(PROGRESS)
        
        INDICATOR.frame = CGRect(x: PROGRESS.frame.origin.x + 30, y: PROGRESS.frame.origin.y + 10, width: 40.0, height: 40.0)
        INDICATOR.hidesWhenStopped = true
        INDICATOR.style = .whiteLarge
        INDICATOR.color = .systemBlue
        INDICATOR.startAnimating()
        VIEW.addSubview(INDICATOR)
        
        let MESSAGE = UILabel()
        MESSAGE.frame = CGRect(x: PROGRESS.frame.origin.x + 80, y: PROGRESS.frame.origin.y + 20, width: 130.0, height: 20.0)
        MESSAGE.font = UIFont(name: "YiSunShinDotumM", size: 16.0)
        MESSAGE.text = TEXT
        VIEW.addSubview(MESSAGE)
        
        UIView.animate(withDuration: 0.3, animations: { VIEW.alpha = 1.0 })
        view.addSubview(VIEW)
    }
    
    func OFF_VIEW_LOADING(_ VIEW: UIView, _ INDICATOR: UIActivityIndicatorView) {
        
        INDICATOR.stopAnimating()
        
        UIView.animate(withDuration: 0.3, animations: {
            VIEW.alpha = 0.0
        }, completion: { (_) in
            VIEW.removeFromSuperview()
        })
    }
}
