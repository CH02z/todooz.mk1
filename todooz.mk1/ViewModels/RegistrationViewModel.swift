import SwiftUI
import FirebaseAuth
import FirebaseFirestore


class RegistrationViewModel: ObservableObject{
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    
    
    
    func register() async throws {
        try await AuthService.shared.register(email: self.email, password: self.password)
        print("register viewmodel function called")
    }
    
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    
    func isSecurePassword(password: String) -> Bool {
        print("issecurepw function called")
        let lowercaseLetterRegEx = ".*[a-z]+.*"
        let uppercaseLetterRegEx = ".*[A-Z]+.*"
        let digitRegEx = ".*[0-9]+.*"
        let specialCharacterRegEx = ".*[!@#$%^&*]+.*"
        let lowercaseLetterPredicate = NSPredicate(format: "SELF MATCHES %@", lowercaseLetterRegEx)
        let uppercaseLetterPredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseLetterRegEx)
        let digitPredicate = NSPredicate(format: "SELF MATCHES %@", digitRegEx)
        
        let specialCharacterPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegEx)
        
        if password.count >= 8 && lowercaseLetterPredicate.evaluate(with: password) && uppercaseLetterPredicate.evaluate(with: password) && digitPredicate.evaluate(with: password) && specialCharacterPredicate.evaluate(with: password)
        {
            print("reqs met")
            return true
        } else {
            print("not met")
            return false
        }
    }
    
    
}
