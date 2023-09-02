//
//  TodoListViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import Foundation

class AddTodoViewModel: ObservableObject {
    
    
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
    
    func validateForm() -> Bool {
        return false
        
    }
    
    func save() {
        
    }
    
    
    
    
}
