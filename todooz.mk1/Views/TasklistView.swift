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
    
    @State var showAddItemSheet: Bool = false
    
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
                            
                            Button("löschen") {
                                Task { try await viewModel.deleteTask(taskID: item.id) }
                            }
                            .tint(.red)
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
            
            
            
            
            .toolbar {
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
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                        //.font(.system(size: 20))
                    }
                    
                }
                
                
            }
            
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
                    .background(Color("ElementBackround"),
                                in: Capsule())
                    .padding(.leading)
                    .symbolVariant(.circle.fill)
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
