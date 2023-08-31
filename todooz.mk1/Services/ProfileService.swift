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
    
    @Published var ProfilePhoto: UIImage?
    
    static let shared = ProfileService()
    
    
    init() {
        self.userID = Auth.auth().currentUser?.uid
    }
    
    
    @MainActor
    func uploadPhoto(image: UIImage?) async {
        
        guard let uid = self.userID else { return }
        guard image != nil else { return }
        let storageRef = Storage.storage().reference()
        let imageData = image?.jpegData(compressionQuality: 0.8)
        guard imageData != nil else { return }
        let fileRef = storageRef.child("images/\(uid)/profileImage.jpg")
        
        fileRef.putData(imageData!, metadata: nil) {
            metadata, error in
            if error == nil && metadata != nil {
                Firestore.firestore().collection("users").document(uid).setData([ "profieImageRef": "images/\(uid)/profileImage.jpg"], merge: true)
                print("Profile image inserted to firestore")
            }
        }
    }
    
    @MainActor
    func DownloadPhoto(imageRef: String) async -> UIImage? {
        
        guard let uid = self.userID else { return nil }
        let storageRef = Storage.storage().reference()
        //let imageData = image?.jpegData(compressionQuality: 0.8)
        //guard imageData != nil else { return }
        let fileRef = storageRef.child(imageRef)
        
        // Max Size set to 8MB
        fileRef.getData(maxSize: 8 * 1024 * 1024) {
            data, error in
            if error == nil {
                self.ProfilePhoto = UIImage(data: data!)
            }
        }
        return self.ProfilePhoto
    }
    
    @MainActor
    func getProfilePictureRef() async throws -> String {
        guard let uid = self.userID else { return "" }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        guard let data = snapshot.data()!["profieImageRef"] else { return "" }
        return data as! String
    }
    
    
    
    
}
