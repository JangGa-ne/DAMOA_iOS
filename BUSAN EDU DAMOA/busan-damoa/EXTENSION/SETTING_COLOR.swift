//
//  SETTING_COLOR.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/17.
//

import UIKit

//MARK: - 커스텀 색상
extension UIColor {
    
    static var YELLOW_FFAC0F = UIColor(red: 255/255, green: 172/255, blue: 15/255, alpha: 1.0)
    static var GRAY_F1F1F1 = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
    
    func RANDOM_COLOR() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 0.5)
    }
    
    static var FLAT_COLOR = [
        UIColor().COLOR_CODE(CODE: 0x1ABC9C, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0x2ECC71, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0x3498DB, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0x9B59B6, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0x34495E, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0xF1C40F, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0xE67E22, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0xE74C3C, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0x95A5A6, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0x16A085, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0x27AE60, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0x2980B9, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0x8E44AD, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0x2C3E50, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0xF39C12, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0xD35400, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0xC0392B, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0xBDC3C7, ALPHA: 1.0),
        UIColor().COLOR_CODE(CODE: 0x7F8C8D, ALPHA: 1.0),
    ]
    
    func COLOR_CODE(CODE: Int, ALPHA: CGFloat) -> UIColor {
        
        let RED = CGFloat(((CODE & 0xFF0000) >> 16)) / 255
        let GREEN = CGFloat(((CODE & 0xFF00) >> 8)) / 255
        let BLUE = CGFloat((CODE & 0xFF)) / 255

        return UIColor(red: RED, green: GREEN, blue: BLUE, alpha: ALPHA)
    }
}
