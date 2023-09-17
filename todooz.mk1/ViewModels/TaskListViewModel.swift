//
//  TodoListViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class TaskListViewModel: ObservableObject {
    
    @Published var tasks: [Tasc] = []
    @Published var userID: String?
    
    init() {
        self.userID = Auth.auth().currentUser?.uid
    }
    
    
    func deleteTask(taskID: String, notificationID: String) async throws {
        try await TaskService.shared.deleteTask(taskID: taskID, notificationID: notificationID)
    }
    
    func markTask(taskID: String, isMarkedNow: Bool) async throws {
        try await TaskService.shared.markTask(taskID: taskID, isMarkedNow: isMarkedNow)
    }
    
    func prioTask(taskID: String, isHighPrioNow: Bool) async throws {
        try await TaskService.shared.togglePrioTask(taskID: taskID, isHighPrioNow: isHighPrioNow)
    }
    
}
