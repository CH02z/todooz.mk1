//
//  User.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import Foundation
import SwiftUI

struct Category: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    var description: String?
    var iconColor: String?
    let dateCreated: String?
    var lastModified: String?
    var numberOfTasks: Int?
}

func getCurrentDateString() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM YY, HH:mm:ss"
    return dateFormatter.string(from: date)
}

func getStringFromDate(date: Date, dateFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.string(from: date)
}

func getDateFromString(dateString: String) -> Date {
    let dateFormatter = DateFormatter()
    if dateString.count > 11 {
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
    } else {
        print("Dateformater in short format set")
        dateFormatter.dateFormat = "dd.MM.yyyy"
    }
    //"dd.MM.yyyy"
    //"dd.MM.yyyy, HH:mm"
    
    //print("print in Dateformater: \(dateFormatter.date(from: dateString) ?? Date())")
    print("input String: \(dateString) and Date objecct produded: \(dateFormatter.date(from: dateString))")
    return dateFormatter.date(from: dateString) ?? Date()
}

func isSameDay(date1: Date, date2: Date) -> Bool {
    let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
    if diff.day == 0 {
        return true
    } else {
        return false
    }
}


class TestData {
    static let categories: [Category] = [
        Category(id: "dkfjddk213", name: "Swisscom", dateCreated: getCurrentDateString(), lastModified: getCurrentDateString(), numberOfTasks: 3),
        Category(id: "dkfj2334343?k213", name: "Privat",dateCreated: getCurrentDateString(), lastModified: getCurrentDateString(), numberOfTasks: 2),
        Category(id: "dfadsfdsaf34%&/&(", name: "Allgemein", dateCreated: getCurrentDateString(), lastModified: getCurrentDateString(), numberOfTasks: 0),
        Category(id: "dfzerzsfdsaf3!!!/&(", name: "Todooz", dateCreated: getCurrentDateString(), lastModified: getCurrentDateString(), numberOfTasks: 0)
    ]
    
    static let todos: [Tasc] = [
        Tasc(id: "dkjfkdj34324", title: "Server bestellen", category: "Swisscom", dueDate: getCurrentDateString(), isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false),
        Tasc(id: "dfadf684923!", title: "CR1 neu starten", category: "Swisscom", dueDate: getCurrentDateString(), isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false),
        Tasc(id: "dfdjf382!", title: "Runner Session mit Cina", category: "Swisscom", dueDate: "", isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false),
        Tasc(id: "dfdjfkl7238dffdf!", title: "Schritte sammeln", category: "Privat", dueDate: getCurrentDateString(), isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false),
        Tasc(id: "df&&/fkl72382!", title: "E-Vignette bestellen", category: "Privat", dueDate: "", isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false)
    ]
    
    
}



