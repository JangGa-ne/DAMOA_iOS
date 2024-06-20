//
//  AppDelegate.swift
//  부산교육 다모아
//
//  Created by i-Mac on 2020/05/01.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import Firebase
import CoreLocation
import FirebaseMessaging
import UserNotifications
import LocalAuthentication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var LOGIN_API: [LOGIN_DATA] = []        // 로그인 데이터
    var PREVIEW_LIST: [SOSIK_API] = []      // 학교 데이터
    var PUSH_API: [SOSIK_API] = []        // 푸쉬 데이터
    
    var SCHOOL_OR_OFFICE: String = "SCHOOL"
    var OFFICE_NUM: String = ""
    
    var NEW_VERSION: String = "1.0"
    
    var SC_CHECK: Bool = false
    var SV_CHECK: Bool = false
    var T_CHECK: Bool = false
    var CS_CHECK: Bool = false
    
// MARK: CORELOACTION ----------------------------------------------------------
    
    let APP = UIApplication.shared
    var TASK_ID = UIBackgroundTaskIdentifier.invalid
    var LOC_MANAGER = CLLocationManager()
    
// MARK: SQL -------------------------------------------------------------------
    
    var SQL_SCHOOL = SQLITE_DAMOA()
    var SCHOOL_DB_ = [SOSIK_API]()
    
    var PSBG_DB = PSBG_DB_STMT()
    var PSBG_API = [PSBG_DATA]()
    
    var PUSH_N: Bool = false
    var PUSH_M: Bool = false
    var PUSH_C: Bool = false
    var PUSH_F: Bool = false
    var PUSH_T: Bool = false
    var PUSH_ET: Bool = false
    var PUSH_SC: Bool = false
    var PUSH_S: Bool = false
    var PUSH_NS: Bool = false
    var PUSH_EN: Bool = false
    var PUSH_CS: Bool = false
    var PUSH_SV: Bool = false
    
// MARK: COREDATA --------------------------------------------------------------
    
    lazy var PERSISTENT_CONTAINER: NSPersistentContainer = {
        
        let CONTAINER = NSPersistentContainer(name: "COREDATA")
        CONTAINER.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let ERROR = error as NSError? { fatalError("Unresolved error \(ERROR), \(ERROR.userInfo)") }
        })
        return CONTAINER
    }()
    
    // 데이터 소스 역할 을 할 배열 변수
    lazy var ENROLL_LIST: [NSManagedObject] = { return COREDATA_FETCH(ENTITY_NAME: "ENROLL_LIST") }()
    
// MARK: APPDELEGATE -----------------------------------------------------------
    
    var WINDOW: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var STORYBOARD: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    let GCM_MSG_ID_KEY = "gcm.message_id"
    
    var VIEWCONTROLLER = UIViewController()
    var MAIN_VC: HOME?
    
    var SOSIK_A_VC: SOSIK_A?
    var SOSIK_N_VC: SOSIK_N?
    var SOSIK_M_VC: SOSIK_M?
    var SOSIK_C_VC: SOSIK_C?
    var SOSIK_F_VC: SOSIK_F?
    var SOSIK_T_VC: SOSIK_T?
    var SOSIK_ET_VC: SOSIK_ET?
    var SOSIK_SC_VC: SOSIK_SC?
    var SOSIK_S_VC: SOSIK_S?
    var SOSIK_NS_VC: SOSIK_NS?
    var SOSIK_EN_VC: SOSIK_EN?
    var SOSIK_CS_VC: SOSIK_CS?
    var SOSIK_SV_VC: SOSIK_SV?
    
    var PF_UPDATE: Bool = false
    var FAMILY_LIST: [FAMILY_BEACON] = []
    
    var LOGIN: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // PUSH 연결
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, Error in })
        application.registerForRemoteNotifications()
        
        // FIREBASE 연결
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        // PUSH 설정
        if UserDefaults.standard.string(forKey: "mb_id") ?? "" != "" {
            VIEWCONTROLLER.PUSH_CENTER()
        }
        
        // 소식 DB 열기
        OPEN_DB_MAIN()
        // PUSH 배지 DB 준비
        OPEN_PUSH_BADGE_DB()
        
        // 내부 디비 새로고침
//        UserDefaults.standard.removeObject(forKey: "db_db")
        if UserDefaults.standard.string(forKey: "db_db") ?? "" == "" {
            // 소식 DB 수정
            ALTER_DB_MAIN()
            // PUSH 배지 DB 삭제
            DELETE_PUSH_BADGE_DB()
            // PUSH 배지 DB 저장
            SAVE_PUSH_BADGE_DB()
            UserDefaults.standard.setValue("11111", forKey: "db_db")
            UserDefaults.standard.synchronize()
        }
        
        // 앱 버전 확인
        VIEWCONTROLLER.GET_VERSION_POST_DATA(NAME: "앱버전확인", ACTION_TYPE: "")
        
        // 로그인 정보 확인 (PUSH 진입 확인)
        let VC = STORYBOARD.instantiateViewController(withIdentifier: "LOADING") as! LOADING
        VC.modalTransitionStyle = .crossDissolve
        VC.PUSH_YN = false
        WINDOW?.rootViewController = VC
        WINDOW?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // FIREBASE TOKEN 초기화 방지
        Messaging.messaging().isAutoInitEnabled = true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // FIREBASE TOKEN 초기화 방지
        Messaging.messaging().isAutoInitEnabled = true
        // 학생 위치 서비스 설정
        LOC_UPDATE()
    }

// MARK: 생체인증 ----------------------------------------------------------------
    
    func applicationWillResignActive(_ application: UIApplication) {
        // FIREBASE TOKEN 초기화 방지
        Messaging.messaging().isAutoInitEnabled = true
        // 학생 위치 서비스 설정
        LOC_UPDATE()
        // 생체인증 (로그아웃)
        LOGIN_AUTH(MODE: "BACKGROUND")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // FIREBASE TOKEN 초기화 방지
        Messaging.messaging().isAutoInitEnabled = true
        // 학생 위치 서비스 설정
        LOC_UPDATE()
        // 생체인증 (로그인)
        LOGIN_AUTH(MODE: "FOREGROUND")
    }
        
    enum AUTH_STATE { case LOGIN, LOGOUT }
    
    var STATE = AUTH_STATE.LOGOUT
    let AUTH_VIEW = UIView()
    var AUTH_CONTEXT = LAContext()
    
    //MARK: - 생체인증
    func LOGIN_AUTH(MODE: String) {
        
        if UserDefaults.standard.bool(forKey: "switch_pw") {
            
            var ERROR: NSError?
            
            if AUTH_CONTEXT.canEvaluatePolicy(.deviceOwnerAuthentication, error: &ERROR) {
                
                if MODE == "BACKGROUND" {
                                        
                    STATE = .LOGOUT
                    
                    AUTH_VIEW.frame = UIScreen.main.bounds
                    AUTH_VIEW.backgroundColor = .systemBlue
                    
                    let TEXT = UILabel()
                    TEXT.frame = AUTH_VIEW.bounds
                    TEXT.font = UIFont(name: "YiSunShinDotumB", size: 30.0)
                    TEXT.textColor = .white
                    TEXT.textAlignment = .center
                    TEXT.text = "부산교육 다모아"
                    AUTH_VIEW.addSubview(TEXT)
                    
                    WINDOW?.addSubview(AUTH_VIEW)
                } else if MODE == "FOREGROUND" {
                    
                    AUTH_CONTEXT.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "비밀번호가 일치하면 앱을 실행합니다.") { (SUCCESS, ERROR) in
                        
                        if SUCCESS {
                            DispatchQueue.main.async { [unowned self] in
                                self.STATE = .LOGIN
                                self.AUTH_VIEW.removeFromSuperview()
                            }
                        } else {
                            print(ERROR?.localizedDescription ?? "Failed to authenticate")
                        }
                    }
                }
            } else {
                print(ERROR?.localizedDescription ?? "Failed to authenticate")
            }
        }
    }
}
