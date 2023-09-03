//
//  ToDoListItem.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import Foundation

struct Tasc: Codable, Identifiable {
    let id: String
    let title: String
    let category: String
    var dueDate: String
    var isDone: Bool
    var description: String?
    var iconColor: String?
    let dateCreated: String?
    var dateFinished: String?
    let isHighPriority: Bool
}
