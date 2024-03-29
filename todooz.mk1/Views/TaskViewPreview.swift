//
//  TodoListItemView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import SwiftUI

struct TaskViewPreview: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"   
    @ObservedObject var viewModel = TaskViewPreviewViewModel()
    
    @State var showDetailTaskSheet: Bool = false
    
    var item: Tasc
    let allCategories: [Category]
    
    var body: some View {
        
        
        HStack {
            
            if item.isHighPriority {
                Image(systemName: "exclamationmark")
                    .foregroundColor(Color.red)
                    .font(.system(size: 20))
                    .padding(.horizontal, 5)
            }
            
            if item.isMarked {
                Image(systemName: "flag")
                    .foregroundColor(Color.orange)
                    .font(.system(size: 20))
                    .padding(.horizontal, 5)
            }
            
            if item.dueDate != "" && dateIsInPast(inputDate: getDateFromString(dateString: item.dueDate)) {
                Image(systemName: "clock.badge.exclamationmark")
                    .foregroundColor(Color.red)
                    .font(.system(size: 20))
                    .padding(.horizontal, 5)
            }
            
            if item.notificationID != "" {
                Image(systemName: "bell")
                    .foregroundColor(Color.purple)
                    .font(.system(size: 20))
                    .padding(.horizontal, 5)
            }
            
            if item.subtasks.count > 0 {
                Image(systemName: "list.bullet")
                    .foregroundColor(Color.green)
                    .font(.system(size: 20))
                    .padding(.horizontal, 5)
            }
            
            
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .strikethrough(viewModel.isStrikedThrough)
                
                if item.dueDate != "" {
                    Text(item.dueDate)
                        .foregroundColor(Color(.secondaryLabel))
                }
              
            }
            
            //.onTapGesture {
              //  self.showDetailTaskSheet = true
            //}
            
            Spacer()
            
            Image(systemName: viewModel.isStrikedThrough ? "checkmark.circle" : "circle")
                .foregroundColor(Color(hex: accentColor))
                .font(.system(size: 30))
                .onTapGesture {
                    //Haptic Feedback on Tap
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    Task { try await viewModel.toggleTask(finishedTaskID: item.id, currentState: item.isDone, notificationID: item.notificationID) }
                }
            
            
        }
        .frame(height: 40)
        
        
    }
}

struct TodoListItemView_Previews: PreviewProvider {
    static var previews: some View {
        TaskViewPreview(item: TestData.tasks[1], allCategories: [TestData.categories[0]])
    }
}
