//
//  AuthService.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 27.08.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


class TaskService {
    
    
    @Published var userID: String?
    
    init() {
        self.userID = Auth.auth().currentUser?.uid
    }
    
    static let shared = TaskService()
    
    
    @MainActor
    func createTask(title: String, category: String, subtasks: [SubTasc], dueDate: String, description: String, isHighPriority: Bool, isMarked: Bool, notificationID: String, reminderUnit: String, reminderValue: Int) async throws {
        guard let uid = self.userID else { return }
        print(subtasks)
        let newTask = Tasc(id: UUID().uuidString,
                           title: title,
                           category: category,
                           subtasks: subtasks,
                           dueDate: dueDate,
                           isDone: false,
                           description: description,
                           dateCreated: getStringFromDate(date: Date(), dateFormat: "d MMM YY, HH:mm:ss"),
                           isHighPriority: isHighPriority,
                           isMarked: isMarked,
                           notificationID: notificationID,
                           reminderUnit: reminderUnit,
                           reminderValue: reminderValue
        )
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(newTask.id).setData(newTask.asDictionary())
        print("Task \(newTask.title) inserted to firestore")
    }
    
    @MainActor
    func editTask(taskID: String, title: String, category: String, subtasks: [SubTasc], dueDate: String, description: String, isHighPriority: Bool, isMarked: Bool, notificationID: String, reminderUnit: String, reminderValue: Int) async throws {
        guard let uid = self.userID else { return }
        
        let encodedSubtasks = try subtasks.map { try Firestore.Encoder().encode($0) }
        
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(taskID).setData([ "title": title, "category": category, "dueDate": dueDate, "description": description, "subtasks": encodedSubtasks, "isHighPriority": isHighPriority, "isMarked": isMarked, "notificationID": notificationID, "reminderUnit": reminderUnit, "reminderValue": reminderValue], merge: true)
    
        print("Task \(title) updated in Firestore")
    }
    
    @MainActor
    func toggleTask(finishedTaskID: String, currentState: Bool, notifcationID: String) async throws {
        guard let uid = self.userID else { return }
        
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(finishedTaskID).setData([ "isDone": !currentState], merge: true)
        NotificationHandler.shared.removeNotifications(ids: [notifcationID])
        try await removeReminderFromTask(taskID: finishedTaskID)
        print("Task with id \(finishedTaskID) was toggled")
        
    }
    
    @MainActor
    func updateSubTask(taskID: String, subtasks: [SubTasc]) async throws {
        guard let uid = self.userID else { return }
        let encodedSubtasks = try subtasks.map { try Firestore.Encoder().encode($0) }
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(taskID).setData([ "subtasks": encodedSubtasks], merge: true)
        print("Task with id \(taskID) has updated subtaks Fields")
        
    }
    
    @MainActor
    func deleteTask(taskID: String, notificationID: String) async throws {
        guard let uid = self.userID else { return }
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(taskID).delete()
        NotificationHandler.shared.removeNotifications(ids: [notificationID])
        print("Task with ID: \(taskID) deleted from firestore")
    }
    
    @MainActor
    func markTask(taskID: String, isMarkedNow: Bool) async throws {
        guard let uid = self.userID else { return }
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(taskID).setData(["isMarked": !isMarkedNow], merge: true)
        print("Task with ID: \(taskID) toggled Mark")
    }
    
    
    
    @MainActor
    func removeReminderFromTask(taskID: String) async throws {
        guard let uid = self.userID else { return }
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(taskID).setData(["notificationID": ""], merge: true)
        print("Task with ID: \(taskID) removed notificationID from Firestore")
    }
    
    @MainActor
    func removeSubtaskFromTask(taskID: String) async throws {
        guard let uid = self.userID else { return }
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(taskID).setData(["subtasks": []], merge: true)
        print("Task with ID: \(taskID) removed Subtaks from Firestore")
    }
    
    @MainActor
    func togglePrioTask(taskID: String, isHighPrioNow: Bool) async throws {
        guard let uid = self.userID else { return }
        try await Firestore.firestore().collection("users").document(uid).collection("tasks").document(taskID).setData([ "isHighPriority": !isHighPrioNow], merge: true)
        print("Task with ID: \(taskID) toggled Prio")
    }
    
    
    
    
    @MainActor
    func deleteAllTasksFromCategory(categoryName: String) async throws {
        guard let uid = self.userID else { return }
        let db = Firestore.firestore()
        let QuerySnapshot = try await db.collection("users").document(uid).collection("tasks").whereField("category", isEqualTo: categoryName).getDocuments()
        for document in QuerySnapshot.documents {
                    let data = document.data()
                    let json = try JSONSerialization.data(withJSONObject: data)
                    let tasc = try JSONDecoder().decode(Tasc.self, from: json)
                    try await deleteTask(taskID: tasc.id, notificationID: tasc.notificationID)
                }
    }
    
    
}
