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
    
    let allCategories: [Category]
    let currentUser: User?
    
    //Sheets
    @State var showAddItemSheet: Bool = false
    @State var showDetailTaskSheet: Bool = false
    
    @State var detailTask: Tasc = TestData.tasks[0]
    @State var editTask: Tasc = TestData.tasks[0]
    
    //Sorting
    let sortOptions: [String] = ["Titel", "Datum"]
    @State var sortingSelection: String = "Datum"
    @State var sortingField: String = "dueDate"
    
    
    
    @FirestoreQuery(collectionPath: "users") var tasks: [Tasc]
    @ObservedObject var viewModel = TaskListViewModel()
    
    private func filterTasks() {
        let cat = self.category.name
        $tasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
        $tasks.predicates = [
            .isEqualTo("category", cat),
            .whereField("isDone", isEqualTo: false),
            .order(by: sortingField, descending: sortingField == "dueDate" ? true : false),
        ]
    }
    
    
    
    
    //Test Data
    var testItems: [Tasc] = TestData.tasks
    
    
    
    
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
                    Text("In dieser Kategorie wurden noch keine Tasks hinzugefügt")
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
            
            
            .navigationTitle(category.name)
            .navigationBarTitleDisplayMode(.large)
            
            .sheet(isPresented: $showAddItemSheet, content: {
                AddTaskView(isPresented: $showAddItemSheet, allCategories: allCategories, originalCat: category.name)
            })
            
            .sheet(isPresented: $showDetailTaskSheet, content: {
                DetailTaskView(task: $detailTask, allCategories: allCategories, isPresented: $showDetailTaskSheet)
            })

            
            
            
            .toolbar {
                
                /*
                 ToolbarItem(placement: .navigationBarTrailing) {
                 Button {
                 
                 } label: {
                 Image(systemName: "square.and.arrow.up")
                 //.font(.system(size: 20))
                 }
                 
                 }
                 
                 
                 You can write a description on multiple lines here.
                 */
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Menu {
                        Picker("sortieren", selection: $sortingSelection) {
                            ForEach(sortOptions, id: \.self){
                                Text($0)
                            }
                        }.onChange(of: self.sortingSelection) { newValue in
                            print(newValue)
                            switch newValue {
                            case "Titel":
                                self.sortingField = "title"
                            case "Datum":
                                self.sortingField = "dueDate"
                            default:
                                self.sortingField = "dueDate"
                            }
                            filterTasks()
                        }
                        
                        
                    } label: {
                        Text("Sortieren")
                    }
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        
                        //Haptic Feedback on Tap
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        self.showAddItemSheet = true
                        
                    } label: {
                        Image(systemName: "plus")
                        //.font(.system(size: 25))
                        
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





struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        TasklistView(category: TestData.categories[0], allCategories: [], currentUser: TestData.users[0])
    }
}
