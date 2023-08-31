//
//  ProfileViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import Foundation
import FirebaseFirestore
import PhotosUI

class ProfileViewViewModel: ObservableObject {
    
    @Published var avatarImage: UIImage?
    
    
    init() {
        
        Task {
            try await loadUserProfileImage()
        }
        
    }
    
    func loadUserProfileImage() async throws {
        let imageRef = try await getProfilePictureRef()
        print("image ref \(imageRef)")
        if !imageRef.isEmpty {
            self.avatarImage = try await DownloadPhoto(imageRef: imageRef)
            print("avatar image set...")
        }
    }
    
    func uploadPhoto(image: UIImage?) async throws {
        guard image != nil else { return }
        await ProfileService.shared.uploadPhoto(image: image)
    }
    
    func getProfilePictureRef() async throws -> String {
        let profilePicRef = try await ProfileService.shared.getProfilePictureRef()
        return !profilePicRef.isEmpty ? profilePicRef : ""
    }
    
    func DownloadPhoto(imageRef: String) async throws -> UIImage? {
        let ProfilePhoto = await ProfileService.shared.DownloadPhoto(imageRef: imageRef)
        return ProfilePhoto
    }
    
    func logout() async throws {
       await AuthService.shared.signOut()
    }
    
    
    
    
}
