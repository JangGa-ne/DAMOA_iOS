//
//  VIEW_NOTICE.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/18.
//

import UIKit
import Alamofire
import CoreLocation

//MARK: - 알림창
extension UIViewController {
    
    func VIEW_NOTICE(_ MESSAGE: String) {
        
        // 진동 이벤트
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        let NOTIFICATION = UILabel(frame: CGRect(x: view.frame.size.width/2 - 97.5, y: 0.0, width: 195.0, height: 50.0))
            
        NOTIFICATION.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        NOTIFICATION.textColor = .lightGray
        NOTIFICATION.textAlignment = .center
        NOTIFICATION.font = UIFont.boldSystemFont(ofSize: 12)
        NOTIFICATION.text = MESSAGE
        NOTIFICATION.layer.cornerRadius = 25.0
        NOTIFICATION.clipsToBounds = true
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            
            NOTIFICATION.alpha = 1.0
            if !self.DEVICE_RATIO() {
                NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 20.0)
            } else {
                NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 44.0)
            }
        })
        
        view.addSubview(NOTIFICATION)
            
        UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseOut, animations: {
                
            NOTIFICATION.alpha = 0.0
            NOTIFICATION.transform = CGAffineTransform(translationX: 0, y: 0.0)
        }, completion: {(isCompleted) in
                
            NOTIFICATION.removeFromSuperview()
        })
    }
    
    // Alamofire 에러 알림장
    func ALAMOFIRE_ERROR(ERROR: AFError?) {
        
        switch ERROR {
        case .none:
            break
        case .some(.invalidURL(url: _)):
            self.VIEW_NOTICE("E: 잘못된 URL")
        case .some(.parameterEncodingFailed(reason: _)):
            self.VIEW_NOTICE("E: 매개 변수 인코딩 실패")
        case .some(.multipartEncodingFailed(reason: _)):
            self.VIEW_NOTICE("E: 멀티 파트 인코딩 실패")
        case .some(.responseSerializationFailed(reason: _)):
//            self.VIEW_NOTICE("E: 응답 직렬화 실패")
            break
        case .some(.responseValidationFailed(reason: _)):
            self.VIEW_NOTICE("E: 응답 확인 실패")
        }
    }
    
    func ALERT(TITLE: String?, BODY: String?, STYLE: UIAlertController.Style) {
        
        let ALERT = UIAlertController(title: TITLE, message: BODY, preferredStyle: STYLE)
        present(ALERT, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
}
