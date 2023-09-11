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
    @Published var isStrikedThrough: Bool = false;
    
    init() {
        self.userID = Auth.auth().currentUser?.uid
    }
    
    
    func deleteTask(taskID: String) async throws {
        try await TaskService.shared.deleteTask(taskID: taskID)
    }
    
    
    @MainActor
    func toggleTask(finishedTaskID: String, currentState: Bool) async throws {
        self.isStrikedThrough.toggle()
        try await Task.sleep(seconds: 2.0)
        //Haptic Feedback on remove
        let impactLight = UIImpactFeedbackGenerator(style: .light)
        impactLight.impactOccurred()
        try await TaskService.shared.toggleTask(finishedTaskID: finishedTaskID, currentState: currentState)
        self.isStrikedThrough.toggle()
    }
    
    
    
    
    
}
