//
//  AuthService.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 27.08.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class CategoryService {
    
    
    @Published var userID: String?
    
    init() {
        self.userID = Auth.auth().currentUser?.uid
    }
    
    static let shared = CategoryService()
    
    
    
    
    @MainActor
    func createCategory(name: String, description: String, iconColor: String) async throws {
        guard let uid = self.userID else { return }
        let newCategory = Category(id: UUID().uuidString,
                                   name: name,
                                   description: description,
                                   iconColor: iconColor,
                                   dateCreated: getStringFromDate(date: Date(), dateFormat: "d MMM YY, HH:mm:ss"),
                                   lastModified: getStringFromDate(date: Date(), dateFormat: "d MMM YY, HH:mm:ss"),
                                   numberOfTasks: 0
                                   
        )
        
        try await Firestore.firestore().collection("users").document(uid).collection("categories").document(newCategory.id).setData(newCategory.asDictionary())
        print("Category \(newCategory.name) inserted to firestore")
    }
    
    @MainActor
    func deleteCategory(categoryID: String) async throws {
        guard let uid = self.userID else { return }
        try await Firestore.firestore().collection("users").document(uid).collection("categories").document(categoryID).delete()
        print("Category with ID: \(categoryID) deleted from firestore")
    }
    
    
    func updateCategoryCounter(categoryID: String, currentCount: Int, isIncreased: Bool) async throws {
        guard let uid = self.userID else { return }
        let newCount = isIncreased ? currentCount + 1 : currentCount - 1
        try await Firestore.firestore().collection("users").document(uid).collection("categories").document(categoryID).setData([ "numberOfTasks": newCount, "lastModified": getStringFromDate(date: Date(), dateFormat: "d MMM YY, HH:mm:ss")], merge: true)
        print("CategoryCounter of Category with id \(categoryID) was increased by 1")
    }
    
    
}
