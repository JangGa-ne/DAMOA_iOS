//
//  SETTING_UNIQ.swift
//  GYEONGGI-EDU-DREAMTREE
//
//  Created by 장 제현 on 2020/12/19.
//

import UIKit

//MARK: - SC_CODE 중복체크
extension UIViewController {
    
    func UNIQ<S : Sequence, T : Hashable>(SOURCE: S) -> [T] where S.Iterator.Element == T {
        var BUFFER = [T]()
        var ADDED = Set<T>()
        for DATA in SOURCE { if !ADDED.contains(DATA) { BUFFER.append(DATA); ADDED.insert(DATA) } }
        return BUFFER
    }
}
