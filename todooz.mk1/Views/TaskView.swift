//
//  TodoListItemView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 01.09.23.
//

import SwiftUI

struct TaskView: View {
    
    //@Binding var checked: Bool
    
    
    var item: Tasc
    
    var body: some View {
        
        
        HStack {
            VStack(alignment: .leading) {
                Text(item.title)
                    .font(.body)
                    .fontWeight(.semibold)
                Text(item.dueDate)
                    
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            Spacer()
            
            Image(systemName: item.isDone ? "circle.fill" : "circle")
                .foregroundColor(item.isDone ? Color(UIColor.systemBlue) : Color.purple)
                .font(.system(size: 30))
                .onTapGesture {
                    //Haptic Feedback on Tap
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    
                    //item.isDone.toggle()
                }
            
            
        }
        
        
    }
}

struct TodoListItemView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView(item: Tasc(id: "dfadf684923!", title: "CR1 neu starten", category: "Swisscom", dueDate: getCurrentDateString(), isDone: false, dateCreated: getCurrentDateString(), isHighPriority: false))
    }
}