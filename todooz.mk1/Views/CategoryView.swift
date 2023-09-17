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
    //@State var avatarImage: UIImage?
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    
    @ObservedObject var viewModel = CategoryViewModel()
    @State var showAddCategorySheet: Bool = false
    @FirestoreQuery(collectionPath: "users") var categories: [Category]
    //@FirestoreQuery(collectionPath: "users") var Alltasks: [Tasc]
    
    @State private var showDeleteCatConfirmationDialog: Bool = false
    @State private var categorytoDelete: Category = Category(id: "", name: "", dateCreated: "")
    
    //var TestCategories: [Category] = TestData.categories
    
   
    
    var body: some View {
        
        
        if let user = currentUser {
            
            NavigationStack {
                
                VStack(alignment: .leading) {
                    
                    StandardCategoryPreviewView(currentUser: user, allCategories: categories)
                        .padding()
                    
                    Text("Meine Kategorien")
                        .padding(.leading)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    if categories.count == 0 {
                        VStack {
                            Text("Erstelle zuerst eine Kategorie, um neue Tasks hinzuzufügen")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 40)
                            Button{
                                
                                //Haptic Feedback on Tap
                                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                                impactHeavy.impactOccurred()
                                self.showAddCategorySheet = true
                                
                            } label: {
                                Label("hinzufügen", systemImage: "plus")
                                    .bold()
                                    .font(.title2)
                                    .padding(8)
                                    .background(Color("ElementBackround"),
                                                in: Capsule())
                                    .padding(.leading)
                                    .symbolVariant(.circle.fill)
                            }
                        }
                        .padding(.top, 60)
                        .padding()
                        
                    }
                    
                    
                    
                    List {
                        
                        ForEach(categories) { category in
                            NavigationLink(destination: TasklistView(category: category, allCategories: categories, currentUser: currentUser)) {
                                //Displayed List Item Design:
                                CategoryPreviewView(category: category, currentUser: self.currentUser )
                            }
                            .swipeActions {
                                
                                Button("löschen") {
                                    showDeleteCatConfirmationDialog = true
                                    self.categorytoDelete = category
                                }
                                .confirmationDialog("Are you sure?",
                                                    isPresented: $showDeleteCatConfirmationDialog) {
                                    Button("Delete categore?", role: .destructive) {
                                    }
                                } message: {
                                    Text("Alle Tasks in dieser Kategorie werden gelöscht")
                                }
                                .tint(.red)
                                
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
                    .confirmationDialog("Are you sure?",
                                        isPresented: $showDeleteCatConfirmationDialog) {
                        Button("Kategorie löschen?", role: .destructive) {
                            
                            Task { try await viewModel.deleteCategory(category: self.categorytoDelete) }
                            
                        }
                    } message: {
                        Text("Alle Tasks in dieser Kategorie werden gelöscht")
                    }
                }
                
                .navigationTitle("Tasks")
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack(spacing: 5) {
                            Text(getStringFromDate(date: Date(), dateFormat: "dd."))
                                //.foregroundColor(.secondary)
                                .foregroundColor(Color(hex: accentColor))
                            
                            Text(getStringFromDate(date: Date(), dateFormat: "MMMM"))
                                .foregroundColor(.secondary)
                            
                            Text(getStringFromDate(date: Date(), dateFormat: "YYYY"))
                                .foregroundColor(.secondary)
                            
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
                    
                    
                }
                
                .onAppear() {
                    $categories.path = "users/\(user.id)/categories"
                    $categories.predicates = [
                        //.isEqualTo("category", cat),
                        .order(by: "dateCreated", descending: false),
                    ]
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
