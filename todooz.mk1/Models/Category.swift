//
//  User.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import Foundation
import SwiftUI

struct Category: Codable {
    let id: String
    let name: String
    var iconColor: String?
    let dateCreated: String?
    var lastModified: String?
}

func getCurrentDateString() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM YY, HH:mm:ss"
    return dateFormatter.string(from: date)
}




class TestData {
    static let categories: [Category] = [
        Category(id: "dkfjddk213", name: "Swisscom", dateCreated: getCurrentDateString(), lastModified: getCurrentDateString()),
        Category(id: "dkfj2334343?k213", name: "Privat",dateCreated: getCurrentDateString(), lastModified: getCurrentDateString()),
        Category(id: "dfadsfdsaf34%&/&(", name: "allgemein", dateCreated: getCurrentDateString(), lastModified: getCurrentDateString())
    ]
    
    static let todos: [Tasc] = [
        Tasc(id: "dkjfkdj34324", title: "Server bestellen", category: "Swisscom", dueDate: getCurrentDateString(), isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false),
        Tasc(id: "dfadf684923!", title: "CR1 neu starten", category: "Swisscom", dueDate: getCurrentDateString(), isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false),
        Tasc(id: "dfdjf382!", title: "Runner Session mit Cina", category: "Swisscom", dueDate: getCurrentDateString(), isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false),
        Tasc(id: "dfdjfkl7238dffdf!", title: "Schritte sammeln", category: "Privat", dueDate: getCurrentDateString(), isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false),
        Tasc(id: "df&&/fkl72382!", title: "E-Vignette bestellen", category: "Privat", dueDate: getCurrentDateString(), isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false)
    ]
    
    
}



