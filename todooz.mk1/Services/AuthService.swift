//
//  AuthService.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 27.08.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase


class AuthService {
    
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    static let shared = AuthService()
    
    
    init() {
        Task { try await self.loadUserData() }
    }
    
    @MainActor
    func login(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await self.loadUserData()
        } catch {
            print("Failed to login user with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func register(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            await self.inserUserRecord(uid: result.user.uid, firstName: "Chris", lastName: "Zimmermann", email: email)
        } catch {
            print("Failed to register user with error: \(error.localizedDescription)")
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

    @MainActor
    func loadUserData() async throws {
        print("LoadUserData called")
        self.userSession = Auth.auth().currentUser
        guard let currentUid = self.userSession?.uid else { return }
        let db = Firestore.firestore()
        let snapshot = try await db.collection("users").document(currentUid).getDocument()
        
        guard let data = snapshot.data() else { return }
        
        let json = try JSONSerialization.data(withJSONObject: data)
        self.currentUser = try JSONDecoder().decode(User.self, from: json)        
        
        
    }
    
    
   
    @MainActor
    func signOut() async {
        try? Auth.auth().signOut()
        self.userSession = nil
    }
    
}
