//
//  MainViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI
import FirebaseAuth

class MainViewModel: ObservableObject{
    
    @Published var currentUserID: String = ""
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserID = user?.uid ?? ""
            }
            
        }
    }
    
    public var IsSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    
    
    
}
