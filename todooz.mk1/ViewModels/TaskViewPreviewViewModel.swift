//
//  TodoListViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class TaskViewPreviewViewModel: ObservableObject {
    
    @Published var tasks: [Tasc] = []
    @Published var userID: String?
    
    init() {
        self.userID = Auth.auth().currentUser?.uid
    }
    
    
    func deleteTask(taskID: String) async throws {
        try await TaskService.shared.deleteTask(taskID: taskID)
    }
    
    func toggleTask(finishedTaskID: String, currentState: Bool) async throws {
        try await TaskService.shared.toggleTask(finishedTaskID: finishedTaskID, currentState: currentState)
    }
    
    
    
    
    
}
