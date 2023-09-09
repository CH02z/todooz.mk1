//
//  AddTodoView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 02.09.23.
//

import SwiftUI

struct EditTaskView: View {
    
    @StateObject var viewModel: EditTaskViewModel
    @Binding var isPresented: Bool
    
    //used for Picker
    var categories: [String] = []
    
    
    
    
    init(isPresented: Binding<Bool>, allCategories: [Category], editTask: Tasc) {
        self._viewModel = StateObject(wrappedValue: EditTaskViewModel(taskID: editTask.id, title: editTask.title, category: editTask.category, dueDate: editTask.dueDate ?? "", description: editTask.description ?? "", isHighPriority: editTask.isHighPriority))
        self._isPresented = isPresented
        self.categories = allCategories.map({ category in
            return category.name
        })
    }
    
    //"Swisscom", "Privat", "Todooz", "Allgemein"
    
    var body: some View {
        NavigationView {
            
            VStack {
                Form {
                    
                    //Title
                    TextField("Titel", text: $viewModel.title)
                        .submitLabel(.next)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Section {
                        TextField("Notizen", text: $viewModel.description,  axis: .vertical)
                            .lineLimit(5...10)
                    }
                    
                    Section {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .background(.red)
                                .cornerRadius(5)
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .padding(.vertical, 2.5)
                            
                            Text("Zu erledigen bis:")
                            
                            //Datum toggle
                            Toggle("", isOn: $viewModel.letPickDate)
                                .labelsHidden()
                                .frame(maxWidth: .infinity, alignment: .trailing)
          
                        }
                        //Due Data
                        if viewModel.letPickDate && !viewModel.letPickDateAndTime {
                            DatePicker("only date", selection: $viewModel.dueDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                        }
                        
                        if viewModel.letPickDate && viewModel.letPickDateAndTime {
                            DatePicker("date and Time", selection: $viewModel.dueDate)
                                .datePickerStyle(GraphicalDatePickerStyle())
                        }
                        
                        if viewModel.letPickDate {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .background(.blue)
                                    .cornerRadius(5)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .padding(.vertical, 2.5)
                                
                                Text("Uhrzeit")
                                
                                //Datum toggle
                                Toggle("", isOn: $viewModel.letPickDateAndTime)
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity, alignment: .trailing)
              
                            }
                        }
                    }
                    
                    
                    
                    
                    Section {
                        //High Priority Toggle
                        Toggle("Hohe Priorität", isOn: $viewModel.isHighPriority)
                            //.padding(.vertical, 3)
                    }
                    
                    Section {
                        //Categeory Selection
                        Picker("Kategorie", selection: $viewModel.categorySelection) {
                            
                            ForEach(categories, id: \.self){

                                Text($0)

                                        }
                                    }
                        .pickerStyle(.menu)
                        
                    }
                    
                }
                
            }
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("abbrechen")
                    }
                    
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Task bearbeiten")
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //Haptic Feedback on Tap
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        Task { try await viewModel.save()}
                        isPresented = false
                    } label: {
                        Text("speichern")
                    }
                    .disabled(!viewModel.formIsValid())
                    
                }
                
                
                
            }
        }
        
        
    }
}

struct EditTodoView_Previews: PreviewProvider {
    @State var isPresented: Bool = false
    static var previews: some View {
        EditTaskView(isPresented: .constant(true), allCategories: [TestData.categories[0]], editTask: TestData.tasks[0])
    }
}
