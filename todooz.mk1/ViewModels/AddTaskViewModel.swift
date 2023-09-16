//
//  TodoListViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import Foundation
import FirebaseFirestoreSwift
import UserNotifications

class AddTaskViewModel: ObservableObject {
    
    
    //Due Date
    @Published var letPickDate: Bool = false
    @Published var letPickDateAndTime: Bool = false
    
    //Reminder
    @Published var useReminder: Bool = false
    @Published var selectedUnit: String = "Hours"
    @Published var reminderUnits: [String] = ["Days", "Hours", "Minutes"]
    @Published var reminderValue: Int = 1
    @Published var notificationID: String = ""
    
    
    @Published var taskID: String = ""
    
    @Published var title: String = ""
    @Published var dueDate: Date = Date()
    @Published var description: String = ""
    @Published var isHighPriority: Bool = false
    @Published var isMarked: Bool = false
    
    @Published var categorySelection = ""
    
    
    
    @Published var errorMessage: String = ""
    
    init(originalCat: String) {
        print("selection set to \(originalCat)")
        self.categorySelection = originalCat
    }
    
    func formIsValid() -> Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        if letPickDate {
            guard dueDate >= Calendar.current.date(byAdding: .minute, value: -5, to: Date())! else { return false }
        }
        
        if useReminder {
            
            guard !self.reminderDateisPastDate() else { return false }
        }
        
        return true
    }
    
    func save() async throws {
        
        if self.useReminder {
            let notificationDate = getSubtractedDate(unit: self.selectedUnit, value: self.reminderValue, inputDate: self.dueDate)
            //set Notification
            self.notificationID = UUID().uuidString
            NotificationHandler.shared.scheduleNotificationWithDate(id: self.notificationID, title: "Task fällig in: \(self.reminderValue) \(self.selectedUnit)", subtitle: self.title, date: notificationDate)
        }
        
        
        if self.letPickDate && !self.letPickDateAndTime {
            //Date without Time gets inserted
            let DateNoTime = self.dueDate.removeTimeStamp()
            let DateString = getStringFromDate(date: DateNoTime!, dateFormat: "dd.MM.yyyy")
            try await TaskService.shared.createTask(title: self.title, category: self.categorySelection, dueDate: DateString, description: self.description, isHighPriority: self.isHighPriority, isMarked: self.isMarked, notificationID: self.notificationID, reminderUnit: self.selectedUnit, reminderValue: self.reminderValue)
        }
        
        if self.letPickDate && self.letPickDateAndTime {
            //Date with Time gets inserted
            //"d MMM YY, HH:mm:ss"
            let DateTimeString = getStringFromDate(date: self.dueDate, dateFormat: "dd.MM.yyyy, HH:mm")
            try await TaskService.shared.createTask(title: self.title, category: self.categorySelection, dueDate: DateTimeString, description: self.description, isHighPriority: self.isHighPriority, isMarked: self.isMarked, notificationID: self.notificationID, reminderUnit: self.selectedUnit, reminderValue: self.reminderValue)
        }
        
        if !self.letPickDate {
            //Task without any DueDate is Created
            try await TaskService.shared.createTask(title: self.title, category: self.categorySelection, dueDate: "", description: self.description, isHighPriority: self.isHighPriority, isMarked: self.isMarked, notificationID: self.notificationID, reminderUnit: self.selectedUnit, reminderValue: self.reminderValue)
            
        }
        
    }
    
    func reminderDateisPastDate() -> Bool {
        let notificationDate = getSubtractedDate(unit: self.selectedUnit, value: self.reminderValue, inputDate: self.dueDate)
        return notificationDate < Date()
    }
    
    
    
    
    
}
