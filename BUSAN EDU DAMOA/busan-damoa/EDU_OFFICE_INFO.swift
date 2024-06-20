//
//  EDU_OFFICE_INFO.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/05/29.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit
import Alamofire

class EDU_OFFICE_INFO_TC: UITableViewCell {
    
    @IBOutlet weak var Sc_name: UILabel!
    @IBOutlet weak var Sc_address: UILabel!
    @IBOutlet weak var Sc_tel: UIButton!
    @IBOutlet weak var Sc_map: UIButton!
    @IBOutlet weak var Sc_homepage: UIButton!
}

// 학교안내/교육기관안내
class EDU_OFFICE_INFO: UIViewController, UISearchBarDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var Search_BG: UIView!
    @IBOutlet weak var Search_Bar: UISearchBar!
    
    var FILTER_OFFICE_INFO = [OFFICE_LIST]()
    var OFFICE_INFO = [OFFICE_LIST]()

    @IBOutlet weak var Navi_Title: UILabel!
    @IBOutlet weak var Navi_LargeTitle: UILabel!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var Navi_LargeTitle_2: UILabel!
    @IBOutlet weak var TITLE_VIEW_BG: UIView!
    @IBOutlet weak var TITLE_VIEW: UIView!
    
    override func loadView() {
        super.loadView()
        
        CHECK_VERSION(Navi_Title)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Navi_Title.alpha = 0.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_SHOW(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KEYBOARD_HIDE(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        Search_BG.VIEW_SHADOW(COLOR: .black, OFFSET: CGSize(width: 10.0, height: 10.0), SD_RADIUS: 7.5, OPACITY: 0.1, RADIUS: 10.0)
        if #available(iOS 13.0, *) { Search_Bar.searchTextField.textColor = .black }
        if UIViewController.APPDELEGATE.SCHOOL_OR_OFFICE == "SCHOOL" {
            Navi_Title.text = "학교 안내"
            Navi_LargeTitle.text = "학교 안내"
            Navi_LargeTitle_2.text = "학교 안내"
            Search_Bar.placeholder = "학교명을 입력해주세요."
        } else {
            Navi_Title.text = "교육기관 안내"
            Navi_LargeTitle.text = "교육기관 안내"
            Navi_LargeTitle_2.text = "교육기관 안내"
            Search_Bar.placeholder = "교육기관명을 입력해주세요."
        }
        Search_Bar.delegate = self
        if !DEVICE_RATIO() {
            Navi_Title.alpha = 1.0
            TITLE_VIEW_BG.isHidden = true
            TITLE_VIEW.frame.size.height = 0.0
            TITLE_VIEW.clipsToBounds = true
        } else {
            Navi_Title.alpha = 0.0
            TITLE_VIEW_BG.isHidden = false
            TITLE_VIEW.frame.size.height = 52.0
            TITLE_VIEW.clipsToBounds = false
        }
        // 교육기관안내
        if !SYSTEM_NETWORK_CHECKING() {
            NOTIFICATION_VIEW("N: 네트워크 상태를 확인해 주세요")
        } else {
            if UIViewController.APPDELEGATE.SCHOOL_OR_OFFICE == "SCHOOL" {
                HTTP_OFFICE(SC_TYPE: "")
            } else {
                HTTP_OFFICE(SC_TYPE: "5")
            }
        }
        
        TableView.separatorStyle = .none
        TableView.delegate = self
        TableView.dataSource = self
        
        if TableView.contentOffset.y < 0 {
            TableView.backgroundColor = UIColor.systemBlue
        } else {
            TableView.backgroundColor = UIColor.GRAY_F1F1F1
        }
    }
    
    func HTTP_OFFICE(SC_TYPE: String) {
        
        let GET_SCHOOL = DATA_URL().SCHOOL_URL + "school/get_school.php"
                    
        let PARAMETERS: Parameters = [ "sc_type": SC_TYPE ]
        
        print("PARAMETERS -", PARAMETERS)
        
        Alamofire.request(GET_SCHOOL, method: .post, parameters: PARAMETERS).responseJSON { response in
            
//            print("[학교안내/교육기관안내]", response)
            
            guard let OFFICE_ARRAY = response.result.value as? Array<Any> else {
                print("[학교안내/교육기관안내] FAIL")
                return
            }
            
            for (_, DATA) in OFFICE_ARRAY.enumerated() {
                
                let DATADICT = DATA as? [String: Any]
                
                self.OFFICE_INFO.append(OFFICE_LIST(
                    IDX: DATADICT?["idx"] as? String ?? "",
                    SC_ADDRESS: DATADICT?["sc_address"] as? String ?? "",
                    SC_CODE: DATADICT?["sc_code"] as? String ?? "",
                    SC_HOMEPAGE: DATADICT?["sc_homepage"] as? String ?? "",
                    SC_NAME: DATADICT?["sc_name"] as? String ?? "",
                    SC_TEL: DATADICT?["sc_tel"] as? String ?? "",
                    SC_TYPE: DATADICT?["sc_type"] as? String ?? "")
                )
            }
            
            self.TableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        FILTER_OFFICE_INFO = searchText.isEmpty ? OFFICE_INFO : OFFICE_INFO.filter({(OFFICE_INFO_STRING: OFFICE_LIST) -> Bool in
            return OFFICE_INFO_STRING.SC_NAME.lowercased().contains(searchText.lowercased())
        })
        
        TableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if DEVICE_RATIO() { SCROLL_EDIT(TABLE_VIEW: TableView, NAVI_TITLE: Navi_Title) }
    }
}

extension EDU_OFFICE_INFO: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if FILTER_OFFICE_INFO.count == 0 {
                if OFFICE_INFO.count == 0 {
                    TableView.isHidden = true
                    return 0
                } else {
                    TableView.isHidden = false
                    return OFFICE_INFO.count
                }
            } else {
                if FILTER_OFFICE_INFO.count == 0 {
                    return 0
                } else {
                    return FILTER_OFFICE_INFO.count
                }
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "EDU_OFFICE_INFO_TC", for: indexPath) as! EDU_OFFICE_INFO_TC
            
            if FILTER_OFFICE_INFO.count == 0 {
            
                let DATA = OFFICE_INFO[indexPath.item]
                
                CELL.Sc_name.text = DATA.SC_NAME
                CELL.Sc_address.text = DATA.SC_ADDRESS
                CELL.Sc_tel.tag = indexPath.item
                CELL.Sc_tel.addTarget(self, action: #selector(TEL(_:)), for: .touchUpInside)
                CELL.Sc_map.tag = indexPath.item
                CELL.Sc_map.addTarget(self, action: #selector(MAP(_:)), for: .touchUpInside)
                CELL.Sc_homepage.tag = indexPath.item
                CELL.Sc_homepage.addTarget(self, action: #selector(HOMEPAGE(_:)), for: .touchUpInside)
            } else {
                
                let DATA = FILTER_OFFICE_INFO[indexPath.item]
                
                CELL.Sc_name.text = DATA.SC_NAME
                CELL.Sc_address.text = DATA.SC_ADDRESS
                CELL.Sc_tel.tag = indexPath.item
                CELL.Sc_tel.addTarget(self, action: #selector(TEL(_:)), for: .touchUpInside)
                CELL.Sc_map.tag = indexPath.item
                CELL.Sc_map.addTarget(self, action: #selector(MAP(_:)), for: .touchUpInside)
                CELL.Sc_homepage.tag = indexPath.item
                CELL.Sc_homepage.addTarget(self, action: #selector(HOMEPAGE(_:)), for: .touchUpInside)
            }
            
            return CELL
        } else {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "EDU_OFFICE_INFO_TC_2", for: indexPath) as! EDU_OFFICE_INFO_TC
            
            return CELL
        }
    }
    
    @objc func TEL(_ sender: UIButton) {
        if FILTER_OFFICE_INFO.count == 0 {
            let DATA = OFFICE_INFO[sender.tag]
            UIApplication.shared.open(URL(string: "tel://" + DATA.SC_TEL)!)
        } else {
            let DATA = FILTER_OFFICE_INFO[sender.tag]
            UIApplication.shared.open(URL(string: "tel://" + DATA.SC_TEL)!)
        }
    }
    
    @objc func MAP(_ sender: UIButton) {
        NOTIFICATION_VIEW("위치찾기 서비스 점검중")
    }
    
    @objc func HOMEPAGE(_ sender: UIButton) {
        if FILTER_OFFICE_INFO.count == 0 {
            let DATA = OFFICE_INFO[sender.tag]
            UIApplication.shared.open(URL(string: "https://" + DATA.SC_HOMEPAGE)!)
        } else {
            let DATA = FILTER_OFFICE_INFO[sender.tag]
            UIApplication.shared.open(URL(string: "https://" + DATA.SC_HOMEPAGE)!)
        }
    }
}
