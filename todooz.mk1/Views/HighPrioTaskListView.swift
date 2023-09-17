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
    
    @State var showDetailTaskSheet: Bool = false
    
    @State var detailTask: Tasc = TestData.tasks[0]
    @State var editTask: Tasc = TestData.tasks[0]
    
    
    @FirestoreQuery(collectionPath: "users") var tasks: [Tasc]
    @ObservedObject var viewModel = TaskListViewModel()
    
    private func filterTasks() {
        $tasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
        $tasks.predicates = [
            .isEqualTo("isHighPriority", true),
            .whereField("isDone", isEqualTo: false),
            .order(by: "dueDate", descending: true),
        ]
    }
    
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(tasks) { item in
                    TaskViewPreview(item: item, allCategories: allCategories)
                        .swipeActions(edge: .leading) {
                            
                            Button() {
                                Task { try await viewModel.prioTask(taskID: item.id, isHighPrioNow: item.isHighPriority) }
                            } label: {
                                Image(systemName: "exclamationmark")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                            }
                            .tint(.red)
                            
                            
                            Button() {
                                Task { try await viewModel.markTask(taskID: item.id, isMarkedNow: item.isMarked) }
                            } label: {
                                Image(systemName: "flag")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .tint(.orange)
                            
                            
                        }
                        .swipeActions(edge: .trailing) {
                            Button() {
                                Task { try await viewModel.deleteTask(taskID: item.id, notificationID: item.notificationID) }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                            }
                            .tint(.red)
                            
                        }
                        .contextMenu {
                            Button {
                                print("Item: \(item)")
                                self.detailTask = item
                                print("detailTask: \(self.detailTask)")
                                self.showDetailTaskSheet = true
                            
                                
                            } label: {
                                Label("Detailansicht", systemImage: "eye")
                                    .foregroundColor(.red)
                            }
                            
                            NavigationLink(destination: EditTaskView(allCategories: allCategories, editTask: item)) {
                                    Text("bearbeiten")
                                    Image(systemName: "pencil")
                                }
                        
                        }
                    
                }
                if tasks.count == 0 {
                        Text("Keine Tasks mit hoher Priorität vorhanden")
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
            
            .sheet(isPresented: $showDetailTaskSheet, content: {
                DetailTaskView(task: $detailTask, allCategories: allCategories, isPresented: $showDetailTaskSheet)
            })
            
            
            
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
