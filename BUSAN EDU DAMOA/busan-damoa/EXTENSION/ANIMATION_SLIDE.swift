//
//  SLIDE_IN_TRANSITION.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/10/19.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit

// 메뉴 에니메이션 설정
class SLIDE_IN_TRANSITION: NSObject, UIViewControllerAnimatedTransitioning {
    
    var X = false
    var Y = false
    var ALPHA = false
    var IS_PRESENTING = false
    let DIMMING_VIEW = UIButton()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let TO_VC = transitionContext.viewController(forKey: .to),
            let FROM_VC = transitionContext.viewController(forKey: .from) else { return }
        
        let CONTAINER_VIEW = transitionContext.containerView
        
        let FINAL_WIDTH = TO_VC.view.bounds.width
        let FINAL_HEIGHT = TO_VC.view.bounds.height
        
        if IS_PRESENTING {
            
            DIMMING_VIEW.backgroundColor = .black
            DIMMING_VIEW.alpha = 0.0
            DIMMING_VIEW.frame = CONTAINER_VIEW.bounds
            CONTAINER_VIEW.addSubview(DIMMING_VIEW)
            
            if X == true { TO_VC.view.frame = CGRect(x: -FINAL_WIDTH, y: 0.0, width: FINAL_WIDTH, height: FINAL_HEIGHT) }
            if Y == true { TO_VC.view.frame = CGRect(x: 0.0, y: FINAL_HEIGHT, width: FINAL_WIDTH, height: FINAL_HEIGHT) }
            if ALPHA == true { TO_VC.view.frame = CGRect(x: 0.0, y: 0.0, width: FINAL_WIDTH, height: FINAL_HEIGHT) }
            CONTAINER_VIEW.addSubview(TO_VC.view)
        }
        
        let DURATION = transitionDuration(using: transitionContext)
        let IS_CANCELLED = transitionContext.transitionWasCancelled
        
        UIView.animate(withDuration: DURATION, animations: {
            
            if self.ALPHA == false {
                
                let TRANSFORM = {
                    self.DIMMING_VIEW.alpha = 0.3
                    if self.X == true { TO_VC.view.transform = CGAffineTransform(translationX: FINAL_WIDTH, y: 0.0) }
                    if self.Y == true { TO_VC.view.transform = CGAffineTransform(translationX: 0.0, y: -FINAL_HEIGHT) }
                }
                let IDENTITY = { self.DIMMING_VIEW.alpha = 0.0; FROM_VC.view.transform = .identity }
                
                self.IS_PRESENTING ? TRANSFORM() : IDENTITY()
            } else {
                
                let TRANSFORM = { self.DIMMING_VIEW.alpha = 0.3; TO_VC.view.alpha = 1.0 }
                let IDENTITY = { self.DIMMING_VIEW.alpha = 0.0; FROM_VC.view.alpha = 0.0 }
                
                self.IS_PRESENTING ? TRANSFORM() : IDENTITY()
            }
        }) { (_) in
            transitionContext.completeTransition(!IS_CANCELLED)
        }
    }
}

extension HOME: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        TRANSITION.ALPHA = true
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        TRANSITION.ALPHA = true
        return TRANSITION
    }
}

//MARK: - 안심알리미
extension SOSIK_SC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        TRANSITION.Y = true
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        TRANSITION.Y = true
        return TRANSITION
    }
}
//MARK: - 안심알리미 조약돌찾기
extension SEARCH_SFSC_B: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        TRANSITION.Y = true
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        TRANSITION.Y = true
        return TRANSITION
    }
}
//MARK: - 학사일정
extension SOSIK_S: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        TRANSITION.Y = true
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        TRANSITION.Y = true
        return TRANSITION
    }
}
//MARK: - 내정보
extension SETTING: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        TRANSITION.Y = true
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        TRANSITION.Y = true
        return TRANSITION
    }
}
