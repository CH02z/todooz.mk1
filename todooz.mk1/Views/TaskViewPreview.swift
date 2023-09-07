//
//  TodoListItemView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import SwiftUI

struct TaskViewPreview: View {
    
    @ObservedObject var viewModel = TaskViewPreviewViewModel()
    
    @State var showDetailTaskSheet: Bool = false
    
    var item: Tasc
    let allCategories: [Category]
    
    
    
    
    var body: some View {
        
        
        HStack {
            
            
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .strikethrough(item.isDone)
                
                if item.dueDate! != "" {
                    Text(item.dueDate ?? "")
                        .foregroundColor(Color(.secondaryLabel))
                }
              
            }
            
            .onTapGesture {
                self.showDetailTaskSheet = true
            }
            
            Spacer()
            
            Image(systemName: item.isDone ? "checkmark.circle" : "circle")
                .foregroundColor(Color.purple)
                .font(.system(size: 30))
                .onTapGesture {
                    //Haptic Feedback on Tap
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    Task { try await viewModel.toggleTask(finishedTaskID: item.id, currentState: item.isDone) }
                }
            
            
        }
        .frame(height: 40)
        .sheet(isPresented: $showDetailTaskSheet, content: {
            
            DetailTaskView(task: item, allCategories: allCategories)
        })
        
        
    }
}

struct TodoListItemView_Previews: PreviewProvider {
    static var previews: some View {
        TaskViewPreview(item: TestData.tasks[1], allCategories: [TestData.categories[0]])
    }
}
