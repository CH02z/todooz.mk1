//
//  MainViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI
import FirebaseAuth
import Combine


class MainViewModel: ObservableObject{
    
    
    /*
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
     
     */
    
    private let authService = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.SetupSubscribers()        
    }
    
    // userSession is the value which is emitted by the puplisher
    // This subscription is of Type cancellable which get store in our set of Cancellable
    func SetupSubscribers() {
        authService.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
            print("MainViewModel Usersession set: \(userSession)")
        }.store(in: &cancellables)
        
        authService.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
            print("MainViewModel currentUser set: \(currentUser?.id)")
        }.store(in: &cancellables)
        
        
    }
    
    
    
    
}
