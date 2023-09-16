//
//  TodoListItemView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import SwiftUI

struct IsDoneTaskViewPreview: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    @ObservedObject var viewModel = TaskViewPreviewViewModel()
    
    
    @State var isStrikedThrough: Bool = true;
    
    var item: Tasc
    let allCategories: [Category]
    
    
    func deleteTask(taskID: String, notficationID: String) async throws {
        try await TaskService.shared.deleteTask(taskID: taskID, notificationID: notficationID)
    }
    
    
    @MainActor
    func toggleTask(finishedTaskID: String, currentState: Bool) async throws {
        self.isStrikedThrough.toggle()
        try await Task.sleep(seconds: 2.0)
        try await TaskService.shared.toggleTask(finishedTaskID: finishedTaskID, currentState: currentState)
        self.isStrikedThrough.toggle()
    }
    
    
    var body: some View {
        
        
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .strikethrough(self.isStrikedThrough)
              
            }
            
            Spacer()
            
            Image(systemName: self.isStrikedThrough ? "checkmark.circle" : "circle")
                .foregroundColor(Color(hex: accentColor))
                .font(.system(size: 30))
                .onTapGesture {
                    //Haptic Feedback on Tap
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    Task { try await viewModel.toggleTask(finishedTaskID: item.id, currentState: item.isDone) }
                }
            
            
        }
        .frame(height: 40)
        
        
    }
}

struct IsDoneTaskViewPreview_Previews: PreviewProvider {
    static var previews: some View {
        IsDoneTaskViewPreview(item: TestData.tasks[1], allCategories: [TestData.categories[0]])
    }
}
