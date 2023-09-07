//
//  TaskDetailView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 03.09.23.
//

import SwiftUI

struct DetailTaskView: View {
    
    var task: Tasc
    let allCategories: [Category]
    
    @State var showEditItemSheet: Bool = false
    
    
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
            
            Button {
                //Haptic Feedback on Tap
                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                impactHeavy.impactOccurred()
                //Task { try await viewModel.save()}
                showEditItemSheet = true
                
            } label: {
                Text("bearbeiten")
                    .padding(.vertical, 2.5)
                    .frame(maxWidth: .infinity)
                
            }
            .buttonStyle(.borderedProminent)
            .accentColor(Color.blue)
            .cornerRadius(8)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 20)
            
            .disabled(task.isDone)
            
            
        }
        .padding(.top, 50)
        .sheet(isPresented: $showEditItemSheet, content: {
            EditTaskView(isPresented: $showEditItemSheet, allCategories: allCategories, editTask: task)
            })
        
    }
}
    

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTaskView(task: TestData.tasks[1], allCategories: [TestData.categories[0]])
    }
}
