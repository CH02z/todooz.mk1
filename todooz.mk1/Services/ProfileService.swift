//
//  AuthService.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 27.08.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class ProfileService {
    
    
    @Published var userID: String?
    
    static let shared = ProfileService()
    
    
    init() {
        self.userID = Auth.auth().currentUser?.uid
    }
    
    func uploadPhoto(image: UIImage?) async {
        
        guard image != nil else {
            return
        }
        
        let storageRef = Storage.storage().reference()
        
        let imageData = image?.jpegData(compressionQuality: 0.8)
        
        guard imageData != nil else {
            return
        }
        
        
        let fileRef = storageRef.child("images/\(userID!)/profileImage.jpg")
        
        let uploadTask = fileRef.putData(imageData!, metadata: nil) {
            metadata, error in
            if error == nil && metadata != nil {
                // save firestore reference
            }
        }
        
        
        
    }
    

    
    
    
    @MainActor
    func inserUserRecord(uid: String, firstName: String, lastName: String, email: String) async {
        let newUser = User(id: uid,
                           firstName: firstName,
                           lastName: lastName,
                           email: email,
                           joined: Date().timeIntervalSince1970)
        try? await Firestore.firestore().collection("users").document(newUser.id).setData(newUser.asDictionary())
        print("user inserted to firestore")
    }
    
    
    
    
}
