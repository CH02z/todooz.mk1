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
    
    
    @MainActor
    func createTask(title: String, category: String, dueDate: String?, description: String, isHighPriority: Bool) async throws {
        guard let uid = self.userID else { return }
        let newTask = Tasc(id: UUID().uuidString,
                           title: title,
                           category: category,
                           dueDate: dueDate,
                           isDone: false,
                           description: description,
                           dateCreated: getStringFromDate(date: Date(), dateFormat: "d MMM YY, HH:mm:ss"),
                           isHighPriority: isHighPriority
        )
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(newTask.id).setData(newTask.asDictionary())
        print("Task \(newTask.title) inserted to firestore")
    }
    
    @MainActor
    func editTask(taskID: String, title: String, category: String, dueDate: String, description: String, isHighPriority: Bool) async throws {
        guard let uid = self.userID else { return }
        
        /*...
        if dueDate == "" {
            //delete Date from existing Task
            try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(taskID).setData([ "dueDate": ""], merge: true)
        }
        
        if dueDate.count < 11 {
            //insert task with full
        }
         */
        
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(taskID).setData([ "title": title, "category": category, "dueDate": dueDate, "description": description, "isHighPriority": isHighPriority], merge: true)
        print("Task \(title) updated in Firestore")
    }
    
    @MainActor
    func toggleTask(finishedTaskID: String, currentState: Bool) async throws {
        guard let uid = self.userID else { return }
        
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(finishedTaskID).setData([ "isDone": !currentState], merge: true)
        print("Task with id \(finishedTaskID) was toggled")
        
    }
    
    @MainActor
    func deleteTask(taskID: String) async throws {
        guard let uid = self.userID else { return }
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(taskID).delete()
        print("Task with ID: \(taskID) deleted from firestore")
    }
        
    
    
}
