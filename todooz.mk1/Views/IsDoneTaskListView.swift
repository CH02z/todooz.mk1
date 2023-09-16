//
//  ToDoListView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 31.08.23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseAuth

struct IsDoneTaskListView: View {

    @AppStorage("accentColor") private var accentColor = "B35AEF"
    let allCategories: [Category]
    let currentUser: User?
    
    
    @FirestoreQuery(collectionPath: "users") var tasks: [Tasc]
    @ObservedObject var viewModel = TaskListViewModel()
    
    private func filterTasks() {
        $tasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
        $tasks.predicates = [
            //.isEqualTo("category", cat),
            .whereField("isDone", isEqualTo: true)
        ]
    }
    
    
    
    
    //Test Data
    var testItems: [Tasc] = TestData.tasks
    
    var body: some View {
        
        NavigationStack {
            
            List {
                ForEach(tasks) { item in
                    IsDoneTaskViewPreview(item: item, allCategories: allCategories)
                        .swipeActions {
                            
                            Button("löschen") {
                                Task { try await viewModel.deleteTask(taskID: item.id, notificationID: item.notificationID) }
                            }
                            .tint(.red)
                        }
                    
                }
                if tasks.count == 0 {
                        Text("Ab an die Arbeit, du hast noch keine erledigten Tasks")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            
                }
            }
            .refreshable {
                Task { @MainActor in
                    self.filterTasks()
                }
            }
            
            
            .navigationTitle("Erledigt")
            .navigationBarTitleDisplayMode(.large)
                      
            
            
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                        //.font(.system(size: 20))
                    }
                    
                }
                
                
            }
            
            
            
            
        }
        .onAppear() {
            Task { @MainActor in
                self.filterTasks()
            }
        }
    }
    
}





struct IsDoneTaskListView_Previews: PreviewProvider {
    static var previews: some View {
        IsDoneTaskListView(allCategories: [], currentUser: TestData.users[0])
    }
}
