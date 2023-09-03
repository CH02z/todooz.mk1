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
    
    func getAllTaskForCategory(category: String) async {
        
        guard let uid = self.userID else { return }
        
        Firestore.firestore().collection("users").document(uid).collection("tasks").whereField("category", isEqualTo: true).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            print("get all tasks called and there is data:")
            
            self.tasks = documents.map { queryDocumentSnapshot -> Tasc in
                let data = queryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                print(title)
                
                let category = category
                let id = data["id"] as? String ?? ""
                let dueDate = data["dueDate"] as? String ?? ""
                let isDone = data["isDone"] as? Bool ?? false
                let description = data["description"] as? String ?? ""
                let iconColor = data["iconColor"] as? String ?? ""
                let dateCreated = data["dateCreated"] as? String ?? ""
                let dateFinished = data["dateFinished"] as? String ?? ""
                let isHighPriority = data["isHighPriority"] as? Bool ?? false
                print(Tasc(id: id, title: title, category: category, dueDate: dueDate, isDone: isDone, dateCreated: dateCreated, dateFinished: dateFinished, isHighPriority: isHighPriority))
                return Tasc(id: id, title: title, category: category, dueDate: dueDate, isDone: isDone, dateCreated: dateCreated, dateFinished: dateFinished, isHighPriority: isHighPriority)
            }
        }
    
    }
    
    func deleteTask(taskID: String) async throws {
        try await TaskService.shared.deleteTask(taskID: taskID)
    }
    
    
    
    
    
}
