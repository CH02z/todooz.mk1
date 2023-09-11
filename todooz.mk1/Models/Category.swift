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
    var icon: String?
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
    if dateString != "" {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "CEST")
        if dateString.count > 11 {
            dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
            let correctHourDate = Calendar.current.date(byAdding: .hour, value: 2, to: dateFormatter.date(from: dateString)!)!
            print("input String: \(dateString) and Date objecct produded: \(correctHourDate))")
            return correctHourDate
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let correctHourDate = Calendar.current.date(byAdding: .hour, value: 2, to: dateFormatter.date(from: dateString)!)!
            return Calendar.current.date(byAdding: .day, value: 1, to: correctHourDate)!
        }
    } else {
        print("empty input datestring, returning date()")
        return Date()
    }

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
        Category(id: "dkfjddk213", name: "Swisscom", dateCreated: getCurrentDateString(), lastModified: getCurrentDateString()),
        Category(id: "dkfj2334343?k213", name: "Privat",dateCreated: getCurrentDateString(), lastModified: getCurrentDateString()),
        Category(id: "dfadsfdsaf34%&/&(", name: "Allgemein", dateCreated: getCurrentDateString(), lastModified: getCurrentDateString()),
        Category(id: "dfzerzsfdsaf3!!!/&(", name: "Todooz", dateCreated: getCurrentDateString(), lastModified: getCurrentDateString())
    ]
    
    static let tasks: [Tasc] = [
        Tasc(id: "dkjfkdj34324", title: "Server bestellen", category: "Swisscom", dueDate: getCurrentDateString(), isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false),
        Tasc(id: "dfadf684923!", title: "CR1 neu starten", category: "Swisscom", dueDate: getCurrentDateString(), isDone: false, description: "TAfkdfjdlkfjdjfkdkfjdjfdlkjfkdjflkjdjfjdjfdjflk jdfjdjfjdsafjdslkjflkdjfjdkljflkdjf", dateCreated: getCurrentDateString(), isHighPriority: false),
        Tasc(id: "dfdjf382!", title: "Runner Session mit Cina", category: "Swisscom", dueDate: "", isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false),
        Tasc(id: "dfdjfkl7238dffdf!", title: "Schritte sammeln", category: "Privat", dueDate: getCurrentDateString(), isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false),
        Tasc(id: "df&&/fkl72382!", title: "E-Vignette bestellen", category: "Privat", dueDate: "", isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false)
    ]
    
    static let users: [User] = [
        User(id: "234j3i4j34kl3j43l", firstName: "Chris", lastName: "Zimmermann", email: "chris.zimmermann@hotmail.ch", joined: Date().timeIntervalSince1970)
    ]
    
    
}



