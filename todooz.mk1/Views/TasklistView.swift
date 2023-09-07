//
//  ToDoListView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 31.08.23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseAuth

struct TasklistView: View {
    
    let category: Category
    
    let allCategories: [Category]
    let currentUser: User?
    
    @State var showAddItemSheet: Bool = false
   
    
    @FirestoreQuery(collectionPath: "users") var tasks: [Tasc]
    @ObservedObject var viewModel = TaskListViewModel()
    
    
    
     
     //Test Data
     var testItems: [Tasc] = TestData.tasks
     
     
     
  
    var body: some View {
        
        NavigationStack {         
            
            
            List {
                ForEach(tasks) { item in
                    TaskViewPreview(item: item, allCategories: allCategories)
                        .swipeActions {
       
                            Button("löschen") {
                                Task { try await viewModel.deleteTask(taskID: item.id) }
                            }
                            .tint(.red)
                        }
                        
                }
            
            }
            .refreshable {
                let cat = self.category.name
                $tasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
                $tasks.predicates = [
                    .isEqualTo("category", cat),
                    .order(by: "dueDate", descending: true),
                    ]
            }
            
            
            .navigationTitle(category.name)
            
            .sheet(isPresented: $showAddItemSheet, content: {
                AddTaskView(isPresented: $showAddItemSheet, allCategories: allCategories, originalCat: category.name)
            })
            
            
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                    }
                    
                }
            }
            
            .safeAreaInset(edge: .bottom, alignment: .center) {
                Button{
                    //Haptic Feedback on Tap
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    
                    self.showAddItemSheet = true
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
            //print("onapear ran")
            let cat = self.category.name
            $tasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
            $tasks.predicates = [
                .isEqualTo("category", cat),
                .order(by: "dueDate", descending: true),
                ]
        }
    }
        
}
    




struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        TasklistView(category: TestData.categories[0], allCategories: [], currentUser: TestData.users[0])
    }
}
