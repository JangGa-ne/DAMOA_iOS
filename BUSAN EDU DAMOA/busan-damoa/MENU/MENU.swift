//
//  MENU.swift
//  busan-damoa
//
//  Created by i-Mac on 2020/06/23.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit

struct MENU_SECTION {
    
    var TITLE: String!
    var CONTENT: [String]!
    var EXPANDED: Bool!
    
    init (TITLE: String, CONTENT: [String], EXPANDED: Bool) {
        self.TITLE = TITLE
        self.CONTENT = CONTENT
        self.EXPANDED = EXPANDED
    }
}

protocol HOME_PROTOCOL {
    func TOGGLE_SECTION(HEADER: HeaderView, SECTION: Int)
}

class HeaderView: UITableViewHeaderFooterView {
    
    var PROTOCOL: HOME_PROTOCOL!
    var SECTION: Int!
    
    func CUSTOM_INIT(TITLE: String, SECTION: Int, PROTOCOL: HOME_PROTOCOL) {
        self.textLabel?.text = TITLE
        self.SECTION = SECTION
        self.PROTOCOL = PROTOCOL
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = .black
        self.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.textLabel?.frame.origin.x = 20.0
        self.contentView.backgroundColor = .GRAY_F1F1F1
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SECTION_HEADER_ACTION)))
    }

    @objc func SECTION_HEADER_ACTION(GESTURE_RECOGNIZER: UITapGestureRecognizer) {

        let CELL = GESTURE_RECOGNIZER.view as! HeaderView
        PROTOCOL!.TOGGLE_SECTION(HEADER: self, SECTION: CELL.SECTION)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
