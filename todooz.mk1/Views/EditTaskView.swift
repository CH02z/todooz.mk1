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
        VStack {
            Text("Task bearbeiten")
                .bold()
                .font(.system(size: 32))
                .padding(.top, 30)
            
            Form {
                
                //Title
                TextField("Titel", text: $viewModel.title)
                    .textFieldStyle(RoundTextFieldStyle())
                    .submitLabel(.next)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(.red)
                        .cornerRadius(5)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .padding(.vertical, 2.5)
                    
                    Text("Datum")
                    
                    //Datum toggle
                    Toggle("", isOn: $viewModel.letPickDate)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .trailing)
  
                }
                
                
                
                
                //Due Data
                if viewModel.letPickDate && !viewModel.letPickDateAndTime {
                    Text("Zu erldigen bis:")
                    DatePicker("Zu erledigen bis", selection: $viewModel.dueDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                if viewModel.letPickDate && viewModel.letPickDateAndTime {
                    Text("Zu erldigen bis:")
                    DatePicker("Zu erledigen bis", selection: $viewModel.dueDate)
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
                
                
                
                TextField("Notizen", text: $viewModel.description,  axis: .vertical)
                    .lineLimit(5...10)
                    .textFieldStyle(RoundTextFieldStyle())
                
                
                //High Priority Toggle
                Toggle("Hohe Priorität", isOn: $viewModel.isHighPriority)
                    .padding(.vertical, 3)
                
                //Categeory Selection
                Picker("Kategorie", selection: $viewModel.categorySelection) {
                    
                    ForEach(categories, id: \.self){

                        Text($0)

                                }
                            }
                .pickerStyle(.menu)
                .padding(.vertical, 3)
                
                Button {
                    //Haptic Feedback on Tap
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    Task { try await viewModel.save()}
                    isPresented = false
                    
                } label: {
                    Text("hinzufügen")
                        .padding(.vertical, 2.5)
                        .frame(maxWidth: .infinity)
                    
                }
                .buttonStyle(.borderedProminent)
                .accentColor(Color.blue)
                .cornerRadius(8)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 20)
                
                .disabled(!viewModel.formIsValid())
              
            }
  
        }
        .onAppear() {
         
        }
        
        
    }
}

struct EditTodoView_Previews: PreviewProvider {
    @State var isPresented: Bool = false
    static var previews: some View {
        EditTaskView(isPresented: .constant(true), allCategories: [TestData.categories[0]], editTask: TestData.tasks[0])
    }
}
