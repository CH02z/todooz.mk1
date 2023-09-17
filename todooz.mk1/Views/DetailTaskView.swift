//
//  TaskDetailView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 03.09.23.
//

import SwiftUI

struct DetailTaskView: View {
    
    @Binding var task: Tasc
    let allCategories: [Category]
    
    @State var subTasks: [SubTasc] = []
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    @Binding var isPresented: Bool
    
    
    var body: some View {
        NavigationView {
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
                    
                    if task.dueDate != "" {
                        Label("\(task.dueDate)", systemImage: "calendar")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    
                    
                }
                
                if task.notificationID != "" {
                    Label("\(task.reminderValue) \(task.reminderUnit) vorher", systemImage: "bell")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                }
                
                Text(task.description ?? "Keine Beschreibung")
                    .font(.body)
                    .padding()
                
                List {
                    ForEach(self.subTasks, id: \.self) { sbtask in
                        HStack {
                            Text(sbtask.title)
                                .strikethrough(sbtask.isDone)
                            Spacer()
                            Image(systemName: sbtask.isDone ? "checkmark.circle" : "circle")
                                .foregroundColor(Color(hex: accentColor))
                                .font(.system(size: 25))
                        }.onTapGesture {
                            //Haptic Feedback on Tap
                            var upadedSubtask = sbtask
                            upadedSubtask.isDone.toggle()
                            self.subTasks = self.subTasks.filter { subtsk in
                                //return all subtasks except the edited one
                                return subtsk.id != upadedSubtask.id
                            }
                            //add toggled Subtask to new list of subtaks
                            self.subTasks.append(upadedSubtask)
                            
                            
                            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                            impactHeavy.impactOccurred()
                            Task { try await TaskService.shared.updateSubTask(taskID: task.id, subtasks: self.subTasks)}
                        }
                        
                    }
                }
                
                
                Spacer()
                
                
                
            }
            .onAppear() {
                self.subTasks = task.subtasks
            }
            .padding(.top, 50)
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                        
                    } label: {
                        Text("schliessen")
                            .foregroundColor(Color(hex: accentColor))
                    }
                    
                }
            }
            
            
        }
        
        
        
    }
}
    

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTaskView(task: .constant(TestData.tasks[0]), allCategories: [TestData.categories[0]], isPresented: .constant(true))
    }
}
