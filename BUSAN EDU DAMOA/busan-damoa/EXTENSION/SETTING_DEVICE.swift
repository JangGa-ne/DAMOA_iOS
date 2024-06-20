//
//  SETTING_DEVICE.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2021/01/20.
//

import UIKit

//MARK: - 디바이스 사이즈 설정
extension UIViewController {
    
    func DEVICE_RATIO() -> Bool {
        
        switch UIDevice.current.model {
        case "iPhone":
            if APPLE_DEVICE() == "Ratio 18:9" { return true } else { return false }
        default:
            print("\(UIDevice.current.model) 지원하지 않음")
            return false
        }
    }
    
    func GET_DEVICE_IDENTIFIER() -> String {
        
        var SYSTEM_INFO = utsname()
        uname(&SYSTEM_INFO)
        let MACHINE_MIRROR = Mirror(reflecting: SYSTEM_INFO.machine)
        let IDENTIFIER = MACHINE_MIRROR.children.reduce("") { identifier, element in
            guard let VALUE = element.value as? Int8, VALUE != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(VALUE)))
        }
        
        return IDENTIFIER
    }
    
    func APPLE_DEVICE() -> String {
        
        switch GET_DEVICE_IDENTIFIER() {
        
        //MARK: - iPhone
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "Ratio 16:9"         // iPhone 4
        case "iPhone4,1":                               return "Ratio 16:9"         // iPhone 4s
        case "iPhone5,1", "iPhone5,2":                  return "Ratio 16:9"         // iPhone 5
        case "iPhone5,3", "iPhone5,4":                  return "Ratio 16:9"         // iPhone 5c
        case "iPhone6,1", "iPhone6,2":                  return "Ratio 16:9"         // iPhone 5s
        case "iPhone7,2":                               return "Ratio 16:9"         // iPhone 6
        case "iPhone7,1":                               return "Ratio 16:9"         // iPhone 6 Plus
        case "iPhone8,1":                               return "Ratio 16:9"         // iPhone 6s
        case "iPhone8,2":                               return "Ratio 16:9"         // iPhone 6s Plus
        case "iPhone8,4":                               return "Ratio 16:9"         // iPhone SE
        case "iPhone9,1", "iPhone9,3":                  return "Ratio 16:9"         // iPhone 7
        case "iPhone9,2", "iPhone9,4":                  return "Ratio 16:9"         // iPhone 7 Plus
        case "iPhone10,1", "iPhone10,4":                return "Ratio 16:9"         // iPhone 8
        case "iPhone10,2", "iPhone10,5":                return "Ratio 16:9"         // iPhone 8 Plus
        
        case "iPhone10,3", "iPhone10,6":                return "Ratio 18:9"         // iPhone X
        case "iPhone11,2":                              return "Ratio 18:9"         // iPhone XS
        case "iPhone11,4", "iPhone11,6":                return "Ratio 18:9"         // iPhone XS Max
        case "iPhone11,8":                              return "Ratio 18:9"         // iPhone XR
        case "iPhone12,1":                              return "Ratio 18:9"         // iPhone 11
        case "iPhone12,3":                              return "Ratio 18:9"         // iPhone 11 Pro
        case "iPhone12,5":                              return "Ratio 18:9"         // iPhone 11 Pro Max
        
        case "iPhone12,8":                              return "Ratio 16:9"         // iPhone SE (2G)
        
        case "iPhone13,1":                              return "Ratio 18:9"         // iPhone 12 Mini
        case "iPhone13,2":                              return "Ratio 18:9"         // iPhone 12
        case "iPhone13,3":                              return "Ratio 18:9"         // iPhone 12 Pro
        case "iPhone13,4":                              return "Ratio 18:9"         // iPhone 12 Pro Max
            
        //MARK: - iPad
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "Ratio 18:9"         // iPad Pro (11-inch) (1G)
        case "iPad8,9", "iPad8,10":                     return "Ratio 18:9"         // iPad Pro (11-inch) (2G)
        case "iPad6,7", "iPad6,8":                      return "Ratio 18:9"         // iPad Pro (12.9-inch) (1G)
        case "iPad7,1", "iPad7,2":                      return "Ratio 18:9"         // iPad Pro (12.9-inch) (2G)
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "Ratio 18:9"         // iPad Pro (12.9-inch) (3G)
        case "iPad8,11", "iPad8,12":                    return "Ratio 18:9"         // iPad Pro (12.9-inch) (4G)
        
        case "iPad13,1", "iPad13,2":                    return "Ratio 18:9"         // iPad Air (10.9-inch) (4G)
            
        default: return "Ratio 16:9" }
    }
}
