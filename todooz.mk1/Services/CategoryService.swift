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
    func createCategory(name: String, description: String, iconColor: String, icon: String) async throws {
        guard let uid = self.userID else { return }
        let newCategory = Category(id: UUID().uuidString,
                                   name: name,
                                   description: description,
                                   iconColor: iconColor,
                                   icon: icon,
                                   dateCreated: getStringFromDate(date: Date(), dateFormat: "d MMM YY, HH:mm:ss"),
                                   lastModified: getStringFromDate(date: Date(), dateFormat: "d MMM YY, HH:mm:ss")
                                   
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
    
    
}
