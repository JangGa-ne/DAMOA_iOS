//
//  ENROLL.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/06/01.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseMessaging

class ENROLL_TC: UITableViewCell {
    
    @IBOutlet weak var School_Symbol_Image: UIImageView!
    @IBOutlet weak var Grade_Class: UILabel!        // 학급반
    @IBOutlet weak var School_name: UILabel!        // 학교이름
    
    @IBAction func Edit_Button(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: { self.EditView.alpha = 1.0 })
    }
    @IBOutlet weak var EditView: UIStackView!       // 수정하기
    @IBOutlet weak var Delete_Button: UIButton!
    @IBAction func Delete_Button(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: { self.EditView.alpha = 0.0 })
    }
    @IBAction func Cancel_Button(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: { self.EditView.alpha = 0.0 })
    }
}

class ENROLL: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // 화면 다른곳 터치하면 키보드 사라짐
        view.endEditing(true)
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) {
        if SYSTEM_NETWORK_CHECKING() { GET_PREVIEW_POST_DATA(NAME: "미리보기(새로고침)", BOARD_TYPE: "A", NEW: true) }
    }
    
    var INDEX_PATH = IndexPath()
    
    @IBOutlet weak var Navi_Title: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var TITLE_VIEW_BG: UIView!
    @IBOutlet weak var TITLE_VIEW: UIView!
    
    override func loadView() {
        super.loadView()
        
        CHECK_VERSION(Navi_Title)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navi_Title.alpha = 0.0
        
        TableView.separatorStyle = .none
        TableView.delegate = self
        TableView.dataSource = self
        TableView.backgroundColor = .white
        
        if UIViewController.APPDELEGATE.ENROLL_LIST.count != 0 {
            print(UIViewController.APPDELEGATE.ENROLL_LIST)
        }
    }
    
    // 학교추가
    @IBAction func ADD_VC(_ sender: UIButton) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ENROLL_SCHOOL") as! ENROLL_SCHOOL
        VC.modalTransitionStyle = .crossDissolve
        present(VC, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        SCROLL_EDIT(TABLE_VIEW: TableView, NAVI_TITLE: Navi_Title)
    }
}

extension ENROLL: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UIViewController.APPDELEGATE.ENROLL_LIST.count == 0 {
            TableView.isHidden = true
            return 0
        } else {
            tableView.isHidden = false
            return UIViewController.APPDELEGATE.ENROLL_LIST.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let RECORD = UIViewController.APPDELEGATE.ENROLL_LIST[indexPath.item]
        let SC_LOGO = RECORD.value(forKey: "sc_logo") as? String ?? ""
        let SC_CODE = RECORD.value(forKey: "sc_code") as? String ?? ""
        let SC_NAME = RECORD.value(forKey: "sc_name") as? String ?? ""
        let CLASS_NAME = RECORD.value(forKey: "class_name") as? String ?? ""
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "ENROLL_TC", for: indexPath) as! ENROLL_TC
        
        CELL.Grade_Class.text = CLASS_NAME
        CELL.School_name.text = SC_NAME
        
        if SC_CODE == "" {
            
            NUKE_IMAGE(IMAGE_URL: DATA_URL().SCHOOL_LOGO_URL + SC_LOGO, PLACEHOLDER: UIImage(named: "school_logo.png")!, PROFILE: CELL.School_Symbol_Image, FRAME_SIZE: CELL.School_Symbol_Image.frame.size)
        } else {
            
            NUKE_IMAGE(IMAGE_URL: DATA_URL().SCHOOL_LOGO_URL + SC_CODE, PLACEHOLDER: UIImage(named: "school_logo.png")!, PROFILE: CELL.School_Symbol_Image, FRAME_SIZE: CELL.School_Symbol_Image.frame.size)
        }
        
        CELL.EditView.alpha = 0.0
        CELL.Delete_Button.tag = indexPath.item
        CELL.Delete_Button.addTarget(self, action: #selector(DELETE(_:)), for: .touchUpInside)
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func DELETE(_ sender: UIButton) {
        
        let ENROLL_DATA = UIViewController.APPDELEGATE.ENROLL_LIST
        let ENROLL_API = ENROLL_DATA[sender.tag]
        
        let SC_CODE = ENROLL_API.value(forKey: "sc_code") as? String ?? ""
        let CL_CODE = ENROLL_API.value(forKey: "cl_code") as? String ?? ""
        
        // firebase 구독취소
        Messaging.messaging().unsubscribe(fromTopic: "\(SC_CODE)N_ios")
        Messaging.messaging().unsubscribe(fromTopic: "\(SC_CODE)M_ios")
        Messaging.messaging().unsubscribe(fromTopic: "\(SC_CODE)C_ios")
        Messaging.messaging().unsubscribe(fromTopic: "\(CL_CODE)C_ios")
        Messaging.messaging().unsubscribe(fromTopic: "\(SC_CODE)F_ios")
        Messaging.messaging().unsubscribe(fromTopic: "\(SC_CODE)NS_ios")
        
        if UIViewController.APPDELEGATE.DELETE(OBJECT: ENROLL_API) {
            
            MAIN_PUSH_CONTROL_CENTER()      // 메인푸시
            SCHOOL_PUSH_CONTROL_CENTER()    // 학교푸시
            
            UIViewController.APPDELEGATE.ENROLL_LIST.remove(at: sender.tag)
            TableView.reloadData()
        }
    }
}

