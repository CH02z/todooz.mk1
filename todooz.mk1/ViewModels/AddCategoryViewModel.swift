//
//  TodoListViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import Foundation
import SwiftUI

class AddCategoryViewModel: ObservableObject {
    
    
    
    @Published var letPickDate: Bool = false
    @Published var letPickDateAndTime: Bool = false
    
    @Published var name: String = ""
  
    @Published var description: String = ""
    
    let colors: [String] = ["F2503F", "FFDB43", "F8A535", "B35AEF", "3380FE", "5857E3", "63D163", "83E7E3", "000000"]
    @Published var selectedColor: String = "3380FE"
    
    let icons: [String] = ["list.bullet", "car.fill", "house.fill", "person.fill", "dumbbell.fill", "desktopcomputer", "cart", "dollarsign", "airplane", "cellularbars"]
    @Published var selectedIcon: String = "list.bullet"
  
   
    
    func formIsValid() -> Bool {
        //print(Color(.purple).toHex())
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        return true
    }
    
    func save() async throws {
        
        try await CategoryService.shared.createCategory(name: self.name, description: self.description, iconColor: self.selectedColor, icon: self.selectedIcon)
   
    }
    
   
    
    
    
    
    
}
