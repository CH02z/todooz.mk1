import SwiftUI
import FirebaseAuth
import FirebaseFirestore


class CategoryViewModel: ObservableObject{
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    
    func deleteCategory(category: Category) async throws {
        try await CategoryService.shared.deleteCategory(categoryID: category.id)
        try await TaskService.shared.deleteAllTasksFromCategory(categoryName: category.name)
    }
    
    
}
