//
//  SUBMIT_EVENT.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2021/01/17.
//

import UIKit
import EventKit

class SUBMIT_EVENT: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var SOSIK_LIST: [SOSIK_API] = []
    var SOSIK_POSITION: Int = 0
    
    let DATE_FORMATTER = DateFormatter()
    
    @IBOutlet weak var BG_VIEW: UIView!
    // 날짜
    @IBOutlet weak var DATE: UILabel!
    // 이벤트
    @IBOutlet weak var EVENT: UILabel!
    // 내 캘린더에 새로운 이벤트 추가
    @IBOutlet weak var SUBMIT: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DATE_FORMATTER.locale = Locale(identifier: "ko_kr")
        DATE_FORMATTER.timeZone = TimeZone(identifier: "Asia/Seoul")!
        
        BG_VIEW.layer.cornerRadius = 20.0
        BG_VIEW.clipsToBounds = true
        
        let DATA = SOSIK_LIST[SOSIK_POSITION]
        
        // 날짜
        if !(DATA.DATETIME == "" || DATA.DATETIME == "0000-00-00 00:00:00") {
            
            DATE_FORMATTER.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let DATETIME = DATE_FORMATTER.date(from: DATA.DATETIME)!
            DATE_FORMATTER.dateFormat = "yyyy년 MM월 dd일 E요일"
            let DATETIME_2 = DATE_FORMATTER.string(from: DATETIME)
            DATE.text = DATETIME_2
        } else {
            
            DATE.text = "0000-00-00 00:00:00"
        }
        // 이벤트
        if DATA.SC_NAME == "" {
            EVENT.text = "- \(ENCODE(DATA.SUBJECT))"
        } else {
            EVENT.text = "[ \(DATA.SC_NAME) ]\n- \(ENCODE(DATA.SUBJECT))"
        }
        
        // 내 캘린더에 새로운 이벤트 추가
        SUBMIT.layer.cornerRadius = 5.0
        SUBMIT.clipsToBounds = true
        SUBMIT.addTarget(self, action: #selector(SUBMIT(_:)), for: .touchUpInside)
    }
    
    @objc func SUBMIT(_ sender: UIButton) {
        
        // 진동 이벤트
        UIImpactFeedbackGenerator().impactOccurred()
        
        let ALERT = UIAlertController(title: "내 캘린더에 추가", message: "\'부산교육 다모아\'이(가) \'학사일정\'을(를) 사용자의 캘린더에 추가하려고 합니다", preferredStyle: .alert)
        
        ALERT.addAction(UIAlertAction(title: "추가", style: .default, handler: { (_) in
            
            let EVENT_STORE = EKEventStore()
            EVENT_STORE.requestAccess(to: .event, completion: { (granted, error) in
                
                if (granted) && (error == nil) {
                    
                    let EVENT = EKEvent(eventStore: EVENT_STORE)
                    let DATA = self.SOSIK_LIST[self.SOSIK_POSITION]
                    
                    self.DATE_FORMATTER.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let FORMAT = self.DATE_FORMATTER.date(from: DATA.DATETIME) ?? Date()
                    self.DATE_FORMATTER.dateFormat = "yyyy-MM-dd"
                    let DATETIME = self.DATE_FORMATTER.string(from: FORMAT)
                    self.DATE_FORMATTER.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    EVENT.title = self.ENCODE(DATA.SUBJECT)
                    EVENT.isAllDay = true
                    EVENT.startDate = self.DATE_FORMATTER.date(from: "\(DATETIME) 00:00:00") ?? Date()
                    EVENT.endDate = self.DATE_FORMATTER.date(from: "\(DATETIME) 23:59:59") ?? Date()
                    if DATA.SC_NAME != "" { EVENT.notes = DATA.SC_NAME }
                    
                    EVENT.calendar = EVENT_STORE.defaultCalendarForNewEvents
                    
                    do { try EVENT_STORE.save(EVENT, span: .thisEvent) } catch { }
                }
            })
            
            let ALERT = UIAlertController(title: "추가 되었습니다.", message: nil, preferredStyle: .alert)
            ALERT.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(ALERT, animated: true, completion: nil)
        }))
        ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        present(ALERT, animated: true, completion: nil)
    }
}
