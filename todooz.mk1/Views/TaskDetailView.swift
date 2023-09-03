//
//  TaskDetailView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 03.09.23.
//

import SwiftUI

struct TaskDetailView: View {
    
    var task: Tasc
    
    var body: some View {
        VStack(spacing: 20) {
       
            
            Text(task.title)
                .font(.title2)
                //.font(.system(size: 28))
                .fontWeight(.semibold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            HStack(spacing: 40) {
                Label("\(task.category)", systemImage: "list.bullet")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                
                Label("\(task.dueDate ?? "Kein Datum")", systemImage: "calendar")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
            
            Text(task.description != "" ? task.description! : "Keine Beschreibung")
                .font(.body)
                .padding()
            
            Spacer()
            
        }
        .padding(.top, 50)
    }
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(task: Tasc(id: "dfadf684923!", title: "CR1 neu starten", category: "Swisscom", dueDate: getCurrentDateString(), isDone: false, description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.", dateCreated: getCurrentDateString(), isHighPriority: false))
    }
}
