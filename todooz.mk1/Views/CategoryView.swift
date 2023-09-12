//
//  ToDoListView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseAuth

struct CategoryView: View {
    
    let currentUser: User?
    @State var avatarImage: UIImage?
    
    @ObservedObject var viewModel = CategoryViewModel()
    @State var showAddCategorySheet: Bool = false
    @FirestoreQuery(collectionPath: "users") var categories: [Category]
    @FirestoreQuery(collectionPath: "users") var Alltasks: [Tasc]
    
    //var TestCategories: [Category] = TestData.categories
    
    @State private var searchText = ""
    
    private func filterTasks(keyword: String) {
        $Alltasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
        $Alltasks.predicates = [
            //.arrayContains("title", keyword),
            //.isEqualTo("title", keyword),
            //.whereField("title", isLessThanOrEqualTo: keyword),
            .whereField("title", arrayContains: keyword),
        ]
    }
    
    
    var body: some View {
        
        
        if let user = currentUser {
            
            NavigationStack {
                
                VStack(alignment: .leading) {
                    
                    StandardCategoryPreviewView(currentUser: user, allCategories: categories)
                        .padding()
                    
                    //.frame(maxWidth: .infinity, alignment: .center)
                    
                    List{
                        
                        ForEach(categories) { category in
                            NavigationLink(destination: TasklistView(category: category, allCategories: categories, currentUser: currentUser)) {
                                //Displayed List Item Design:
                                CategoryPreviewView(category: category, currentUser: self.currentUser )
                            }
                        }
                        
                    }
                    .refreshable {
                        $categories.path = "users/\(user.id)/categories"
                        $categories.predicates = [
                            //.isEqualTo("category", cat),
                            .order(by: "dateCreated", descending: false),
                        ]
                    }
                    .sheet(isPresented: $showAddCategorySheet, content: {
                        AddCategoryView(isPresented: $showAddCategorySheet)
                    })
                }
                
                .navigationTitle("Kategorien")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button{
                            
                            //Haptic Feedback on Tap
                            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                            impactHeavy.impactOccurred()
                            self.showAddCategorySheet = true
                            
                        } label: {
                            Image(systemName: "plus")
                            //.foregroundColor(.gray)
                                .font(.system(size: 25))
                            
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ProfileView(currentUser: currentUser)) {
                            Image(systemName: "person.circle")
                            //.foregroundColor(.gray)
                                .font(.system(size: 25))
                            //.padding(.bottom, 10)
                        }
                        
                    }
                }
                
                .onAppear() {
                    $categories.path = "users/\(user.id)/categories"
                    $categories.predicates = [
                        //.isEqualTo("category", cat),
                        .order(by: "dateCreated", descending: false),
                    ]
                }
                
                
                
            }
            .onAppear() {
                //filterTasks
                Task { @MainActor in
                    self.filterTasks(keyword: "")
                }
            }
            
        } else {
            LoadingView()
            
        }
    }
}


struct CategoryPreviewView: View {
    
    let category: Category
    let currentUser: User?
    @State var NumberOfTasks: String = ""
    
    init(category: Category, currentUser: User?) {
        self.category = category
        self.currentUser = currentUser
        
    }
    
    @FirestoreQuery(collectionPath: "users") var numberOfTasks: [Tasc]
    
    private func getNumberOfTasks(uid: String) async throws {
        $numberOfTasks.path = "users/\(uid)/tasks"
        $numberOfTasks.predicates = [
            .isEqualTo("category", category.name),
            .isEqualTo("isDone", false)
        ]
        try await Task.sleep(seconds: 0.2)
        self.NumberOfTasks = String(numberOfTasks.count)
    }
    
    var body: some View {
        
        if let user = currentUser {
            
            HStack {
                Image(systemName: category.icon ?? "list.bullet")
                    .foregroundColor(.white)
                    .frame(width: 35, height: 35)
                    .background(Color(hex: category.iconColor!) ?? .green)
                    .clipShape(Circle())
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .padding(.vertical, 3.5)
                    .padding(.trailing, 5)
                //.overlay(Circle().stroke(Color.white, lineWidth: 1))
                
                Text(category.name)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                
                Text(self.NumberOfTasks)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.gray)
            }
            .onAppear() {
                Task { try await self.getNumberOfTasks(uid: user.id) }
            }
            
        }
        
        
    }
    
    
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(currentUser: TestData.users[0])
    }
}
