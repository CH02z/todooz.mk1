//
//  ToDoListView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 31.08.23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseAuth

struct HighPrioTaskListView: View {
    
    let currentUser: User?
    let allCategories: [Category]
    
    @State var showAddItemSheet: Bool = false
    
    
    @FirestoreQuery(collectionPath: "users") var tasks: [Tasc]
    @ObservedObject var viewModel = TaskListViewModel()
    
    private func filterTasks() {
        $tasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
        $tasks.predicates = [
            .isEqualTo("isHighPriority", true),
            .order(by: "dueDate", descending: true),
        ]
    }
    
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
                Task { @MainActor in
                    self.filterTasks()
                }
            }
            
            .navigationTitle("Hohe Priorität")
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                        //.font(.system(size: 20))
                    }
                    
                }            }
            
            
            
        }
        .onAppear() {
            Task { @MainActor in
                self.filterTasks()
            }
        }
    }
    
}





struct HighPrioTaskListView_Previews: PreviewProvider {
    static var previews: some View {
        HighPrioTaskListView(currentUser: TestData.users[0], allCategories: [TestData.categories[0]])
    }
}
