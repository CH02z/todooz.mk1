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
    
    @State var showAddItemSheet: Bool = false
    @State var filteredByDateTasks: [Tasc] = []
   
    
    @FirestoreQuery(collectionPath: "users") var tasks: [Tasc]
    @ObservedObject var viewModel = TaskListViewModel()
    
    
    private func filterTasks() async throws {
        try await Task.sleep(seconds: 0.1)
        self.filteredByDateTasks = self.tasks.filter { tasc in
            return isSameDay(date1: Date(), date2: getDateFromString(dateString: tasc.dueDate ?? ""))
        }
        
    }

    var body: some View {
        NavigationStack {
            
            List {
                ForEach(filteredByDateTasks) { item in
                    TaskViewPreview(item: item)
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
                //let cat = self.category.name
                $tasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
                $tasks.predicates = [
                    .whereField("dueDate", isNotIn: [""]),
                    .isEqualTo("isDone", false),
                    .order(by: "dueDate", descending: true),
                    //.limit(to: 8)
                ]
                print(tasks)
                Task { @MainActor in
                    //try await Task.sleep(seconds: 0.5)
                    try await self.filterTasks()
                }
                
                
                
            }
            
            
            .navigationTitle("Heute zu erledigen")
            
            
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                    }
                    
                }
            }
            
            
            
        }
        .onAppear() {
            //print("onapear ran")
            //let cat = self.category.name
            $tasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
            $tasks.predicates = [
                .whereField("dueDate", isNotIn: [""]),
                .isEqualTo("isDone", false),
                .order(by: "dueDate", descending: true),
                //.limit(to: 8)
            ]
            Task { @MainActor in
                try await Task.sleep(seconds: 0.1)
                try await self.filterTasks()
            }
            
        }
    }
        
}
    




struct TodayTaskListViewPreview: PreviewProvider {
    static var previews: some View {
        TodayTaskListView(currentUser: User(id: "234j3i4j34kl3j43l", firstName: "Chris", lastName: "Zimmermann", email: "chris.zimmermann@hotmail.ch", joined: Date().timeIntervalSince1970))
    }
}
