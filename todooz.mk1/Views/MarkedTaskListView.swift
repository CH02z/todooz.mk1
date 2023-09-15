//MarkedListView
//  ToDoListView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 31.08.23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseAuth

struct MarkedTaskListView: View {
    
    let currentUser: User?
    let allCategories: [Category]
    
    
    @FirestoreQuery(collectionPath: "users") var tasks: [Tasc]
    @ObservedObject var viewModel = TaskListViewModel()
    
    private func filterTasks() {
        $tasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
        $tasks.predicates = [
            .isEqualTo("isMarked", true),
            .whereField("isDone", isEqualTo: false),
            .order(by: "dueDate", descending: true),
        ]
    }
    
    var body: some View {
        NavigationStack {
            
                
            List {
                ForEach(tasks) { item in
                    TaskViewPreview(item: item, allCategories: allCategories)
                        .swipeActions {
                            
                            Button() {
                                Task { try await viewModel.markTask(taskID: item.id, isMarkedNow: item.isMarked) }
                            } label: {
                                Image(systemName: "flag")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .tint(.orange)
                            
                            Button() {
                                Task { try await viewModel.prioTask(taskID: item.id, isHighPrioNow: item.isHighPriority) }
                            } label: {
                                Image(systemName: "exclamationmark")
                                    .font(.system(size: 15))
                            }
                            .tint(.gray)
                            
                            
                            Button() {
                                Task { try await viewModel.deleteTask(taskID: item.id) }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .tint(.red)
         
                        }
                    
                }
                if tasks.count == 0 {
                        Text("Keine markierten Tasks vorhanden.")
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
                
                .navigationTitle("Markiert")
                
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





struct MarkedTaskListView_Previews: PreviewProvider {
    static var previews: some View {
        MarkedTaskListView(currentUser: TestData.users[0], allCategories: [TestData.categories[0]])
    }
}

