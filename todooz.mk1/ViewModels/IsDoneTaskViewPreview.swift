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
                    Task { try await viewModel.toggleTask(finishedTaskID: item.id, currentState: item.isDone, notificationID: item.notificationID) }
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
