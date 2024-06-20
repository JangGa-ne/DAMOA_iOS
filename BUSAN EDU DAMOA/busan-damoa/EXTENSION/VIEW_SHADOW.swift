//
//  VIEW_SHADOW.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/16.
//

import UIKit

//MARK: - 그림자
extension UIView {
    
    public func VIEW_SHADOW(COLOR: UIColor, OFFSET: CGSize, SD_RADIUS: CGFloat, OPACITY: Float, RADIUS: CGFloat) {
        
        layer.shadowColor = COLOR.cgColor
        layer.shadowOffset = OFFSET
        layer.shadowOpacity = OPACITY
        layer.shadowRadius = SD_RADIUS
        layer.cornerRadius = RADIUS
    }
}
