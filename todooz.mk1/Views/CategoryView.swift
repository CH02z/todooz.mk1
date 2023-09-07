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
    
    //var TestCategories: [Category] = TestData.categories

    
    
    
    var body: some View {
        
        if let user = currentUser {
         
            NavigationStack {
  
                VStack(alignment: .leading) {
                    
                    StandardCategoryPreviewView(currentUser: user, allCategories: categories)
                        .padding(.top, 20)
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
                            .limit(to: 8)
                        ]
                    }
                    .sheet(isPresented: $showAddCategorySheet, content: {
                        AddCategoryView(isPresented: $showAddCategorySheet)
                    })
                }
                
                .navigationTitle("Kategorien")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ProfileView(currentUser: currentUser)) {
                            Image(systemName: "person.circle")
                            //.foregroundColor(.gray)
                                .font(.system(size: 25))
                            
                            
                        }
                        
                    }
                }
                
                .safeAreaInset(edge: .bottom, alignment: .center) {
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
                            .background(.black,
                                        in: Capsule())
                            .padding(.leading)
                            .symbolVariant(.circle.fill)
                    }
                }
                .padding(.bottom, 10)
                
            }
            .onAppear() {
                $categories.path = "users/\(user.id)/categories"
                $categories.predicates = [
                    //.isEqualTo("category", cat),
                    .order(by: "dateCreated", descending: false),
                    .limit(to: 8)
                ]
            }
            
            
            
        } else {
            LoadingView()
            
        }
    } 
}


struct CategoryPreviewView: View {
    
    let category: Category
    let currentUser: User?
    
    var body: some View {
        
        
        HStack {
            Image(systemName: "list.bullet")
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(.green)
                .clipShape(Circle())
                .font(.system(size: 15))
                .fontWeight(.bold)
                .padding(.vertical, 3.5)
                .padding(.trailing, 5)
            //.overlay(Circle().stroke(Color.white, lineWidth: 1))
            
            Text(category.name)
                .fontWeight(.semibold)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
            
            Text("")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.gray)
            
            
        }
    }
    
    
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(currentUser: TestData.users[0])
    }
}
