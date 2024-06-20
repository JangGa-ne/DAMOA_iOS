//
//  SETTING_TEXT.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/19.
//

import UIKit

//MARK: - 텍스트 레이아웃 보조 및 인코딩 작업 처리
extension UIViewController {
    
    // 힌트
    func PLACEHOLDER(TF: UITextField, PH: String) {
        
        TF.attributedPlaceholder = NSAttributedString(string: PH, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    // 인코딩
    func ENCODE(_ DECODE_TEXT: String) -> String {
        
        var TEXT: String = ""
        
        if DECODE_TEXT == "" {
            
            return "-"
        } else {
            
            let BASE64 = Data(base64Encoded: DECODE_TEXT, options: [])
            if let BASE64 = BASE64 {
                TEXT = String(data: BASE64, encoding: .utf8) ?? "UTF8 오류 처리중 . . ."
            } else {
                TEXT = DECODE_TEXT
            }
            
            let SPECIAL_CHAR = TEXT.replacingOccurrences(of: "\\", with: "").replacingOccurrences(of: "&apos;", with: "").replacingOccurrences(of: "?", with: "")
            
            return SPECIAL_CHAR
        }
    }
    
    // 줄간격
    func LINE_SPACING(TEXT: String, LINE_SPACING: CGFloat) -> NSAttributedString {
        
        let STRING = NSMutableAttributedString(string: TEXT)
        let STYLE = NSMutableParagraphStyle()
        STYLE.lineSpacing = LINE_SPACING
        STRING.addAttribute(NSAttributedString.Key.paragraphStyle, value: STYLE, range: NSMakeRange(0, STRING.length) )
        
        return STRING
    }
    
    // HTML
    func HTML_STRING(_ TEXT: String) -> String? {
        
        var ATTRIBUTED: NSAttributedString? = nil
        do {
            if let DATA = TEXT.data(using: .unicode) {
                ATTRIBUTED = try NSAttributedString(data: DATA, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            }
        } catch {
            
        }
        
        return ATTRIBUTED?.string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func HTML_STRING_DETAIL(_ TEXT: String, _ WIDTH: CGFloat) -> NSAttributedString? {
        
        var ATTRIBUTED: NSAttributedString? = nil
        do {
            if let DATA = TEXT.data(using: .unicode) {
                ATTRIBUTED = try NSAttributedString(data: DATA, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            }
        } catch {
            
        }
        
        return ATTRIBUTED?.TEXTVIEW_IMAGE_MAX_WIDTH(WIDTH: WIDTH)
    }
}

extension UITextField {
    
    // 왼쪽 패딩
    public func PADDING_LEFT(X: CGFloat) {
    
        let PADDINGVIEW = UIView(frame: CGRect(x: 0, y: 0, width: X, height: frame.height))
        
        leftView = PADDINGVIEW
        leftViewMode = ViewMode.always
    }
}

extension NSAttributedString {
    
    // HTML 이미지 Width 100%
    func TEXTVIEW_IMAGE_MAX_WIDTH(WIDTH MAX_WIDTH: CGFloat) -> NSAttributedString {
        
        let TEXT = NSMutableAttributedString(attributedString: self)
        TEXT.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, TEXT.length), options: .init(rawValue: 0), using: { (value, range, stop) in
            if let ATTACHEMENT = value as? NSTextAttachment {
                let IMAGE = ATTACHEMENT.image(forBounds: ATTACHEMENT.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                if IMAGE.size.width > MAX_WIDTH {
                    let NEW_IMAGE = IMAGE.RESIZE_IMAGE(SCALE: MAX_WIDTH/IMAGE.size.width)
                    let NEW_ATTRIBUT = NSTextAttachment()
                    NEW_ATTRIBUT.image = NEW_IMAGE
                    TEXT.addAttribute(NSAttributedString.Key.attachment, value: NEW_ATTRIBUT, range: range)
                }
            }
        })
        
        return TEXT
    }
}

extension UIImage {
    
    func RESIZE_IMAGE(SCALE: CGFloat) -> UIImage {
        
        let NEW_SIZE = CGSize(width: self.size.width * SCALE, height: self.size.height * SCALE)
        let RECT = CGRect(origin: CGPoint.zero, size: NEW_SIZE)

        UIGraphicsBeginImageContext(NEW_SIZE)
        self.draw(in: RECT)
        let NEW_IMAGE = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return NEW_IMAGE!
    }
}
