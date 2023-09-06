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
    
    
    init() {}
    
    func loadUserProfileImage() async throws -> UIImage? {
        let imageRef = try await getProfilePictureRef()
        return await DownloadPhoto(imageRef: imageRef)
        print("avatar image set...")
        if !imageRef.isEmpty {
            
        }
    }
    
    func uploadPhoto(image: UIImage?) async {
        guard image != nil else { return }
        await ProfileService.shared.uploadPhoto(image: image)
    }
    
    func getProfilePictureRef() async throws -> String {
        let profilePicRef = try await ProfileService.shared.getProfilePictureRef()
        return !profilePicRef.isEmpty ? profilePicRef : ""
    }
    
    func DownloadPhoto(imageRef: String) async -> UIImage? {
        let ProfilePhoto = await ProfileService.shared.DownloadPhoto(imageRef: imageRef)
        return ProfilePhoto
    }
    
    
    
    
}
