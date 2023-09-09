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
    
    @State var showAddItemSheet: Bool = false
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
                            
                            Button("löschen") {
                                Task {
                                    try await viewModel.deleteTask(taskID: item.id)
                                    try await self.filterTasks()
                                }
                            }
                            .tint(.red)
                        }
                    
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
