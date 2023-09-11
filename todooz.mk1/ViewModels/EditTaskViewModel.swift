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
    
    
    private func getDateFromString2(dateString: String) -> Date {
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
    
    init(taskID: String, title: String, category: String, dueDate: String, description: String, isHighPriority: Bool) {
        //print("selection set to \(originalCat)")
        self.taskID = taskID
        self.title = title
        if dueDate != "" {
            self.letPickDate = true
                        if dueDate.count > 12 {
                self.letPickDateAndTime = true
            }
            self.dueDate = self.getDateFromString2(dateString: dueDate)
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
            guard dueDate > Date() else { return false }
        }
        
        return true
    }
    
    func save() async throws {
        
        if self.letPickDate && !self.letPickDateAndTime {
            //Date without Time gets inserted
            let DateNoTime = self.dueDate.removeTimeStamp()
            let DateString = getStringFromDate(date: DateNoTime!, dateFormat: "dd.MM.yyyy")
            try await TaskService.shared.editTask(taskID: self.taskID, title: self.title, category: self.categorySelection, dueDate: DateString, description: self.description, isHighPriority: self.isHighPriority)
        }
        
        if self.letPickDate && self.letPickDateAndTime {
            //Date with Time gets inserted
            //"d MMM YY, HH:mm:ss"
            let DateTimeString = getStringFromDate(date: self.dueDate, dateFormat: "dd.MM.yyyy, HH:mm")
            try await TaskService.shared.editTask(taskID: self.taskID, title: self.title, category: self.categorySelection, dueDate: DateTimeString, description: self.description, isHighPriority: self.isHighPriority)
        }
        
        if !self.letPickDate && !self.letPickDateAndTime {
            //Task without any DueDate is Created
            try await TaskService.shared.editTask(taskID: self.taskID, title: self.title, category: self.categorySelection, dueDate: "", description: self.description, isHighPriority: self.isHighPriority)
            
        }
    
        
        
    }
    
    
    
    
    
    
}
