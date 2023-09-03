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
    let currentUser: User?
    
    @State var showAddItemSheet: Bool = false
   
    
    @FirestoreQuery(collectionPath: "users") var tasks: [Tasc]
    @ObservedObject var viewModel = TaskListViewModel()
    
    
    
     
     //Test Data
     var testItems: [Tasc] = TestData.todos
     
     
     
  
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(tasks) { item in
                    TaskViewPreview(item: item)
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
                    .limit(to: 8)
                    ]
            }
            
            
            .navigationTitle(category.name)
            
            .sheet(isPresented: $showAddItemSheet, content: {
                AddTaskView(category: category, isPresented: $showAddItemSheet)
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
                        .background(.gray.opacity(0.1),
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
                .limit(to: 8)
                ]
        }
    }
        
}
    




struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        TasklistView(category: Category(id: "dkfjddk213", name: "Swisscom", dateCreated: getCurrentDateString()), currentUser: User(id: "234j3i4j34kl3j43l", firstName: "Chris", lastName: "Zimmermann", email: "chris.zimmermann@hotmail.ch", joined: Date().timeIntervalSince1970))
    }
}
