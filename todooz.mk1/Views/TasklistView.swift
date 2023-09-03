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
    

    
    init(category: Category, currentUser: User?) {
        
        self.category = category
        self.currentUser = currentUser
        
    }
    
    
    /*
     
     //Test Data
     var items: [Tasc] = TestData.todos
     
     var filteredItems: [Tasc] {
     return items.filter { item in
     return item.category == category.name
     }
     }
     
     
     */
  
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(tasks) { item in
                    TaskView(item: item)
                        .swipeActions {
       
                            Button("löschen") {
                                Task { try await viewModel.deleteTask(taskID: item.id) }
                            }
                            .tint(.red)
                        }
                }
            
            }
            .refreshable {
                $tasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
                //Task { _tasks = FirestoreQuery(collectionPath: "users/\(currentUser?.id)/tasks")
            }
            
            
            .navigationTitle(category.name)
            
            .sheet(isPresented: $showAddItemSheet, content: {
                AddTaskView(category: category)
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
            print("onapear ran")
            $tasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
        }
    }
        
}
    




struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        TasklistView(category: Category(id: "dkfjddk213", name: "Swisscom", dateCreated: getCurrentDateString()), currentUser: User(id: "234j3i4j34kl3j43l", firstName: "Chris", lastName: "Zimmermann", email: "chris.zimmermann@hotmail.ch", joined: Date().timeIntervalSince1970))
    }
}
