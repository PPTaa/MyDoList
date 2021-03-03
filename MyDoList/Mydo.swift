//
//  Mydo.swift
//  MyDoList
//
//  Created by leejungchul on 2021/03/02.
//

import Foundation
import UIKit

// Codable,Equatable 추가
struct Mydo:Codable, Equatable {
    let id : Int
    var isDone: Bool
    var detail: String
    var isToday: Bool
    
    mutating func update(isDone:Bool, detail: String, isToday:Bool) {
        // add update logic
        self.isDone = isDone
        self.detail = detail
        self.isToday = isToday
    }
    
    static func == (lhs: Self, rhs:Self) ->Bool {
        // 동등조건 추가 mydo 객체들간의 동등비교를 위해 == 연산자 재정의
        return lhs.id == rhs.id
    }

}

class MydoManager {
    static let shared = MydoManager()
    
    static var lastId: Int = 0
    
    var mydos: [Mydo] = []
    
    func createMydo(detail: String, isToday:Bool) -> Mydo {
        // add create logic
        let nextId = MydoManager.lastId+1
        MydoManager.lastId = nextId
        return Mydo(id: nextId, isDone: false, detail: detail, isToday: isToday)
    }
    
    func addMydo(_ mydo: Mydo) {
        // add add logic
        mydos.append(mydo)
        saveMydo()
    }
    
    func deleteMydo(_ mydo: Mydo) {
        // add delete logic
        if let idx = mydos.firstIndex(of: mydo) {
            mydos.remove(at: idx)
        }
        
//        mydos = mydos.filter{ existingMydo in
//            return existingMydo.id != mydo.id
//        }
        saveMydo()
    }
    
    func updateMydo(_ mydo: Mydo) {
        // add update logic
        guard let idx = mydos.firstIndex(of: mydo) else { return }
        mydos[idx].update(isDone: mydo.isDone, detail: mydo.detail, isToday: mydo.isToday)
        saveMydo()
    }
    
    func saveMydo() {
//        Storage.store(mydos, to: .documents, as: "mydos.json")
    }
    
    func retrieveMydo() {
//        mydos = Storage.retrieve("mydos.json", from: .documents, as:[Mydo].self) ?? []
//
//        let lastId = mydos.last?.id ?? 0
//        MydoManager.lastId = lastId
    }
}
