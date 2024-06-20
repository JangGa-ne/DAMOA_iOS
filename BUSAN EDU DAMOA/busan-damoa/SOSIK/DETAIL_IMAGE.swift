//
//  DETAIL_IMAGE.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/29.
//

import UIKit
import AVKit
import YoutubePlayer_in_WKWebView

class DETAIL_IMAGE_CC: UICollectionViewCell {
    
    let MEDIA_IMAGE = UIImageView()
    let MEDIA_VIEW = WKYTPlayerView()
}

//MARK: - 소식 이미지 상세보기
class DETAIL_IMAGE: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var STATUS_BAR_HIDDEN: Bool = false
    
    override var prefersStatusBarHidden: Bool {
        return STATUS_BAR_HIDDEN
    }
    
    @IBAction func BACK_VC(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    var MEDIA_LIST: [ATTACHED] = []
    var SELECT: Bool = true
    
    // 내비게이션바
    @IBOutlet weak var NAVI_BG: UIView!
    @IBOutlet weak var NAVI_VIEW: UIView!
    @IBOutlet weak var NAVI_TITLE: UILabel!
    // 컬렉션뷰
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    // 페이지
    @IBOutlet weak var PAGE_BG: UIView!
    @IBOutlet weak var PAGE_NUM: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 컬렉션뷰 연결
        COLLECTIONVIEW.delegate = self
        COLLECTIONVIEW.dataSource = self
        let LAYER = UICollectionViewFlowLayout()
        LAYER.scrollDirection = .horizontal
        LAYER.minimumLineSpacing = 0.0
        COLLECTIONVIEW.setCollectionViewLayout(LAYER, animated: false)
        
        // 페이지
        PAGE_BG.layer.cornerRadius = 15.0
        PAGE_BG.clipsToBounds = true
        PAGE_NUM.text = "1 / \(MEDIA_LIST.count)"
    }
}

extension DETAIL_IMAGE: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if MEDIA_LIST.count == 0 { return 0 } else { return MEDIA_LIST.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let DATA = MEDIA_LIST[indexPath.item]
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "DETAIL_IMAGE_CC", for: indexPath) as! DETAIL_IMAGE_CC
        
        if DATA.MEDIA_FILES != "" {
            // 이미지
            if DATA.MEDIA_TYPE == "p" {
                
                let KOREAN_URL = DATA.MEDIA_FILES.replacingOccurrences(of: "&2520", with: "%20").addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                
                CELL.MEDIA_IMAGE.frame = CELL.bounds
                CELL.addSubview(CELL.MEDIA_IMAGE)
                NUKE(IMAGE_URL: KOREAN_URL ?? "", PLACEHOLDER: UIImage(named: "clear.png")!, PROFILE: CELL.MEDIA_IMAGE, FRAME_VIEW: COLLECTIONVIEW, SCALE: .scaleAspectFit)
            // 동영상
            } else if DATA.MEDIA_TYPE == "v" {
                
                CELL.MEDIA_IMAGE.frame = CELL.bounds
                CELL.addSubview(CELL.MEDIA_IMAGE)
                if DATA.MEDIA_FILES.contains("_media1.mp4") {
                    let MEDIA_FILE = DATA.MEDIA_FILES.replacingOccurrences(of: "%2520", with: "%20").replacingOccurrences(of: "_media1.mp4", with: "_mplayer1_1.png")
                    NUKE(IMAGE_URL: MEDIA_FILE, PLACEHOLDER: UIImage(named: "clear.png")!, PROFILE: CELL.MEDIA_IMAGE, FRAME_VIEW: COLLECTIONVIEW, SCALE: .scaleAspectFit)
                } else {
                    CELL.MEDIA_IMAGE.image = VIDEO_THUMBNAIL(DATA.MEDIA_FILES.replacingOccurrences(of: "%2520", with: "%20"))
                }
                
                let PLAY = UIImageView()
                PLAY.frame = CGRect(x: collectionView.frame.width / 2 - 24.0, y: collectionView.frame.height / 2 - 24.0, width: 48.0, height: 48.0)
                PLAY.image = UIImage(named: "play.png")
                CELL.addSubview(PLAY)
            // 유튜브
            } else if DATA.MEDIA_TYPE == "y" {
                
                CELL.MEDIA_VIEW.frame = CELL.bounds
                CELL.addSubview(CELL.MEDIA_VIEW)
                CELL.MEDIA_VIEW.load(withVideoId: DATA.FILE_NAME)
            }
        }
        
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // STATUS바
        if SELECT {
            SELECT = false
            UIView.animate(withDuration: 0.3, animations: {
                self.NAVI_BG.alpha = 0.0
                self.PAGE_BG.alpha = 0.0
                self.STATUS_BAR_HIDDEN = true
                self.setNeedsStatusBarAppearanceUpdate()
            })
        } else {
            SELECT = true
            UIView.animate(withDuration: 0.3, animations: {
                self.NAVI_BG.alpha = 1.0
                self.PAGE_BG.alpha = 1.0
                self.STATUS_BAR_HIDDEN = false
                self.setNeedsStatusBarAppearanceUpdate()
            })
        }
        
        // 동영상
        VIDIO_PLAYER(MEDIA_LIST: MEDIA_LIST, TAG: indexPath.item)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // 진동 이벤트
        UIImpactFeedbackGenerator().impactOccurred()
        
        let PAGE = Int(targetContentOffset.pointee.x / COLLECTIONVIEW.frame.width)
        PAGE_NUM.text = "\(PAGE+1) / \(MEDIA_LIST.count)"
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

extension DETAIL_IMAGE: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: COLLECTIONVIEW.frame.size.width, height: COLLECTIONVIEW.frame.size.height)
    }
}

