//
//  LoginViewModel.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject{
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    
    init() {}
    
    
    func isValidEmail(_ inputMail: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func login() {
        
        guard self.validateForm() else {
            return
        }
        
        //Try firebase auth login
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorMessage = error?.localizedDescription ?? ""
            } else {
                print("successfully logged in")
            }
        }
        
    }
    
    func validateForm() -> Bool {
        self.errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.errorMessage = "Plese fill in all fields"
            return false
        }
        
        guard self.isValidEmail(self.email) else {
            self.errorMessage = "Please enter a valid email"
            return false
        }
        
        
        return true
        
        
    }
    
    
    
}
