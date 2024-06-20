//
//  SETTING_COREDATA.swift
//  busan-damoa
//
//  Created by 장 제현 on 2021/03/08.
//  Copyright © 2021 장제현. All rights reserved.
//

import UIKit
import CoreData

//MARK: COREDATA
extension AppDelegate {
    
    // 데이터를 읽어올 메소드
    func COREDATA_FETCH(ENTITY_NAME: String) -> [NSManagedObject] {
        
        // 관리 객체 컨텍스트 참조
        let CONTEXT = PERSISTENT_CONTAINER.viewContext
        // 요청 객체 생성
        let FETCH_REQUEST = NSFetchRequest<NSManagedObject>(entityName: ENTITY_NAME)
        // 데이터 가져오기
        let RESULT = try! CONTEXT.fetch(FETCH_REQUEST)
        
        return RESULT
    }
    
    func ENROLL_SAVE(SC_LOGO: String, SC_CODE: String, SC_GRADE: String, SC_GROUP: String, SC_LOCATION: String, SC_NAME: String, SC_ADDRESS: String, CL_CODE: String, CLASS_NAME: String) -> Bool {
        
        // 관리 객체 건텍트 참조
        let CONTEXT = PERSISTENT_CONTAINER.viewContext
        // 관리 객체 생성 & 값을 설정
        let OBJECT = NSEntityDescription.insertNewObject(forEntityName: "ENROLL_LIST", into: CONTEXT)
        
        OBJECT.setValue(SC_LOGO, forKey: "sc_logo")
        OBJECT.setValue(SC_CODE, forKey: "sc_code")
        OBJECT.setValue(SC_GRADE, forKey: "sc_grade")
        OBJECT.setValue(SC_GROUP, forKey: "sc_group")
        OBJECT.setValue(SC_LOCATION, forKey: "sc_location")
        OBJECT.setValue(SC_NAME, forKey: "sc_name")
        OBJECT.setValue(SC_ADDRESS, forKey: "sc_locate")
        OBJECT.setValue(CL_CODE, forKey: "cl_code")
        OBJECT.setValue(CLASS_NAME, forKey: "class_name")
        // 데이터 추가
        ENROLL_LIST.append(OBJECT)
        
        do { try CONTEXT.save(); return true } catch { CONTEXT.rollback(); return false }
    }
    
    func DELETE(OBJECT: NSManagedObject) -> Bool {
        
        // 관리 객체 건텍트 참조
        let CONTEXT = PERSISTENT_CONTAINER.viewContext
        // 데이터 삭제
        CONTEXT.delete(OBJECT)
        
        do { try CONTEXT.save(); return true } catch { CONTEXT.rollback(); return false }
    }
    
    func DELETE_ALL(_ ENTITY: String) {
        
        // 관리 객체 컨텍스트 참조
        let CONTEXT = PERSISTENT_CONTAINER.viewContext
        // 요청 객체 생성
        let FETCH_REQUEST = NSFetchRequest<NSFetchRequestResult>()
        FETCH_REQUEST.entity = NSEntityDescription.entity(forEntityName: ENTITY, in: CONTEXT)
        FETCH_REQUEST.includesPropertyValues = false
        
        if let RESULTS = try! CONTEXT.fetch(FETCH_REQUEST) as? [NSManagedObject] {

            // 데이터 삭제
            for RESULT in RESULTS { CONTEXT.delete(RESULT) }
            ENROLL_LIST.removeAll()
            
            do { try CONTEXT.save() } catch { CONTEXT.rollback() }
        }
    }
}
