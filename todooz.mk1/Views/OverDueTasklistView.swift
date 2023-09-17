//
//  ToDoListView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 31.08.23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseAuth

struct OverDueListView: View {
    
    let currentUser: User?
    let allCategories: [Category]
    
    @State var filteredByDateTasks: [Tasc] = []
    
    @State var showDetailTaskSheet: Bool = false
    
    @State var detailTask: Tasc = TestData.tasks[0]
    @State var editTask: Tasc = TestData.tasks[0]
   
    
    @FirestoreQuery(collectionPath: "users") var tasks: [Tasc]
    @ObservedObject var viewModel = TaskListViewModel()
    
    
    private func filterTasks() async throws {
        $tasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
        $tasks.predicates = [
            .isEqualTo("isDone", false),
            .whereField("dueDate", isNotIn: [""]),
            .order(by: "dueDate", descending: true),
        ]
        try await Task.sleep(seconds: 0.1)
        self.filteredByDateTasks = self.tasks.filter { tasc in
            return dateIsInPast(inputDate: getDateFromString(dateString: tasc.dueDate))
        }
        
    }

    var body: some View {
        NavigationStack {
            
            List {
                ForEach(filteredByDateTasks) { item in
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
                if self.filteredByDateTasks.count == 0 {
                        Text("Bis jetzt sind keine Tasks überfällig")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            
                }
            }
            
            
            .refreshable {
                Task { @MainActor in
                    try await self.filterTasks()
                }
            }
            
            .sheet(isPresented: $showDetailTaskSheet, content: {
                DetailTaskView(task: $detailTask, allCategories: allCategories, isPresented: $showDetailTaskSheet)
            })
            
            
            
            .navigationTitle("Überfällig")
            
            
            
            
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
                try await self.filterTasks()
            }
            
        }
    }
        
}
    




struct OverDueListViewPreview: PreviewProvider {
    static var previews: some View {
        OverDueListView(currentUser: TestData.users[0], allCategories: [TestData.categories[0]])
    }
}
