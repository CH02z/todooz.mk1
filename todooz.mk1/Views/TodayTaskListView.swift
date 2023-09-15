//
//  ToDoListView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 31.08.23.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseAuth

struct TodayTaskListView: View {
    
    let currentUser: User?
    let allCategories: [Category]
    
    @State var filteredByDateTasks: [Tasc] = []
   
    
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
            return isSameDay(date1: Date(), date2: getDateFromString(dateString: tasc.dueDate!))
            
        }
        
    }

    var body: some View {
        NavigationStack {
            
            List {
                ForEach(filteredByDateTasks) { item in
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
                        Text("Heute scheint ein ruhiger Tag zu sein; Keine Tasks zu erledigen")
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
            
            
            
            .navigationTitle("Heute zu erledigen")
            
            
            
            
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
    




struct TodayTaskListViewPreview: PreviewProvider {
    static var previews: some View {
        TodayTaskListView(currentUser: TestData.users[0], allCategories: [TestData.categories[0]])
    }
}
