//
//  TodoListViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import Foundation

class AddTaskViewModel: ObservableObject {
    
    
    
    @Published var letPickDate: Bool = false
    @Published var letPickDateAndTime: Bool = false
    
    @Published var title: String = ""
    @Published var dueDate: Date = Date()
    @Published var description: String = ""
    @Published var isHighPriority: Bool = false
    
    @Published var categorySelection = ""
    
    let TestCategories = ["Swisscom", "Privat", "Todooz", "Allgemein"]
    
    
    
    @Published var errorMessage: String = ""
    
    init(category: Category) {
        self.categorySelection = category.name
    }
    
    func formIsValid() -> Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        if letPickDate {
            guard dueDate > Date() else { return false }
        }
        
        return true
    }
    
    func save() async throws {
        
        if self.letPickDate && !self.letPickDateAndTime {
            //Date without Time gets inserted
            let DateNoTime = self.dueDate.removeTimeStamp()
            let DateString = getStringFromDate(date: DateNoTime!, dateFormat: "dd.MM.yyyy")
            try await TaskService.shared.createTask(title: self.title, category: self.categorySelection, dueDate: DateString, description: self.description, isHighPriority: self.isHighPriority)
        }
        
        if self.letPickDate && self.letPickDateAndTime {
            //Date with Time gets inserted
            //"d MMM YY, HH:mm:ss"
            let DateTimeString = getStringFromDate(date: self.dueDate, dateFormat: "dd.MM.yyyy, HH:mm")
            try await TaskService.shared.createTask(title: self.title, category: self.categorySelection, dueDate: DateTimeString, description: self.description, isHighPriority: self.isHighPriority)
        }
        
        if !self.letPickDate && !self.letPickDateAndTime {
            //Task without any DueDate is Created
            try await TaskService.shared.createTask(title: self.title, category: self.categorySelection, dueDate: "", description: self.description, isHighPriority: self.isHighPriority)
            
        }
    
        
        
    }
    
    
    
    
    
    
}
