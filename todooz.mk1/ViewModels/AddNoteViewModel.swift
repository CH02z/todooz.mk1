//
//  TodoListViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import Foundation
import SwiftUI

class AddNoteViewModel: ObservableObject {
    
    
    @Published var text: String = ""
  
    
    let colors: [String] = ["E8F1A1", "BB9EFA", "FFA37F", "E7BB78", "00C6E3"]
    @Published var selectedColor: String = "E8F1A1"
    
    
    func formIsValid() -> Bool {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        return true
        
    }
    
    func save() async throws {
        try await NoteService.shared.createNote(text: self.text, noteColor: self.selectedColor)
    }
    

    
}
