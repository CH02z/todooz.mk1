//
//  TestData.swift
//
//  Created by Chris Zimmermann on 13.09.23.
//

import Foundation
import SwiftUI

class TestData {
    static let categories: [Category] = [
        Category(id: "dkfjddk213", name: "Swisscom", dateCreated: getCurrentDateString(), lastModified: getCurrentDateString()),
        Category(id: "dkfj2334343?k213", name: "Privat",dateCreated: getCurrentDateString(), lastModified: getCurrentDateString()),
        Category(id: "dfadsfdsaf34%&/&(", name: "Allgemein", dateCreated: getCurrentDateString(), lastModified: getCurrentDateString()),
        Category(id: "dfzerzsfdsaf3!!!/&(", name: "Todooz", dateCreated: getCurrentDateString(), lastModified: getCurrentDateString())
    ]
    
    static let tasks: [Tasc] = [
        Tasc(id: "dkjfkdj34324", title: "Server bestellen", category: "Swisscom", dueDate: getCurrentDateString(), isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false, isMarked: false, notificationID: "", reminderUnit: "", reminderValue: 0),
        Tasc(id: "dfadf684923!", title: "CR1 neu starten", category: "Swisscom", dueDate: getCurrentDateString(), isDone: false, description: "TAfkdfjdlkfjdjfkdkfjdjfdlkjfkdjflkjdjfjdjfdjflk jdfjdjfjdsafjdslkjflkdjfjdkljflkdjf", dateCreated: getCurrentDateString(), isHighPriority: false, isMarked: false, notificationID: "", reminderUnit: "", reminderValue: 0),
        Tasc(id: "dfdjf382!", title: "Runner Session mit Cina", category: "Swisscom", dueDate: "", isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false, isMarked: false, notificationID: "", reminderUnit: "", reminderValue: 0),
        Tasc(id: "dfdjfkl7238dffdf!", title: "Schritte sammeln", category: "Privat", dueDate: getCurrentDateString(), isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false, isMarked: false, notificationID: "", reminderUnit: "", reminderValue: 0),
        Tasc(id: "df&&/fkl72382!", title: "E-Vignette bestellen", category: "Privat", dueDate: "", isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false, isMarked: false, notificationID: "", reminderUnit: "", reminderValue: 0)
    ]
    
    static let users: [User] = [
        User(id: "234j3i4j34kl3j43l", firstName: "Chris", lastName: "Zimmermann", email: "chris.zimmermann@hotmail.ch", joined: Date().timeIntervalSince1970)
    ]
    
    static let quickNotes: [QuickNote] = [
        QuickNote(id: "kdjf!kjasfe43kl3j", text: "Mehr output weniger inpute", noteColor: "E8F1A1", dateCreated: getStringFromDate(date: Date(), dateFormat: "dd.MM.yyyy")),
        QuickNote(id: "kdjfkjasdfsdffe43as", text: "It doesn get easier you get better", noteColor: "BB9EFA", dateCreated: getStringFromDate(date: Date(), dateFormat: "dd.MM.yyyy")),
        QuickNote(id: "asdddd23434ssd!dcdsdfdd", text: "Hard times create strong men", noteColor: "FFA37F", dateCreated: getStringFromDate(date: Date(), dateFormat: "dd.MM.yyyy")),
        QuickNote(id: "kdjfkjdffe43as", text: "Listten to your inner Voice", noteColor: "E7BB78", dateCreated: getStringFromDate(date: Date(), dateFormat: "dd.MM.yyyy")),
        QuickNote(id: "asdddfdddcdsdfdd", text: "One More Thing jdfdkjfjadskfjdskajföjdsaklfjlkdsajfkjdsalfjkldsajfkljklwjekljrkljekgjklsdjgjhdshfjehfkjdshvhdsjkvnbkjdshfkjhdkjfdkjhfkjdhfkjdhfkjhdjkfhdkjhfkj", noteColor: "00C6E3", dateCreated: getStringFromDate(date: Date(), dateFormat: "dd.MM.yyyy"))
    
    ]
    
    
}
