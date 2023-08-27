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
import GoogleSignIn
import GoogleSignInSwift


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
    func signInWithGoogle() async -> Bool {
        
        enum CustomError: Error {
            // Throw when an invalid password is entered
            case tokenError(message: String)
            
        }
        
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID fount in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rooViewController = window.rootViewController else {
            print("There is no root view Controller")
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rooViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                throw CustomError.tokenError(message: "ID token missing")
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            // Imporntant: Set user session
            self.userSession = firebaseUser
            
            //Check if user exists in Firestore DB
            if try await !self.UsernameExistsInFirestore(uid: firebaseUser.uid) {
                //Insert Google Account to Firestore
                print("Google Account Inserted to Firestore")
                await inserUserRecord(uid: firebaseUser.uid, firstName: "ChrisGID", lastName: "ZimmermannGID", email: firebaseUser.email ?? "")
            } else {
                //Load User Data
                print("Google Account already exists in Firestore, loading user data")
                try await self.loadUserData()
            }
            
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
        
    }
    
    @MainActor
    func UsernameExistsInFirestore(uid: String) async throws -> Bool {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("users").document(uid).getDocument()
        guard let data = snapshot.data() else { return false }
        return true
        
    }
    
    
    
    @MainActor
    func signOut() async {
        try? Auth.auth().signOut()
        self.userSession = nil
    }
    
}
