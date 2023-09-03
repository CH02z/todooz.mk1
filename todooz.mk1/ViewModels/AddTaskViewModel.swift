//
//  TodoListViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import Foundation

class AddTaskViewModel: ObservableObject {
    
    
    @Published var title: String = ""
    @Published var dueDate: Date = Date()
    @Published var description: String = ""
    @Published var isHighPriority: Bool = false
    
    @Published var categorySelection = ""
    
    let TestCategories = ["Swisscom", "Privat", "allgemein"]
    
    
    
    @Published var errorMessage: String = ""
    
    init(category: Category) {
        self.categorySelection = category.name
    }
    
    func formIsValid() -> Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        guard dueDate > Date() else {
            return false
        }
        
        return true
    }
    
    func save() async throws {
    
        try await TaskService.shared.createTask(title: self.title, category: self.categorySelection, dueDate: self.dueDate, description: self.description, isHighPriority: self.isHighPriority)
        
    }
    
    
    
    
}
