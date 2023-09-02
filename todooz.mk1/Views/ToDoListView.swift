//
//  ToDoListView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 31.08.23.
//

import SwiftUI

struct ToDoListView: View {
    
    
    @State var showAddItemSheet: Bool = false
    
    
    
    let category: Category
    var items: [ToDoListItem] = TestData.todos
    
    var filteredItems: [ToDoListItem] {
        return items.filter { item in
            return item.category == category.name
        }
    }
    
   
    
  
    
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(filteredItems) { item in
                    TodoListItemView(item: item)
                        .swipeActions {
                            
                            
                            Button("löschen") {
                                //Delete
                            }
                            .tint(.red)
                            
                            
                        }
                        
                }
                
                
            }
            
            .refreshable {
                //reload in Task { get categories }
            }
            
            
            .navigationTitle(category.name)
            
            .sheet(isPresented: $showAddItemSheet, content: {
                AddTodoView(category: category)
            })
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                    }

                }
            }
            
            .safeAreaInset(edge: .bottom, alignment: .center) {
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
                                    .background(.gray.opacity(0.1),
                                                in: Capsule())
                                    .padding(.leading)
                                    .symbolVariant(.circle.fill)
                            }
                        }
            .padding(.bottom, 10)
            
            
            
        }
    }
}




struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(category: Category(id: "dkfjddk213", name: "Swisscom", dateCreated: getCurrentDateString()))
    }
}
