import SwiftUI
import FirebaseAuth
import FirebaseFirestore


class CategoryViewModel: ObservableObject{
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""    
    
}
