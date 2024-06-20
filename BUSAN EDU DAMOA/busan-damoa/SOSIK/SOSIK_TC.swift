//
//  SOSIK_TC.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/28.
//

import UIKit
import Nuke
import Alamofire
import YoutubePlayer_in_WKWebView

class SOSIK_CC: UICollectionViewCell {
    
//    @IBOutlet weak var MEDIA_IMAGE: UIImageView!
    
    let IMAGE_BG = UIImageView()
    let EFFECT_VIEW = UIVisualEffectView()
    let MEDIA_IMAGE = UIImageView()
    
    let MEDIA_VIEW = WKYTPlayerView()
}

class SOSIK_TC: UITableViewCell {
    
    var PROTOCOL: UIViewController?
    var DETAIL: Bool = false
    
    var SOSIK_LIST: [SOSIK_API] = []
    var SOSIK_POSITION: Int = 0
    var MEDIA_LIST: [ATTACHED] = []
    
    @IBOutlet weak var SC_LOGO: UIImageView!
    @IBOutlet weak var BOARD_TYPE: UILabel!
    @IBOutlet weak var SC_NAME: UILabel!
    @IBOutlet weak var DATETIME: UILabel!
    @IBOutlet weak var DAY: UILabel!
    
    // 컨텐츠
    @IBOutlet weak var CT_VIEW: UIView!
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    @IBOutlet weak var CT_PAGE: UIPageControl!
    @IBOutlet weak var CT_TITLE: UILabel!
    @IBOutlet weak var CT_LINE: UIView!
    @IBOutlet weak var CT_CONTENT: UILabel!
    @IBOutlet weak var CT_TEXTVIEW: UITextView!
    @IBOutlet weak var SURVEY_VC: UIButton!
    
    // 첨부파일
    @IBOutlet weak var DL_IMAGE: UIImageView!
    @IBOutlet weak var DL_NAME: UILabel!
    @IBOutlet weak var DL_BTN: UIButton!
    // 좋아요(스크랩)
    @IBOutlet weak var SR_IMAGE: UIImageView!
    @IBOutlet weak var SR_BTN: UIButton!
    @IBOutlet weak var SR_MENU: UIButton!
    // 공유하기
    @IBOutlet weak var SH_IMAGE: UIImageView!
    @IBOutlet weak var SH_BTN: UIButton!
    
    func DELEGATE() {
        
        // 데이터 삭제
        MEDIA_LIST.removeAll()
        
        DispatchQueue.main.async {
            
            if self.SOSIK_LIST[self.SOSIK_POSITION].ATTACHED.count != 0 {
                self.SET_POST_DATA(NAME: "미디어", ACTION_TYPE: "")
            }
            
            // 컬렉션뷰 연결
            self.COLLECTIONVIEW.delegate = self
            self.COLLECTIONVIEW.dataSource = self
            let LAYER = UICollectionViewFlowLayout()
            LAYER.scrollDirection = .horizontal
            LAYER.minimumLineSpacing = 0.0
            self.COLLECTIONVIEW.setCollectionViewLayout(LAYER, animated: false)
            // 뷰 미리보기
//            self.PROTOCOL!.registerForPreviewing(with: self, sourceView: self.COLLECTIONVIEW)
            
            // 페이지
            if self.MEDIA_LIST.count <= 1 {
                self.CT_PAGE.isHidden = true
            } else {
                self.CT_PAGE.isHidden = false
                self.CT_PAGE.currentPage = 0
                self.CT_PAGE.numberOfPages = self.MEDIA_LIST.count
                self.CT_PAGE.addTarget(self, action: #selector(self.CT_PAGE(_:)), for: .touchUpInside)
            }
        }
    }
    
    // 페이지
    @objc func CT_PAGE(_ sender: UIPageControl) {
        
        // 진동 이벤트
        UIImpactFeedbackGenerator().impactOccurred()
        
        COLLECTIONVIEW.contentOffset.x = self.frame.size.width * CGFloat(sender.currentPage)
    }
    
    // 미디어
    func SET_POST_DATA(NAME: String, ACTION_TYPE: String) {
        
        for (_, DATA) in SOSIK_LIST[SOSIK_POSITION].ATTACHED.enumerated() {
            
            let APPEND_VALUE = ATTACHED()
            
            if DATA.MEDIA_TYPE != "f" {
            
                APPEND_VALUE.SET_DATETIME(DATETIME: DATA.DATETIME as Any)
                APPEND_VALUE.SET_DT_FROM(DT_FROM: DATA.DT_FROM as Any)
                APPEND_VALUE.SET_FILE_NAME(FILE_NAME: DATA.FILE_NAME as Any)
                APPEND_VALUE.SET_FILE_NAME_ORG(FILE_NAME_ORG: DATA.FILE_NAME_ORG as Any)
                APPEND_VALUE.SET_FILE_SIZE(FILE_SIZE: DATA.FILE_SIZE as Any)
                APPEND_VALUE.SET_IDX(IDX: DATA.IDX as Any)
                APPEND_VALUE.SET_IN_SEQ(IN_SEQ: DATA.IN_SEQ as Any)
                APPEND_VALUE.SET_LAT(LAT: DATA.LAT as Any)
                APPEND_VALUE.SET_LNG(LNG: DATA.LNG as Any)
                APPEND_VALUE.SET_MEDIA_FILES(MEDIA_FILES: DATA.MEDIA_FILES as Any)
                APPEND_VALUE.SET_MEDIA_TYPE(MEDIA_TYPE: DATA.MEDIA_TYPE as Any)
                APPEND_VALUE.SET_MSG_GROUP(MSG_GROUP: DATA.MSG_GROUP as Any)
                APPEND_VALUE.SET_HTTP_STRING(HTTP_STRING: DATA.HTTP_STRING as Any)
                APPEND_VALUE.SET_DOWNLOAD_URL(DOWNLOAD_URL: DATA.DOWNLOAD_URL as Any)
                
                MEDIA_LIST.append(APPEND_VALUE)
                COLLECTIONVIEW.reloadData()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //MARK: 소식 업데이트(좋아요)
    func PUT_POST_DATA(NAME: String, ACTION_TYPE: String) {
        
        let POST_URL: String = DATA_URL().SCHOOL_URL + "message/school_sosik_update.php"
        let PARAMETERS: Parameters = [
            "mb_id": UIViewController.USER_DATA.string(forKey: "mb_id") ?? "",
            "board_key": SOSIK_LIST[SOSIK_POSITION].BOARD_KEY,
            "board_type": SOSIK_LIST[SOSIK_POSITION].BOARD_TYPE,
            "action_type": ACTION_TYPE
        ]
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 15.0
        MANAGER.request(POST_URL, method: .post, parameters: PARAMETERS).responseString(completionHandler: { response in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS { print("KEY: \(KEY), VALUE: \(VALUE)") }
            print(response)
        })
    }
    
    // 좋아요(스크랩)
    @objc func SR_BTN(_ sender: UIButton) {
        
        let DATA = SOSIK_LIST[sender.tag]
        
        if !DATA.LIKE {
            // 데이터 추가
            SCRAP()
            DATA.LIKE = true
            SR_IMAGE.image = UIImage(named: "like_on.png")
            PROTOCOL!.VIEW_NOTICE(": 소식 보관함에 추가됨")
            //MARK: 소식 좋아요
            if PROTOCOL!.SYSTEM_NETWORK_CHECKING() { PUT_POST_DATA(NAME: "소식좋아요", ACTION_TYPE: "like") }
        } else {
            // 데이터 삭제
            UIViewController.APPDELEGATE.DELETE_DB_MAIN(ALL: false, BOARD_KEY: DATA.BOARD_KEY)
            DATA.LIKE = false
            SR_IMAGE.image = UIImage(named: "like_off.png")
            PROTOCOL!.VIEW_NOTICE(": 소식 보관함에서 삭제됨")
        }
    }
    
    //MARK: - 스크랩 (스크랩)
    func SCRAP() {
        
        UIViewController.APPDELEGATE.OPEN_DB_MAIN()
        
        var DATETIME: String = ""; var DT_FROM: String = ""; var DOWNLOAD_URL: String = ""; var FILE_NAME: String = ""; var FILE_NAME_ORG: String = ""
        var FILE_SIZE: String = ""; var IDX: String = ""; var IN_SEQ: String = ""; var LAT: String = ""; var LNG: String = ""; var MEDIA_FILES: String = ""
        var MEDIA_TYPE: String = ""; var MSG_GROUP: String = ""; var HTTP_STRING: String = ""
        
        let DATA = SOSIK_LIST[SOSIK_POSITION]
        
        for ATTACHED in DATA.ATTACHED {
            
            DATETIME.append("\(ATTACHED.DATETIME)|"); DT_FROM.append("\(ATTACHED.DT_FROM)|"); DOWNLOAD_URL.append("\(ATTACHED.DOWNLOAD_URL)|"); FILE_NAME.append("\(ATTACHED.FILE_NAME)|"); FILE_NAME_ORG.append("\(ATTACHED.FILE_NAME_ORG)|")
            FILE_SIZE.append("\(ATTACHED.FILE_SIZE)|"); IDX.append("\(ATTACHED.IDX)|"); IN_SEQ.append("\(ATTACHED.IN_SEQ)|"); LAT.append("\(ATTACHED.LAT)|"); LNG.append("\(ATTACHED.LNG)|")
            MEDIA_FILES.append("\(ATTACHED.MEDIA_FILES)|"); MEDIA_TYPE.append("\(ATTACHED.MEDIA_TYPE)|"); MSG_GROUP.append("\(ATTACHED.MSG_GROUP)|"); HTTP_STRING.append("\(ATTACHED.HTTP_STRING)|")
        }
        
        UIViewController.APPDELEGATE.INSERT_DB_MAIN(BOARD_CODE: DATA.BOARD_CODE, BOARD_ID: DATA.BOARD_ID, BOARD_KEY: DATA.BOARD_KEY, BOARD_NAME: DATA.BOARD_NAME, BOARD_SOURCE: DATA.BOARD_SOURCE, BOARD_TYPE: DATA.BOARD_TYPE, CALL_BACK: DATA.CALL_BACK, CLASS_INFO: DATA.CLASS_INFO, CONTENT: DATA.CONTENT, CONTENT_TEXT: DATA.CONTENT_TEXT, CONTENT_TYPE: DATA.CONTENT_TYPE, DATETIME: DATA.DATETIME, DST: DATA.DST, DST_NAME: DATA.DST_NAME, DST_TYPE: DATA.DST_TYPE, FCM_KEY: DATA.FCM_KEY, FILE_COUNT: DATA.FILE_COUNT, FROM_FILE: DATA.FROM_FILE, IDX: DATA.IDX, INPUT_DATE: DATA.INPUT_DATE, IS_MODIFY: DATA.IS_MODIFY, IS_PUSH: DATA.IS_PUSH, LIKE_COUNT: DATA.LIKE_COUNT, LIKE_ID: DATA.LIKE_ID, ME_LENGTH: DATA.ME_LENGTH, MEDIA_COUNT: DATA.MEDIA_COUNT, MSG_GROUP: DATA.MSG_GROUP, NO: DATA.NO, OPEN_COUNT: DATA.OPEN_COUNT, POLL_NUM: DATA.POLL_NUM, RESULT: DATA.RESULT, SC_CODE: DATA.SC_CODE, SC_GRADE: DATA.SC_GRADE, SC_GROUP: DATA.SC_GROUP, SC_LOCATION: DATA.SC_LOCATION, SC_LOGO: DATA.SC_LOGO, SC_NAME: DATA.SC_NAME, SEND_TYPE: DATA.SEND_TYPE, SENDER_IP: DATA.SENDER_IP, SUBJECT: DATA.SUBJECT, TARGET_GRADE: DATA.TARGET_GRADE, TARGET_CLASS: DATA.TARGET_CLASS, WR_SHARE: DATA.WR_SHARE, WRITER: DATA.WRITER, LIKE: true, AT_DATETIME: DATETIME, AT_DT_FROM: DT_FROM, AT_FILE_NAME: FILE_NAME, AT_FILE_NAME_ORG: FILE_NAME_ORG, AT_FILE_SIZE: FILE_SIZE, AT_IDX: IDX, AT_IN_SEQ: IN_SEQ, AT_LAT: LAT, AT_LNG: LNG, AT_MEDIA_FILES: MEDIA_FILES, AT_MEDIA_TYPE: MEDIA_TYPE, AT_MSG_GROUP: MSG_GROUP, AT_HTTP_STRING: HTTP_STRING, AT_DOWNLOAD_URL: DOWNLOAD_URL)
    }
}

extension SOSIK_TC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if MEDIA_LIST.count == 0 { return 0 } else { return MEDIA_LIST.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        ImageCache.shared.removeAll()
        
        let DATA = MEDIA_LIST[indexPath.item]
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "SOSIK_CC", for: indexPath) as! SOSIK_CC
        
        if DETAIL {
            CELL.layer.cornerRadius = 10.0
            CELL.clipsToBounds = true
        }
        
        if DATA.MEDIA_FILES != "" {
            // 이미지
            if DATA.MEDIA_TYPE == "p" {
                
                let KOREAN_URL = DATA.MEDIA_FILES.replacingOccurrences(of: "&2520", with: "%20").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                
                if !DETAIL {
                    CELL.IMAGE_BG.frame = CELL.bounds
                } else {
                    CELL.IMAGE_BG.layer.cornerRadius = 10.0
                    CELL.IMAGE_BG.clipsToBounds = true
                    CELL.IMAGE_BG.frame = CGRect(x: 10, y: 0, width: CELL.bounds.size.width - 20.0, height: CELL.bounds.size.height)
                }
                CELL.addSubview(CELL.IMAGE_BG)
                NUKE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: UIImage(named: "clear.png")!, PROFILE: CELL.IMAGE_BG, FRAME_VIEW: CELL, SCALE: .scaleAspectFill)
                
                if !DETAIL {
                    CELL.EFFECT_VIEW.frame = CELL.bounds
                } else {
                    CELL.EFFECT_VIEW.layer.cornerRadius = 10.0
                    CELL.EFFECT_VIEW.clipsToBounds = true
                    CELL.EFFECT_VIEW.frame = CGRect(x: 10, y: 0, width: CELL.bounds.size.width - 20.0, height: CELL.bounds.size.height)
                }
                CELL.EFFECT_VIEW.effect = UIBlurEffect(style: .light)
                CELL.addSubview(CELL.EFFECT_VIEW)
                
                if !DETAIL {
                    CELL.MEDIA_IMAGE.frame = CELL.bounds
                } else {
                    CELL.MEDIA_IMAGE.layer.cornerRadius = 10.0
                    CELL.MEDIA_IMAGE.clipsToBounds = true
                    CELL.MEDIA_IMAGE.frame = CGRect(x: 10, y: 0, width: CELL.bounds.size.width - 20.0, height: CELL.bounds.size.height)
                }
                CELL.addSubview(CELL.MEDIA_IMAGE)
                NUKE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: UIImage(named: "clear.png")!, PROFILE: CELL.MEDIA_IMAGE, FRAME_VIEW: CELL, SCALE: .scaleAspectFit)
            // 동영상
            } else if DATA.MEDIA_TYPE == "v" {
                
                if !DETAIL {
                    CELL.EFFECT_VIEW.frame = CELL.bounds
                } else {
                    CELL.EFFECT_VIEW.layer.cornerRadius = 10.0
                    CELL.EFFECT_VIEW.clipsToBounds = true
                    CELL.EFFECT_VIEW.frame = CGRect(x: 10, y: 0, width: CELL.bounds.size.width - 20.0, height: CELL.bounds.size.height)
                }
                CELL.EFFECT_VIEW.backgroundColor = .black
                CELL.addSubview(CELL.EFFECT_VIEW)
                
                if !DETAIL {
                    CELL.MEDIA_IMAGE.frame = CELL.bounds
                } else {
                    CELL.MEDIA_IMAGE.layer.cornerRadius = 10.0
                    CELL.MEDIA_IMAGE.clipsToBounds = true
                    CELL.MEDIA_IMAGE.frame = CGRect(x: 10, y: 0, width: CELL.bounds.size.width - 20.0, height: CELL.bounds.size.height)
                }
                CELL.addSubview(CELL.MEDIA_IMAGE)
                if DATA.MEDIA_FILES.contains("_media1.mp4") {
                    let MEDIA_FILE = DATA.MEDIA_FILES.replacingOccurrences(of: "%2520", with: "%20").replacingOccurrences(of: "_media1.mp4", with: "_mplayer1_1.png")
                    NUKE(IMAGE_URL: MEDIA_FILE, PLACEHOLDER: UIImage(named: "clear.png")!, PROFILE: CELL.MEDIA_IMAGE, FRAME_VIEW: CELL, SCALE: .scaleAspectFit)
                } else {
                    CELL.MEDIA_IMAGE.image = VIDEO_THUMBNAIL(DATA.MEDIA_FILES.replacingOccurrences(of: "%2520", with: "%20"))
                }
                
                let PLAY = UIImageView()
                PLAY.frame = CGRect(x: collectionView.frame.width / 2 - 24.0, y: collectionView.frame.height / 2 - 24.0, width: 48.0, height: 48.0)
                PLAY.image = UIImage(named: "play.png")
                CELL.addSubview(PLAY)
            // 유튜브
            } else if DATA.MEDIA_TYPE == "y" {
                
                if !DETAIL {
                    CELL.MEDIA_VIEW.frame = CELL.bounds
                } else {
                    CELL.MEDIA_VIEW.layer.cornerRadius = 10.0
                    CELL.MEDIA_VIEW.clipsToBounds = true
                    CELL.MEDIA_VIEW.frame = CGRect(x: 10, y: 0, width: CELL.bounds.size.width - 20.0, height: CELL.bounds.size.height)
                }
                CELL.addSubview(CELL.MEDIA_VIEW)
                CELL.MEDIA_VIEW.load(withVideoId: DATA.FILE_NAME)
            }
        }
        
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let DATA = MEDIA_LIST[indexPath.item]
        
        if DATA.MEDIA_TYPE == "p" {
            // 이미지
            let VC = PROTOCOL!.storyboard?.instantiateViewController(withIdentifier: "DETAIL_IMAGE") as! DETAIL_IMAGE
            VC.MEDIA_LIST = MEDIA_LIST
            PROTOCOL!.present(VC, animated: true, completion: nil)
        } else if DATA.MEDIA_TYPE == "v" {
            // 동영상
            VIDIO_PLAYER(MEDIA_LIST: MEDIA_LIST, TAG: indexPath.item, PROTOCOL: PROTOCOL)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // 진동 이벤트
        UIImpactFeedbackGenerator().impactOccurred()
        
        CT_PAGE.currentPage = Int(targetContentOffset.pointee.x / COLLECTIONVIEW.frame.width)
    }
    
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let DATA = MEDIA_LIST[indexPath.item]
        
        if DATA.MEDIA_TYPE == "p" {
        
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
                
                let KOREAN_URL = DATA.MEDIA_FILES.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                
                let IMAGE_TO_CLIP = UIAction(title: "이미지 복사하기", image: UIImage(systemName: "doc.on.clipboard")) { action in
                    
                    let IMAGE_DATA = try! Data(contentsOf: URL(string: KOREAN_URL ?? "")!)
                    let IMAGE_SAVE = UIImage(data: IMAGE_DATA)
                    UIPasteboard.general.image = IMAGE_SAVE
                }
                
                let IMAGE_TO_SAVE = UIAction(title: "카메라 롤에 저장", image: UIImage(systemName: "square.and.arrow.down")) { action in
                    
                    let IMAGE_DATA = try! Data(contentsOf: URL(string: KOREAN_URL ?? "")!)
                    let IMAGE_SAVE = UIImage(data: IMAGE_DATA)
                    UIImageWriteToSavedPhotosAlbum(IMAGE_SAVE!, nil, nil, nil)
                }
                
                return UIMenu(title: "", children: [IMAGE_TO_CLIP, IMAGE_TO_SAVE])
            }
        } else {
            return nil
        }
    }
}

extension SOSIK_TC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: COLLECTIONVIEW.frame.size.width, height: COLLECTIONVIEW.frame.size.height)
    }
}

//extension SOSIK_TC: UIViewControllerPreviewingDelegate {
//
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        PROTOCOL!.present(viewControllerToCommit, animated: true, completion: nil)
//    }
//
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//
//        guard let CV_INDEXPATH = COLLECTIONVIEW.indexPathForItem(at: location) else {
//            return nil
//        }
//
//        guard let CV_CELL = COLLECTIONVIEW.cellForItem(at: CV_INDEXPATH) else {
//            return nil
//        }
//
//        let PREVIEW = DETAIL_IMAGE()
//        PREVIEW.view.backgroundColor = .black
//        PREVIEW.preferredContentSize = CGSize(width: 0.0, height: 600.0)
//
//        var SOURCE_RECT = CV_CELL.frame
//        SOURCE_RECT.origin.x = SOURCE_RECT.origin.x - COLLECTIONVIEW.contentOffset.x
//
//        let Y = self.frame.origin.y + CV_CELL.frame.origin.y
//        SOURCE_RECT.origin.y = Y
//        previewingContext.sourceRect = SOURCE_RECT
//
//        return PREVIEW
//    }
//}
