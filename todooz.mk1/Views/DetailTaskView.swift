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
                
                Spacer()
                
                
                
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
        .onAppear() {
            print("Detail Task in View: \(task)")
        }
        
        
        
        
    }
}
    

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTaskView(task: .constant(TestData.tasks[0]), allCategories: [TestData.categories[0]], isPresented: .constant(true))
    }
}
