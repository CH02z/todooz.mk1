import SwiftUI
import FirebaseAuth
import FirebaseFirestore


class RegistrationViewModel: ObservableObject{
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    
    
    
    func register() {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorMessage = error?.localizedDescription ?? ""
            } else {
                print("successfully created User")
                guard let userID = result?.user.uid else {
                    return
                }
                self.insertUserRecord(id: userID)
            }
        }
        
    }
    
    func insertUserRecord(id: String) {
        let newUser = User(id: id, firstName: "Chris", lastName: "Zimmermann", email: self.email, joined: Date().timeIntervalSince1970)
        let db = Firestore.firestore()
        db.collection("users").document(id).setData(newUser.asDictionary())
        print("user inserted to firestore")
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
