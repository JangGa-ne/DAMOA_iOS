//
//  HOME.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/05/07.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class HOME_TC: UITableViewCell {
    
    @IBOutlet weak var CONTENT: UILabel!
}

class HOME: UIViewController, HOME_PROTOCOL {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // 교육청홈페이지
    @IBAction func Homepage(_ sender: UIButton) { UIApplication.shared.open(URL(string: "http://pen.go.kr")!) }
    
    // 메뉴
    @IBOutlet weak var Menu_open: UIButton!
    @IBAction func Menu_open(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.Menu_close.alpha = 0.3
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.Navi_BG.transform = CGAffineTransform(translationX: 0, y: 0)
            self.Navi_view.transform = CGAffineTransform(translationX: 0, y: 0)
            self.Navi_menu.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    @IBOutlet weak var Navi_Title: UIImageView!
    
    @IBOutlet weak var Navi_BG: UIView!
    @IBOutlet weak var Navi_view: UIView!
    @IBOutlet weak var Navi_menu: UIView!
    @IBOutlet weak var Menu_close: UIButton!
    @IBAction func Menu_close(_ sender: UIButton) { MENU_CLOSE() }
    @IBOutlet weak var TableView: UITableView!
    
    func MENU_CLOSE() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.Menu_close.alpha = 0.0
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.Navi_BG.transform = CGAffineTransform(translationX: -180, y: 0)
            self.Navi_view.transform = CGAffineTransform(translationX: -180, y: 0)
            self.Navi_menu.transform = CGAffineTransform(translationX: -180, y: 0)
        })
    }
    
    var SOSIK_LIST: [SOSIK_API] = []
    
    @IBOutlet weak var NOTICE_VC: UIButton!                 // 공지사항
    @IBOutlet weak var HOME_COMMUNICATION_VC: UIButton!     // 가정통신문
    @IBOutlet weak var CLASS_ANNOUNCENENTS_VC: UIButton!    // 학급알림장
    @IBOutlet weak var LUNCH_VC: UIButton!                  // 오늘의식단
    @IBOutlet weak var PARENT_TRAINING_VC: UIButton!        // 학부모연수
    @IBOutlet weak var PARENT_TIP_VC: UIButton!             // 진로도움방
    @IBOutlet weak var CHILD_SAFETY_VC: UIButton!           // 자녀안심+
    @IBOutlet weak var ACADEMIC_SCHEDULE_VC: UIButton!      // 학사일정
    @IBOutlet weak var SCHOOL_NEWS_VC: UIButton!            // 학교뉴스
    @IBOutlet weak var EDU_NEWS_VC: UIButton!               // 교육뉴스
    @IBOutlet weak var EDU_EVENT_VC: UIButton!              // 행사체험
    @IBOutlet weak var POLL_VC: UIButton!                   // 설문조사
    
    @IBOutlet weak var SOSIK_REVIEW_1: UIButton!
    @IBOutlet weak var SOSIK_REVIEW_2: UIButton!
    @IBOutlet weak var SOSIK_REVIEW_3: UIButton!
    
    let TRANSITION = SLIDE_IN_TRANSITION()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.APPDELEGATE.MAIN_VC = self
        
        Navi_BG.transform = CGAffineTransform(translationX: -180, y: 0)
        Navi_view.transform = CGAffineTransform(translationX: -180, y: 0)
        Navi_menu.transform = CGAffineTransform(translationX: -180, y: 0)
        Menu_close.alpha = 0.0
        
        TableView.delegate = self
        TableView.dataSource = self
        TableView.separatorStyle = .none

        UIView.animate(withDuration: 0.5, delay: 2.0, animations: { self.CHECK_VERSION(self.Navi_Title) })
        
        MENU_CLICK()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let TAB_BAR_TITLE2: [String] = ["학부모연수", "진로도움방", "자녀안심+", "학사일정"]
        let TAB_BAR_IMAGE2: [String] = ["MENU_5.png", "MENU_6.png", "MENU_7.png", "MENU_8.png"]

        let TBC2 = self.storyboard?.instantiateViewController(withIdentifier: "SECTION_2") as! SECTION_2
        
        for i in 0 ..< 4 {
            TBC2.tabBar.items?[i].title = TAB_BAR_TITLE2[i]
            TBC2.tabBar.items?[i].image = UIImage(named: TAB_BAR_IMAGE2[i])
        }
        
        if UIViewController.APPDELEGATE.T_CHECK {
            
            TBC2.modalTransitionStyle = .crossDissolve
            TBC2.selectedIndex = 0

            present(TBC2, animated: true)
        }
        if UIViewController.APPDELEGATE.SC_CHECK {
            
            TBC2.modalTransitionStyle = .crossDissolve
            TBC2.selectedIndex = 2

            present(TBC2, animated: true)
        }
        
        let TAB_BAR_TITLE3: [String] = ["학교뉴스", "교육뉴스", "행사체험", "설문조사"]
        let TAB_BAR_IMAGE3: [String] = ["MENU_9.png", "MENU_10.png", "MENU_11.png", "MENU_12.png"]

        let TBC3 = self.storyboard?.instantiateViewController(withIdentifier: "SECTION_3") as! SECTION_3
        
        for i in 0 ..< 4 {
            TBC3.tabBar.items?[i].title = TAB_BAR_TITLE3[i]
            TBC3.tabBar.items?[i].image = UIImage(named: TAB_BAR_IMAGE3[i])
        }
        
        if UIViewController.APPDELEGATE.CS_CHECK {
        
            TBC3.modalTransitionStyle = .crossDissolve
            TBC3.selectedIndex = 2

            present(TBC3, animated: true)
        }
        if UIViewController.APPDELEGATE.SV_CHECK {
        
            TBC3.modalTransitionStyle = .crossDissolve
            TBC3.selectedIndex = 3

            present(TBC3, animated: true)
        }
        
        // 환경설정 업데이트
        if UIViewController.APPDELEGATE.PF_UPDATE { VIEWCONTROLLER_VC(IDENTIFIER: "SETTING") }
    }
    
    // SNS연결
    @IBAction func Instagram(_ sender: UIButton) { UIApplication.shared.open(URL(string: "https://www.instagram.com/with__pen")!) }
    @IBAction func Facebook(_ sender: UIButton) { UIApplication.shared.open(URL(string: "https://www.facebook.com/withpen")!) }
    @IBAction func Twitter(_ sender: UIButton) { UIApplication.shared.open(URL(string: "https://twitter.com/with_pen")!) }
    @IBAction func Youtube(_ sender: UIButton) { UIApplication.shared.open(URL(string: "https://www.youtube.com/channel/UCI7OwvW0AJSXW92AcJoBhPw")!) }
    @IBAction func Kakaostory(_ sender: UIButton) { UIApplication.shared.open(URL(string: "https://story.kakao.com/ch/withpen")!) }
    @IBAction func Naverblog(_ sender: UIButton) { UIApplication.shared.open(URL(string: "https://blog.naver.com/with_pen")!) }
    
    @IBAction func SETTING_VC(_ sender: UIButton) { VIEWCONTROLLER_VC(IDENTIFIER: "SETTING") }
    
    var SECTIONS = [
        MENU_SECTION(TITLE: "앱 이용안내", CONTENT: [], EXPANDED: false),
        MENU_SECTION(TITLE: "앱 추천하기", CONTENT: [], EXPANDED: false),
        MENU_SECTION(TITLE: "교육기관 정보", CONTENT: ["- 주변 학교찾기", "- 학교안내", "- 교육기관 안내"], EXPANDED: false),
        MENU_SECTION(TITLE: "교육청 알림", CONTENT: [], EXPANDED: false),
        MENU_SECTION(TITLE: "우리학교 알림장", CONTENT: ["- 공지사항", "- 가정통신문", "- 학급알림장", "- 오늘의식단"], EXPANDED: false),
        MENU_SECTION(TITLE: "학부모 참여방", CONTENT: ["- 학부모연수", "- 진로도움방", "- 자녀안심+", "- 학사일정"], EXPANDED: false),
        MENU_SECTION(TITLE: "부산교육 소식", CONTENT: ["- 학교뉴스", "- 교육뉴스", "- 행사체험", "- 설문조사"], EXPANDED: false),
        MENU_SECTION(TITLE: "소식 보관함", CONTENT: [], EXPANDED: false),
        MENU_SECTION(TITLE: "환경설정", CONTENT: [], EXPANDED: false)
    ]
}

extension HOME: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SECTIONS.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SECTIONS[section].CONTENT.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let HEADER = HeaderView()
        HEADER.CUSTOM_INIT(TITLE: SECTIONS[section].TITLE, SECTION: section, PROTOCOL: self)
        return HEADER
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let CELL = tableView.dequeueReusableCell(withIdentifier: "HOME_TC", for: indexPath) as! HOME_TC
        CELL.CONTENT.text = SECTIONS[indexPath.section].CONTENT[indexPath.item]
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var IDENTIFIER: String = ""
        var SECTION: Int = 0
        var POSITION: Int = 0
        
        if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 주변 학교찾기" {
            IDENTIFIER = "SEARCH_SCHOOL"
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 학교안내" {
            IDENTIFIER = "EDU_OFFICE_INFO"; UIViewController.APPDELEGATE.SCHOOL_OR_OFFICE = "SCHOOL"
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 교육기관 안내" {
            IDENTIFIER = "EDU_OFFICE_INFO"; UIViewController.APPDELEGATE.SCHOOL_OR_OFFICE = "OFFICE"
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 공지사항" {
            IDENTIFIER = "SOSIK_N"; SECTION = 1; POSITION = 0
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 가정통신문" {
            IDENTIFIER = "SOSIK_M"; SECTION = 1; POSITION = 1
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 학급알림장" {
            IDENTIFIER = "SOSIK_C"; SECTION = 1; POSITION = 2
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 오늘의식단" {
            IDENTIFIER = "SOSIK_F"; SECTION = 1; POSITION = 3
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 학부모연수" {
            IDENTIFIER = "SOSIK_T"; SECTION = 2; POSITION = 0
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 진로도움방" {
            IDENTIFIER = "SOSIK_ET"; SECTION = 2; POSITION = 1
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 자녀안심+" {
            IDENTIFIER = "SOSIK_SC"; SECTION = 2; POSITION = 2
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 학사일정" {
            IDENTIFIER = "SOSIK_S"; SECTION = 2; POSITION = 3
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 학교뉴스" {
            IDENTIFIER = "SOSIK_NS"; SECTION = 3; POSITION = 0
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 교육뉴스" {
            IDENTIFIER = "SOSIK_EN"; SECTION = 3; POSITION = 1
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 행사체험" {
            IDENTIFIER = "SOSIK_CS"; SECTION = 3; POSITION = 2
        } else if SECTIONS[indexPath.section].CONTENT[indexPath.item] == "- 설문조사" {
            IDENTIFIER = "SOSIK_SV"; SECTION = 3; POSITION = 3
        }
        
        if SECTION == 0 {
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: IDENTIFIER)
            VC!.modalTransitionStyle = .crossDissolve
            present(VC!, animated: true)
        } else {
            
            let TAB_BAR_TITLE_1: [String] = ["공지사항", "가정통신문", "학급알림장", "오늘의식단"]
            let TAB_BAR_IMAGE_1: [String] = ["MENU_1.png", "MENU_2.png", "MENU_3.png", "MENU_4.png"]
            let TAB_BAR_TITLE_2: [String] = ["학부모연수", "진로도움방", "자녀안심+", "학사일정"]
            let TAB_BAR_IMAGE_2: [String] = ["MENU_5.png", "MENU_6.png", "MENU_7.png", "MENU_8.png"]
            let TAB_BAR_TITLE_3: [String] = ["학교뉴스", "교육뉴스", "행사체험", "설문조사"]
            let TAB_BAR_IMAGE_3: [String] = ["MENU_9.png", "MENU_10.png", "MENU_11.png", "MENU_12.png"]
            
            let TBC = self.storyboard?.instantiateViewController(withIdentifier: "SECTION_\(SECTION)") as! UITabBarController
            TBC.modalTransitionStyle = .crossDissolve
            TBC.selectedIndex = POSITION
            TBC.tabBar.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 0.0, height: -10.0), SD_RADIUS: 10.0, OPACITY: 0.1, RADIUS: 0.0)
            for i in 0 ..< 4 {
                if SECTION == 1 {
                    TBC.tabBar.items?[i].title = TAB_BAR_TITLE_1[i]
                    TBC.tabBar.items?[i].image = UIImage(named: TAB_BAR_IMAGE_1[i])
                } else if SECTION == 2 {
                    TBC.tabBar.items?[i].title = TAB_BAR_TITLE_2[i]
                    TBC.tabBar.items?[i].image = UIImage(named: TAB_BAR_IMAGE_2[i])
                } else if SECTION == 3 {
                    TBC.tabBar.items?[i].title = TAB_BAR_TITLE_3[i]
                    TBC.tabBar.items?[i].image = UIImage(named: TAB_BAR_IMAGE_3[i])
                }
            }
            present(TBC, animated: true)
        }
        
        MENU_CLOSE()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if SECTIONS[indexPath.section].EXPANDED { return 44 } else { return 0 }
    }
    
    func TOGGLE_SECTION(HEADER: HeaderView, SECTION: Int) {
        
        SECTIONS[SECTION].EXPANDED = !SECTIONS[SECTION].EXPANDED
        TableView.beginUpdates()
        for i in 0 ..< SECTIONS[SECTION].CONTENT.count {
            TableView.reloadRows(at: [IndexPath(row: i, section: SECTION)], with: .automatic)
        }
        // SECTION_SELECT
        if SECTIONS[SECTION].TITLE == "앱 이용안내" {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "MENUAL") as! MENUAL
            VC.modalTransitionStyle = .crossDissolve
            present(VC, animated: true, completion: nil)
            MENU_CLOSE()
        } else if SECTIONS[SECTION].TITLE == "앱 추천하기" {
            let TEXT_SHARE = ["[ 부산교육다모아 ]\n\niOS 앱스토어\n- https://apps.apple.com/kr/app/부산교육-다모아/id1378854278\n\n안드로이드 Play스토어\n- https://play.google.com/store/apps/details?id=com.busan.damoa"]
            let ACTIVITY = UIActivityViewController(activityItems: TEXT_SHARE, applicationActivities: nil)
            ACTIVITY.popoverPresentationController?.sourceView = self.view
            present(ACTIVITY, animated: true, completion: nil)
            MENU_CLOSE()
        } else if SECTIONS[SECTION].TITLE == "교육청 알림" {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SOSIK_A") as! SOSIK_A
            VC.modalTransitionStyle = .crossDissolve
            present(VC, animated: true, completion: nil)
            MENU_CLOSE()
        } else if SECTIONS[SECTION].TITLE == "소식 보관함" {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "SOSIK_SCRAP") as! SOSIK_SCRAP
            VC.modalTransitionStyle = .crossDissolve
            present(VC, animated: true, completion: nil)
            MENU_CLOSE()
        } else if SECTIONS[SECTION].TITLE == "환경설정" {
            VIEWCONTROLLER_VC(IDENTIFIER: "SETTING")
            MENU_CLOSE()
        }
        TableView.endUpdates()
    }
}

extension HOME {
    
    // 메뉴
    func MENU_CLICK() {
        
        // SECTION_1
        NOTICE_VC.tag = 0
        HOME_COMMUNICATION_VC.tag = 1
        CLASS_ANNOUNCENENTS_VC.tag = 2
        LUNCH_VC.tag = 3
        
        NOTICE_VC.addTarget(self, action: #selector(MENU_VC_1(_:)), for: .touchUpInside)
        HOME_COMMUNICATION_VC.addTarget(self, action: #selector(MENU_VC_1(_:)), for: .touchUpInside)
        CLASS_ANNOUNCENENTS_VC.addTarget(self, action: #selector(MENU_VC_1(_:)), for: .touchUpInside)
        LUNCH_VC.addTarget(self, action: #selector(MENU_VC_1(_:)), for: .touchUpInside)
        
        // SECTION_2
        PARENT_TRAINING_VC.tag = 0
        PARENT_TIP_VC.tag = 1
        CHILD_SAFETY_VC.tag = 2
        ACADEMIC_SCHEDULE_VC.tag = 3
        
        PARENT_TRAINING_VC.addTarget(self, action: #selector(MENU_VC_2(_:)), for: .touchUpInside)
        PARENT_TIP_VC.addTarget(self, action: #selector(MENU_VC_2(_:)), for: .touchUpInside)
        CHILD_SAFETY_VC.addTarget(self, action: #selector(MENU_VC_2(_:)), for: .touchUpInside)
        ACADEMIC_SCHEDULE_VC.addTarget(self, action: #selector(MENU_VC_2(_:)), for: .touchUpInside)
        
        // SECTION_3
        SCHOOL_NEWS_VC.tag = 0
        EDU_NEWS_VC.tag = 1
        EDU_EVENT_VC.tag = 2
        POLL_VC.tag = 3
        
        SCHOOL_NEWS_VC.addTarget(self, action: #selector(MENU_VC_3(_:)), for: .touchUpInside)
        EDU_NEWS_VC.addTarget(self, action: #selector(MENU_VC_3(_:)), for: .touchUpInside)
        EDU_EVENT_VC.addTarget(self, action: #selector(MENU_VC_3(_:)), for: .touchUpInside)
        POLL_VC.addTarget(self, action: #selector(MENU_VC_3(_:)), for: .touchUpInside)
    }
    
    @objc func MENU_VC_1(_ sender: UIButton) {
        
        let TAB_BAR_TITLE: [String] = ["공지사항", "가정통신문", "학급알림장", "오늘의식단"]
        let TAB_BAR_IMAGE: [String] = ["MENU_1.png", "MENU_2.png", "MENU_3.png", "MENU_4.png"]
        
        let TBC = self.storyboard?.instantiateViewController(withIdentifier: "SECTION_1") as! SECTION_1
        
        TBC.modalTransitionStyle = .crossDissolve
        TBC.selectedIndex = sender.tag
        TBC.tabBar.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 0.0, height: -10.0), SD_RADIUS: 10.0, OPACITY: 0.1, RADIUS: 0.0)
               
        for i in 0 ..< 4 {
            TBC.tabBar.items?[i].title = TAB_BAR_TITLE[i]
            TBC.tabBar.items?[i].image = UIImage(named: TAB_BAR_IMAGE[i])
        }
    
        present(TBC, animated: true)
    }
    
    @objc func MENU_VC_2(_ sender: UIButton) {
        
        let TAB_BAR_TITLE: [String] = ["학부모연수", "진로도움방", "자녀안심+", "학사일정"]
        let TAB_BAR_IMAGE: [String] = ["MENU_5.png", "MENU_6.png", "MENU_7.png", "MENU_8.png"]
        
        let TBC = self.storyboard?.instantiateViewController(withIdentifier: "SECTION_2") as! SECTION_2
        
        TBC.modalTransitionStyle = .crossDissolve
        TBC.selectedIndex = sender.tag
        TBC.tabBar.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 0.0, height: -10.0), SD_RADIUS: 10.0, OPACITY: 0.1, RADIUS: 0.0)
        
        for i in 0 ..< 4 {
            TBC.tabBar.items?[i].title = TAB_BAR_TITLE[i]
            TBC.tabBar.items?[i].image = UIImage(named: TAB_BAR_IMAGE[i])
        }
        
        present(TBC, animated: true)
    }
    
    @objc func MENU_VC_3(_ sender: UIButton) {
        
        let TAB_BAR_TITLE: [String] = ["학교뉴스", "교육뉴스", "행사체험", "설문조사"]
        let TAB_BAR_IMAGE: [String] = ["MENU_9.png", "MENU_10.png", "MENU_11.png", "MENU_12.png"]
        
        let TBC = self.storyboard?.instantiateViewController(withIdentifier: "SECTION_3") as! SECTION_3
        
        TBC.modalTransitionStyle = .crossDissolve
        TBC.selectedIndex = sender.tag
        TBC.tabBar.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 0.0, height: -10.0), SD_RADIUS: 10.0, OPACITY: 0.1, RADIUS: 0.0)
               
        for i in 0 ..< 4 {
            TBC.tabBar.items?[i].title = TAB_BAR_TITLE[i]
            TBC.tabBar.items?[i].image = UIImage(named: TAB_BAR_IMAGE[i])
        }
        
        present(TBC, animated: true)
    }
    
    func NOTICE_REVIEW() {
        
        SOSIK_LIST.removeAll()
        SOSIK_LIST = UIViewController.APPDELEGATE.PREVIEW_LIST
        
        // DB 확인
        SCRAP_CHECK(BOARD_TYPE: "MAIN")
        
        SOSIK_REVIEW_1.tag = 0
        SOSIK_REVIEW_2.tag = 1
        SOSIK_REVIEW_3.tag = 2
        
        if SOSIK_LIST.count != 0 {
            
            if SOSIK_LIST.count >= 1 {
                if SOSIK_LIST[0].SUBJECT != "" {
                    SOSIK_REVIEW_1.setTitle("- \(ENCODE(SOSIK_LIST[0].SUBJECT))", for: .normal)
                    SOSIK_REVIEW_1.addTarget(self, action: #selector(SOSIK_REVIEW(_:)), for: .touchUpInside)
                }
            }
            if SOSIK_LIST.count >= 2 {
                if SOSIK_LIST[1].SUBJECT != "" {
                    SOSIK_REVIEW_2.setTitle("- \(ENCODE(SOSIK_LIST[1].SUBJECT))", for: .normal)
                    SOSIK_REVIEW_2.addTarget(self, action: #selector(SOSIK_REVIEW(_:)), for: .touchUpInside)
                }
            }
            if SOSIK_LIST.count == 3 {
                if SOSIK_LIST[2].SUBJECT != "" {
                    SOSIK_REVIEW_3.setTitle("- \(ENCODE(SOSIK_LIST[2].SUBJECT))", for: .normal)
                    SOSIK_REVIEW_3.addTarget(self, action: #selector(SOSIK_REVIEW(_:)), for: .touchUpInside)
                }
            }
        }
    }
    
    // 공지사항(미리보기)
    @objc func SOSIK_REVIEW(_ sender: UIButton) {
        
        if SOSIK_LIST.count != 0 {
        
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "DETAIL_SOSIK") as! DETAIL_SOSIK
            VC.modalTransitionStyle = .crossDissolve
            VC.PUSH = false
            VC.SOSIK_LIST = SOSIK_LIST
            VC.SOSIK_POSITION = sender.tag
            present(VC, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        REVIEW_CHECK()
        PUSH_VIEW()
        NOTICE_REVIEW()
    }
    
    func REVIEW_CHECK() {
        
        DispatchQueue.main.async {
            
            let RANDOM = Int.random(in: 1...100)
            let REVIEW = UIViewController.USER_DATA.bool(forKey: "review")
            
            print("랜덤 - \(RANDOM) | 별점 - \(REVIEW)")
            
            if (RANDOM == 20) && (REVIEW == false) {
           
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "REVIEW") as! REVIEW
                VC.modalPresentationStyle = .overCurrentContext
                VC.transitioningDelegate = self
                self.present(VC, animated: true, completion: nil)
            }
        }
    }
    
    func PUSH_VIEW() {
        
        let SQL_EDIT: String = "SELECT * FROM PSBG_DB"
        
        let PSBG_DB = UIViewController.APPDELEGATE.PSBG_DB
        let APPDELEGATE = UIViewController.APPDELEGATE
        
        // QUERY 준비
        if sqlite3_prepare(PSBG_DB.DB, SQL_EDIT, -1, &PSBG_DB.STMT, nil) != SQLITE_OK {
            
            let ERROR_MESSAGE = String(cString: sqlite3_errmsg(PSBG_DB.DB)!)
            print("[PUSH] ERROR PREPARING SELECT: \(ERROR_MESSAGE)")
            return
        }
        
        while sqlite3_step(PSBG_DB.STMT) == SQLITE_ROW {
            
            APPDELEGATE.PUSH_N = Bool(String(cString: sqlite3_column_text(PSBG_DB.STMT, 0))) ?? false
            APPDELEGATE.PUSH_M = Bool(String(cString: sqlite3_column_text(PSBG_DB.STMT, 1))) ?? false
            APPDELEGATE.PUSH_C = Bool(String(cString: sqlite3_column_text(PSBG_DB.STMT, 2))) ?? false
            APPDELEGATE.PUSH_F = Bool(String(cString: sqlite3_column_text(PSBG_DB.STMT, 3))) ?? false
            APPDELEGATE.PUSH_T = Bool(String(cString: sqlite3_column_text(PSBG_DB.STMT, 4))) ?? false
            APPDELEGATE.PUSH_ET = Bool(String(cString: sqlite3_column_text(PSBG_DB.STMT, 5))) ?? false
            APPDELEGATE.PUSH_SC = Bool(String(cString: sqlite3_column_text(PSBG_DB.STMT, 6))) ?? false
            APPDELEGATE.PUSH_S = Bool(String(cString: sqlite3_column_text(PSBG_DB.STMT, 7))) ?? false
            APPDELEGATE.PUSH_NS = Bool(String(cString: sqlite3_column_text(PSBG_DB.STMT, 8))) ?? false
            APPDELEGATE.PUSH_EN = Bool(String(cString: sqlite3_column_text(PSBG_DB.STMT, 9))) ?? false
            APPDELEGATE.PUSH_CS = Bool(String(cString: sqlite3_column_text(PSBG_DB.STMT, 10))) ?? false
            APPDELEGATE.PUSH_SV = Bool(String(cString: sqlite3_column_text(PSBG_DB.STMT, 11))) ?? false
        }
            
        if APPDELEGATE.PUSH_N { PUSH_BADGE(true, NOTICE_VC) } else { PUSH_BADGE(false, NOTICE_VC) }
        if APPDELEGATE.PUSH_M { PUSH_BADGE(true, HOME_COMMUNICATION_VC) } else { PUSH_BADGE(false, HOME_COMMUNICATION_VC) }
        if APPDELEGATE.PUSH_C { PUSH_BADGE(true, CLASS_ANNOUNCENENTS_VC) } else { PUSH_BADGE(false, CLASS_ANNOUNCENENTS_VC) }
        if APPDELEGATE.PUSH_F { PUSH_BADGE(true, LUNCH_VC) } else { PUSH_BADGE(false, LUNCH_VC) }
        if APPDELEGATE.PUSH_T { PUSH_BADGE(true, PARENT_TRAINING_VC) } else { PUSH_BADGE(false, PARENT_TRAINING_VC) }
        if APPDELEGATE.PUSH_ET { PUSH_BADGE(true, PARENT_TIP_VC) } else { PUSH_BADGE(false, PARENT_TIP_VC) }
        if APPDELEGATE.PUSH_SC { PUSH_BADGE(true, CHILD_SAFETY_VC) } else { PUSH_BADGE(false, CHILD_SAFETY_VC) }
        if APPDELEGATE.PUSH_S { PUSH_BADGE(true, ACADEMIC_SCHEDULE_VC) } else { PUSH_BADGE(false, ACADEMIC_SCHEDULE_VC) }
        if APPDELEGATE.PUSH_NS { PUSH_BADGE(true, SCHOOL_NEWS_VC) } else { PUSH_BADGE(false, SCHOOL_NEWS_VC) }
        if APPDELEGATE.PUSH_EN { PUSH_BADGE(true, EDU_NEWS_VC) } else { PUSH_BADGE(false, EDU_NEWS_VC) }
        if APPDELEGATE.PUSH_CS { PUSH_BADGE(true, EDU_EVENT_VC) } else { PUSH_BADGE(false, EDU_EVENT_VC) }
        if APPDELEGATE.PUSH_SV { PUSH_BADGE(true, POLL_VC) } else { PUSH_BADGE(false, POLL_VC) }
    }
    
    // PUSH 벳지
    func PUSH_BADGE(_ BADGE: Bool, _ BUTTON: UIButton) {
        
        BUTTON.removeAllSubviews()
        
        if BADGE {
            
            view.setNeedsLayout()
            view.layoutIfNeeded()
            
            let LABEL = UILabel()
            LABEL.frame = CGRect(x: BUTTON.frame.maxX - 15.0, y: -7.5, width: 25.0, height: 25.0)
            LABEL.backgroundColor = .systemRed
            LABEL.layer.cornerRadius = 12.5
            LABEL.clipsToBounds = true
            LABEL.textAlignment = .center
            LABEL.textColor = .white
            LABEL.text = "N"
            LABEL.font = UIFont.boldSystemFont(ofSize: 12)
            
            BUTTON.addSubview(LABEL)
        }
    }
}
