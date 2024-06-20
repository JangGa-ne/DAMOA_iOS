//
//  SETTING_CALENDAR.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2021/01/15.
//

import UIKit
import CVCalendar

extension SOSIK_S: CVCalendarViewDelegate, CVCalendarViewAppearanceDelegate, CVCalendarMenuViewDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CURRENT_CALENDAR = Calendar(identifier: .gregorian)
        CURRENT_CALENDAR?.locale = Locale(identifier: "ko_kr")
        CURRENT_CALENDAR?.timeZone = TimeZone(identifier: "Asia/Seoul")!
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        CALENDARVIEW.commitCalendarViewUpdate()
    }
    
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    func calendar() -> Calendar? {
        return CURRENT_CALENDAR
    }
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        
        var MARKER: Bool?
        
        for DATA in SOSIK_LIST {
            
            DATE_FORMATTER.locale = Locale(identifier: "ko_kr")
            DATE_FORMATTER.dateFormat = "yyyy-MM-dd HH:mm:ss"
            DATE_FORMATTER.timeZone = TimeZone(identifier: "Asia/Seoul")
            let DATE_TIME = DATE_FORMATTER.date(from: DATA.DATETIME)!
            
            let YEAR = DateFormatter(); YEAR.dateFormat = "yyyy"
            let MONTH = DateFormatter(); MONTH.dateFormat = "MM"
            let DAY = DateFormatter(); DAY.dateFormat = "dd"
            
            if !dayView.isHidden && dayView.date != nil {
                
                if (dayView.date.year == Int(YEAR.string(from: DATE_TIME))) && (dayView.date.month == Int(MONTH.string(from: DATE_TIME))) && (dayView.date.day == Int(DAY.string(from: DATE_TIME))) {
                    MARKER = true
                    return MARKER ?? true
                }
            }
        }
        
        return MARKER ?? false
    }
    
    // Dot 크기
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 15.0
    }
    // Dot 색상
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [.systemBlue]
    }
    // Dot 위치
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
        return 15.0
    }
    // Dot 이동
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool {
        return false
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        
        if MONTH.text != date.globalDescription && ANIMATION_FINISHED {
            // 년.월
            MONTH.text = date.globalDescription
            let MONTH = date.globalDescription.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "")
            // 네트워크 연결 확인
            NETWORK_CHECK(MONTH: MONTH)
        }
    }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return weekday == .sunday ? UIColor.systemRed : UIColor.systemRed
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        
        // 데이터 삭제
        CD_DATETIME.removeAll()
        CD_SC_NAME.removeAll()
        CD_POSITION.removeAll()
        CD_SUBJECT.removeAll()
        CD_SHOW_DATA.removeAll()
        
        for i in 0 ..< SOSIK_LIST.count {
            
            let DATA = SOSIK_LIST[i]
            
            DATE_FORMATTER.dateFormat = "yyyy-MM-dd"
            let UPDATE_DATE = DATE_FORMATTER.string(from: dayView.date.convertedDate()!)
            let SERVER_DATE = DATA.DATETIME
            
            let RANGE = SERVER_DATE.startIndex ..< SERVER_DATE.index(SERVER_DATE.startIndex, offsetBy: 10)
            
            // 데이터 추가
            if UPDATE_DATE == SERVER_DATE[RANGE] {
                CD_DATETIME.append(SERVER_DATE)
                CD_SC_NAME.append(DATA.SC_NAME)
                CD_SUBJECT.append(DATA.SUBJECT)
                CD_POSITION.append(i)
                CD_SHOW_DATA.append(false)
            } else {
                CD_SHOW_DATA.append(true)
            }
        }
        
        TABLEVIEW.reloadData()
    }
}

