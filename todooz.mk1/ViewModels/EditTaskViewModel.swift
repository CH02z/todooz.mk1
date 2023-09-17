//
//  TodoListViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import Foundation
import FirebaseFirestoreSwift

class EditTaskViewModel: ObservableObject {
    
    
    //Due Date
    @Published var letPickDate: Bool = false
    @Published var letPickDateAndTime: Bool = false
    
    //Reminder
    @Published var useReminder: Bool = false
    @Published var selectedUnit: String = "Hours"
    @Published var reminderUnits: [String] = ["Days", "Hours", "Minutes"]
    @Published var reminderValue: Int = 1
    @Published var notificationID: String = ""
    
    //subtaks
    @Published var subtasks: [SubTasc] = []
    @Published var addedSubtaskTitle: String = ""
    @Published var useSubtasks: Bool = false
    
    
    @Published var taskID: String = ""
    @Published var title: String = ""
    @Published var dueDate: Date = Date()
    @Published var description: String = ""
    @Published var isHighPriority: Bool = false
    @Published var isMarked: Bool = false
    
    @Published var categorySelection = ""
    
    
    
    @Published var errorMessage: String = ""
    
    
    init(taskID: String,
         title: String,
         category: String,
         dueDate: String,
         description: String,
         insubtasks: [SubTasc],
         isHighPriority: Bool,
         isMarked: Bool,
         notificationID: String,
         reminderUnit: String,
         reminderValue: Int) {
        //print("selection set to \(originalCat)")
        self.taskID = taskID
        self.title = title
        if dueDate != "" {
            self.letPickDate = true
                        if dueDate.count > 12 {
                self.letPickDateAndTime = true
            }
            self.dueDate = getDateFromString(dateString: dueDate)
        }
        //Check if task has reminders
        if notificationID != "" {
            self.notificationID = notificationID
            self.useReminder = true
            self.selectedUnit = reminderUnit
            self.reminderValue = reminderValue
            
        }
        //check if task has subtasks
        if insubtasks.count > 0 {
            self.useSubtasks = true
            self.subtasks = insubtasks
        }
        
        
        
        self.description = description
        self.isHighPriority = isHighPriority
        self.isMarked = isMarked
        self.categorySelection = category
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
    
    @MainActor
    func save() async throws {
        
        if self.useReminder {
            let notificationDate = getSubtractedDate(unit: self.selectedUnit, value: self.reminderValue, inputDate: self.dueDate)
            //Delete Existing Notification First:
            NotificationHandler.shared.removeNotifications(ids: [self.notificationID])
            
            //create new Notifaction ID
            self.notificationID = UUID().uuidString
            
            NotificationHandler.shared.scheduleNotificationWithDate(id: self.notificationID, title: "Task fällig in: \(self.reminderValue) \(self.selectedUnit)", subtitle: self.title, date: notificationDate)
        } else {
            //Delete Existing Notification if toggle is off
            self.notificationID = ""
            self.reminderValue = 0
            NotificationHandler.shared.removeNotifications(ids: [self.notificationID])
            try await TaskService.shared.removeReminderFromTask(taskID: self.taskID)
        }
        
        if !self.useSubtasks {
            //remove existing subtask
            self.subtasks = []
            self.addedSubtaskTitle = ""
            try await TaskService.shared.removeSubtaskFromTask(taskID: self.taskID)
            
        }
        
        
        
        if self.letPickDate && !self.letPickDateAndTime {
            //Date without Time gets inserted
            print("one was")
            let DateNoTime = self.dueDate.removeTimeStamp()
            let DateString = getStringFromDate(date: DateNoTime!, dateFormat: "dd.MM.yyyy")
            try await TaskService.shared.editTask(taskID: self.taskID, title: self.title, category: self.categorySelection, subtasks: self.subtasks, dueDate: DateString, description: self.description, isHighPriority: self.isHighPriority, isMarked: self.isMarked, notificationID: self.notificationID, reminderUnit: self.selectedUnit, reminderValue: self.reminderValue)
        }
        
        if self.letPickDate && self.letPickDateAndTime {
            //Date with Time gets inserted
            //"d MMM YY, HH:mm:ss"
            print("two was")
            let DateTimeString = getStringFromDate(date: self.dueDate, dateFormat: "dd.MM.yyyy, HH:mm")
            try await TaskService.shared.editTask(taskID: self.taskID, title: self.title, category: self.categorySelection, subtasks: self.subtasks, dueDate: DateTimeString, description: self.description, isHighPriority: self.isHighPriority, isMarked: self.isMarked, notificationID: self.notificationID, reminderUnit: self.selectedUnit, reminderValue: self.reminderValue)
        }
        
        if !self.letPickDate {
            //Task without any DueDate is Created
            print("edit task and remove date / time \(self.dueDate)")
            try await TaskService.shared.editTask(taskID: self.taskID, title: self.title, category: self.categorySelection, subtasks: self.subtasks, dueDate: "", description: self.description, isHighPriority: self.isHighPriority, isMarked: self.isMarked, notificationID: self.notificationID, reminderUnit: self.selectedUnit, reminderValue: self.reminderValue)
            
            //Delete Existing Notification if toggle is off
            NotificationHandler.shared.removeNotifications(ids: [self.notificationID])
            try await TaskService.shared.removeReminderFromTask(taskID: self.taskID)
            
        }
    
        
        
    }
    
    func reminderDateisPastDate() -> Bool {
        let notificationDate = getSubtractedDate(unit: self.selectedUnit, value: self.reminderValue, inputDate: self.dueDate)
        return notificationDate < Date()
    }
    
    func moveSubtask(source: IndexSet, destination: Int){
        self.subtasks.move(fromOffsets: source, toOffset: destination)
    }
    
    
    
    
    
    
}
