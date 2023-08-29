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
    
    
    init() {}
    
    func uploadPhoto(image: UIImage?) async throws {
        guard image != nil else { return }
        await ProfileService.shared.uploadPhoto(image: image)
    }
    
    func logout() async throws {
       await AuthService.shared.signOut()
    }
    
    
    
    
}
