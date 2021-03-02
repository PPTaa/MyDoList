//
//  MydoViewModel.swift
//  MyDoList
//
//  Created by leejungchul on 2021/03/02.
//

import Foundation

class MydoViewModel {
    
    enum Section: Int, CaseIterable {
        case today, upcoming
        var title: String {
            switch self {
            case .today:
                return "Today"
            default:
                return "Upcoming"
            }
        }
    }
    
    private let manager = MydoManager.shared
    
    var mydos: [Mydo] {
        return manager.mydos
    }
    var todayMydos: [Mydo]{
        return mydos.filter{$0.isToday == true}
    }
    var upcomingMydos: [Mydo]{
        return mydos.filter{$0.isToday == false}
    }
    var numOfSection: Int {
        return Section.allCases.count
    }
    func addMydo(_ mydo: Mydo) {
        manager.addMydo(mydo)
    }
    func deleteMydo(_ mydo: Mydo) {
        manager.deleteMydo(mydo)
    }
    func updateMydo(_ mydo: Mydo) {
        manager.updateMydo(mydo)
    }
    func loadTasks() {
        manager.retrieveMydo()
    }
    
    
}
