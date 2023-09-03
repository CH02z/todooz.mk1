//
//  AuthService.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 27.08.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class TaskService {
    
    
    @Published var userID: String?
    
    init() {
        self.userID = Auth.auth().currentUser?.uid
    }
    
    static let shared = TaskService()
    
    
    
    func getStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM YY, HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    
    @MainActor
    func createTask(title: String, category: String, dueDate: Date, description: String, isHighPriority: Bool) async throws {
        
        guard let uid = self.userID else { return }
        let newTask = Tasc(id: UUID().uuidString,
                           title: title,
                           category: category,
                           dueDate: getStringFromDate(date: dueDate),
                           isDone: false,
                           dateCreated: getStringFromDate(date: Date()),
                           isHighPriority: isHighPriority
        )
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(newTask.id).setData(newTask.asDictionary())
        print("Task \(newTask.title) inserted to firestore")
    }
    
    @MainActor
    func deleteTask(taskID: String) async throws {
        guard let uid = self.userID else { return }
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(taskID).delete()
        print("Task with ID: \(taskID) deleted from firestore")
    }
    
    
    
}
