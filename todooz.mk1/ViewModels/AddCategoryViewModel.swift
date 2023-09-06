//
//  TodoListViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import Foundation

class AddCategoryViewModel: ObservableObject {
    
    
    
    @Published var letPickDate: Bool = false
    @Published var letPickDateAndTime: Bool = false
    
    @Published var name: String = ""
  
    @Published var description: String = ""
  
   
    
    func formIsValid() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        return true
    }
    
    func save() async throws {
        
        try await CategoryService.shared.createCategory(name: self.name, description: self.description, iconColor: "*7384djd")
    
        
        
    }
    
    
    
    
    
    
}
