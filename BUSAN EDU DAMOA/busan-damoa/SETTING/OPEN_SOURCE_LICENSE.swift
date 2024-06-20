//
//  OPEN_SOURCE_LICENSE.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/06/16.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit

class OPEN_SOURCE_LICENSE_TC: UITableViewCell {
    
    @IBOutlet weak var TITLE: UILabel!
    @IBOutlet weak var ADDRESS: UILabel!
    @IBOutlet weak var COPYRIGHT: UILabel!
}

// OPEN SOURCE LICENSE
class OPEN_SOURCE_LICENSE: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func BACK_VC(_ sender: Any) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var Navi_BG: UIView!
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
        
        Navi_BG.alpha = 0.0
        Navi_Title.alpha = 0.0
        
        TableView.delegate = self
        TableView.dataSource = self
        TableView.backgroundColor = .white
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if TableView.contentOffset.y <= 0.0 {
            Navi_BG.alpha = 0.0
            Navi_Title.alpha = 0.0
        } else if TableView.contentOffset.y <= 34.0 {
            Navi_BG.alpha = 0.0
            Navi_Title.alpha = 0.0
        } else if TableView.contentOffset.y <= 38.0 {
            Navi_BG.alpha = 0.2
            Navi_Title.alpha = 0.2
        } else if TableView.contentOffset.y <= 42.0 {
            Navi_BG.alpha = 0.4
            Navi_Title.alpha = 0.4
        } else if TableView.contentOffset.y <= 46.0 {
            Navi_BG.alpha = 0.6
            Navi_Title.alpha = 0.6
        } else if TableView.contentOffset.y <= 50.0 {
            Navi_BG.alpha = 0.8
            Navi_Title.alpha = 0.8
        } else {
            Navi_BG.alpha = 1.0
            Navi_Title.alpha = 1.0
        }
    }
    
    var TITME: [String] = ["Alamofire", "AFNetworking", "Nuke", "SDWebImage", "CVCalendar", "YoutubePlayer-in-WKWebView", "Firebase"]
    var ADDRESS: [String] = ["https://github.com/Alamofire/Alamofire", "https://github.com/AFNetworking/AFNetworking", "https://github.com/kean/Nuke", "https://github.com/SDWebImage/SDWebImage", "https://github.com/CVCalendar/CVCalendar", "https://github.com/hmhv/YoutubePlayer-in-WKWebView", "https://firebase.google.com"]
    var COPYRIGHT: [String] = ["Copyright © 2014-2020 Alamofire Software Foundation (http://alamofire.org/)", "Copyright © 2011-2020 Alamofire Software Foundation (http://alamofire.org/)", "Copyright © 2015-2020 Alexander Grebenyuk", "Copyright © 2009-2018 Olivier Poitrey rs@dailymotion.com", "Copyright © 2017 CVCalendar", "Copyright 2014 Google Inc. All rights reserved.", "Copyright © 2020 Google Inc. All rights reserved."]
}

extension OPEN_SOURCE_LICENSE: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TITME.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "OPEN_SOURCE_LICENSE_TC", for: indexPath) as! OPEN_SOURCE_LICENSE_TC
        
        CELL.TITLE.text = TITME[indexPath.item]
        CELL.ADDRESS.text = ADDRESS[indexPath.item]
        CELL.COPYRIGHT.text = COPYRIGHT[indexPath.item]
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
