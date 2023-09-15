//
//  TodoListViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import Foundation
import FirebaseFirestoreSwift

class EditTaskViewModel: ObservableObject {
    
    
    
    @Published var letPickDate: Bool = false
    @Published var letPickDateAndTime: Bool = false
    
    
    @Published var taskID: String = ""
    @Published var title: String = ""
    @Published var dueDate: Date = Date()
    @Published var description: String = ""
    @Published var isHighPriority: Bool = false
    
    @Published var categorySelection = ""
    
    
    
    @Published var errorMessage: String = ""
    
    
    init(taskID: String, title: String, category: String, dueDate: String, description: String, isHighPriority: Bool) {
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
        self.description = description
        self.isHighPriority = isHighPriority
        self.categorySelection = category
    }
    
    func formIsValid() -> Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        if letPickDate {
            guard dueDate >= Calendar.current.date(byAdding: .minute, value: -5, to: Date())! else { return false }
        }
        
        return true
    }
    
    func save() async throws {
        
        if self.letPickDate && !self.letPickDateAndTime {
            //Date without Time gets inserted
            print("one was")
            let DateNoTime = self.dueDate.removeTimeStamp()
            let DateString = getStringFromDate(date: DateNoTime!, dateFormat: "dd.MM.yyyy")
            try await TaskService.shared.editTask(taskID: self.taskID, title: self.title, category: self.categorySelection, dueDate: DateString, description: self.description, isHighPriority: self.isHighPriority)
        }
        
        if self.letPickDate && self.letPickDateAndTime {
            //Date with Time gets inserted
            //"d MMM YY, HH:mm:ss"
            print("two was")
            let DateTimeString = getStringFromDate(date: self.dueDate, dateFormat: "dd.MM.yyyy, HH:mm")
            try await TaskService.shared.editTask(taskID: self.taskID, title: self.title, category: self.categorySelection, dueDate: DateTimeString, description: self.description, isHighPriority: self.isHighPriority)
        }
        
        if !self.letPickDate {
            //Task without any DueDate is Created
            print("edit task and remove date / time \(self.dueDate)")
            try await TaskService.shared.editTask(taskID: self.taskID, title: self.title, category: self.categorySelection, dueDate: "", description: self.description, isHighPriority: self.isHighPriority)
            
        }
    
        
        
    }
    
    
    
    
    
    
}
