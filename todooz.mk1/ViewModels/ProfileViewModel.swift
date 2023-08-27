//
//  ProfileViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import Foundation
import FirebaseFirestore

class ProfileViewViewModel: ObservableObject {
    
    init() {}
    
    func logout() async throws {
       await AuthService.shared.signOut()
    }
    
    
}
