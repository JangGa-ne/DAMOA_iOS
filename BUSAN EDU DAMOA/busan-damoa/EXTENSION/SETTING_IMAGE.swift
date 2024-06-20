//
//  SETTING_IMAGE.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/21.
//

import UIKit
import Nuke
import AVKit
import Alamofire

//MARK: - 이미지 설정
extension UIViewController {
    
    // 이미지 비동기화
    func NUKE(IMAGE_URL: String, PLACEHOLDER: UIImage, PROFILE: UIImageView, FRAME_VIEW: UIView, SCALE: UIView.ContentMode) {
        
        ImageCache.shared.removeAll()
        
        let REQUEST = ImageRequest(url: URL(string: IMAGE_URL)!, processors: [ImageProcessor.Resize(size: CGSize(width: FRAME_VIEW.frame.size.width, height: FRAME_VIEW.frame.size.height))])
        let OPTIONS = ImageLoadingOptions(placeholder: PLACEHOLDER, contentModes: .init(success: SCALE, failure: .scaleAspectFit, placeholder: .scaleAspectFit))
        Nuke.loadImage(with: REQUEST, options: OPTIONS, into: PROFILE)
    }
    
    // 비디오 썸네일
    func VIDEO_THUMBNAIL(_ VIDEO_URL: String) -> UIImage? {

        let ASSET = AVAsset(url: URL(string: VIDEO_URL)!)
        let IMAGE_GENERATOR = AVAssetImageGenerator(asset: ASSET)
        IMAGE_GENERATOR.appliesPreferredTrackTransform = true
        let TIME = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
            
        do {
            let CG_IMAGE = try IMAGE_GENERATOR.copyCGImage(at: TIME, actualTime: nil)
            let THUMBNAIL = UIImage(cgImage: CG_IMAGE)
            
            return THUMBNAIL
        } catch {
            /* error handling here */
        }
        
        return nil
    }
    
    // 비디오 플레이어
    func VIDIO_PLAYER(MEDIA_LIST: [ATTACHED], TAG: Int) {
        
        let DATA = MEDIA_LIST[TAG]
        
        if DATA.MEDIA_TYPE == "v" && DATA.MEDIA_FILES != "" {
                
            let PLAYER = AVPlayer(url: URL(string: DATA.MEDIA_FILES)!)
            let PLAYER_VC = AVPlayerViewController()
            
            PLAYER_VC.player = PLAYER
            PLAYER.play()
            present(PLAYER_VC, animated: true, completion: nil)
        }
    }
}

/// 환경설정
extension SETTING: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 프로필이미지추가
    func IMAGE_PICKER(_ SOURCE: UIImagePickerController.SourceType) {
        
        let PICKER = UIImagePickerController()
        PICKER.sourceType = SOURCE
        PICKER.delegate = self
        PICKER.allowsEditing = true
        present(PICKER, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        if let IMAGE = info[UIImagePickerController.InfoKey.editedImage] as? UIImage { PROFILE_IMAGE = IMAGE }
        if let IMAGE_UPLOAD = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            UserDefaults.standard.setValue(IMAGE_UPLOAD.pngData(), forKey: "image_data")
            UserDefaults.standard.synchronize()
        }
        
        let LOGIN_API = UIViewController.APPDELEGATE.LOGIN_API
        if LOGIN_API.count == 0 {
            VIEW_NOTICE("E: 로그인 정보가 없습니다")
        } else {
            if SYSTEM_NETWORK_CHECKING() {
                PUT_POST_DATA(NAME: "환경설정(업데이트)", ACTION_TYPE: "update", MB_NAME: LOGIN_API[0].MB_NAME)
            } else {
                VIEW_NOTICE("N: 네트워크 상태를 확인해 주세요")
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func PUT_POST_DATA(NAME: String, ACTION_TYPE: String, MB_NAME: String) {
        
        let POST_URL: String = DATA_URL().SCHOOL_URL + "member/member.php"
        let PARAMETERS: Parameters = [
            "action_type": ACTION_TYPE,
            "mb_id": UserDefaults.standard.string(forKey: "mb_id") ?? "",
            "mb_name": MB_NAME
        ]
        
        let MANAGER = Alamofire.SessionManager.default
        MANAGER.session.configuration.timeoutIntervalForRequest = 30.0
        MANAGER.upload(multipartFormData: { multipartFormData in
            
            print("[\(NAME)]")
            for (KEY, VALUE) in PARAMETERS {
                print("KEY: \(KEY), VALUE: \(VALUE)")
                multipartFormData.append("\(VALUE)".data(using: .utf8)!, withName: KEY as String)
            }
            if UserDefaults.standard.data(forKey: "image_data") != nil {
                multipartFormData.append(UserDefaults.standard.data(forKey: "image_data")!, withName: "profile_image", fileName: "\(UserDefaults.standard.string(forKey: "mb_id")!).jpg", mimeType: "image/jpg")
            }
        }, to: POST_URL) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON(completionHandler: { response in
                    
//                    print(response)
                    
                    guard let DATA_DICT = response.result.value as? [String: Any] else {
                        print("FAIL: ")
                        return
                    }
                    
                    if DATA_DICT["status"] as? String ?? "" == "COMPLETE" {
                        
                        UIViewController.APPDELEGATE.PF_UPDATE = true
                        UIViewController.APPDELEGATE.LOGIN = false
                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LOADING") as! LOADING
                        VC.modalTransitionStyle = .crossDissolve
                        self.present(VC, animated: true, completion: nil)
                    } else {
                        self.VIEW_NOTICE("F: 프로필 수정 실패")
                    }
                })
            case .failure(let ERROR):
                
                // TIMEOUT
                if ERROR._code == NSURLErrorTimedOut { self.VIEW_NOTICE("E: 서버 연결 실패 (408)") }
                if ERROR._code == NSURLErrorNetworkConnectionLost { self.VIEW_NOTICE("E: 네트워크 연결 실패 (000)") }
                
                self.ALAMOFIRE_ERROR(ERROR: ERROR as? AFError)
            }
        }
    }
}

extension UITableViewCell {
    
    // 이미지 비동기화
    func NUKE(IMAGE_URL: String, PLACEHOLDER: UIImage, PROFILE: UIImageView, FRAME_VIEW: UIView, SCALE: UIView.ContentMode) {
        
        ImageCache.shared.removeAll()
        
        let REQUEST = ImageRequest(url: URL(string: IMAGE_URL)!, processors: [ImageProcessor.Resize(size: CGSize(width: FRAME_VIEW.frame.size.width, height: FRAME_VIEW.frame.size.height))])
        let OPTIONS = ImageLoadingOptions(placeholder: PLACEHOLDER, contentModes: .init(success: SCALE, failure: .scaleAspectFit, placeholder: .scaleAspectFit))
        Nuke.loadImage(with: REQUEST, options: OPTIONS, into: PROFILE)
    }
    
    // 비디오 썸네일
    func VIDEO_THUMBNAIL(_ VIDEO_URL: String) -> UIImage? {

        let ASSET = AVAsset(url: URL(string: VIDEO_URL)!)
        let IMAGE_GENERATOR = AVAssetImageGenerator(asset: ASSET)
        IMAGE_GENERATOR.appliesPreferredTrackTransform = true
        let TIME = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
            
        do {
            let CG_IMAGE = try IMAGE_GENERATOR.copyCGImage(at: TIME, actualTime: nil)
            let THUMBNAIL = UIImage(cgImage: CG_IMAGE)
            
            return THUMBNAIL
        } catch {
            /* error handling here */
        }
        
        return nil
    }
    
    // 비디오 플레이어
    func VIDIO_PLAYER(MEDIA_LIST: [ATTACHED], TAG: Int, PROTOCOL: UIViewController?) {
        
        let DATA = MEDIA_LIST[TAG]
        
        if DATA.MEDIA_TYPE == "v" && DATA.MEDIA_FILES != "" {
            
            let PLAYER = AVPlayer(url: URL(string: DATA.MEDIA_FILES)!)
            let PLAYER_VC = AVPlayerViewController()
            
            PLAYER_VC.player = PLAYER
            PLAYER.play()
            PROTOCOL!.present(PLAYER_VC, animated: true, completion: nil)
        }
    }
}
