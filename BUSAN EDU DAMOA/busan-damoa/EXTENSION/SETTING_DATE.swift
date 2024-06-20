//
//  SETTING_DATE.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/28.
//

import UIKit

//MARK: - 날짜 포멧 설정
extension UIViewController {
    
    //MARK: - 날짜
    func FORMAT_DATETIME(_ DATETIME: String) -> String {
        
        let DATE_FORMATTER = DateFormatter()
        
        if DATETIME == "0000-00-00 00:00:00" || DATETIME == "" {
            return "-"
        } else {
            
            DATE_FORMATTER.locale = Locale(identifier: "ko_kr")
            DATE_FORMATTER.dateFormat = "yyyy-MM-dd HH:mm:ss"
            DATE_FORMATTER.timeZone = TimeZone.init(identifier: "Asia/Seoul")
            let DATE: Date = DATE_FORMATTER.date(from: DATETIME)!
            
            DATE_FORMATTER.dateFormat = "MM월dd일"
            return DATE_FORMATTER.string(from: DATE)
        }
    }
    
    //MARK: - 요일
    func FORMAT_DAY(_ DATETIME: String) -> String {
        
        let DATE_FORMATTER = DateFormatter()
        
        if DATETIME == "0000-00-00 00:00:00" || DATETIME == "" {
            return "-"
        } else {
            
            DATE_FORMATTER.locale = Locale(identifier: "ko_kr")
            DATE_FORMATTER.dateFormat = "yyyy-MM-dd HH:mm:ss"
            DATE_FORMATTER.timeZone = TimeZone.init(identifier: "Asia/Seoul")
            let DATE: Date = DATE_FORMATTER.date(from: DATETIME)!
            
            DATE_FORMATTER.dateFormat = "E"
            return DATE_FORMATTER.string(from: DATE)
        }
    }
}
