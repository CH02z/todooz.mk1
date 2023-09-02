//
//  AddTodoView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 02.09.23.
//

import SwiftUI

struct AddTodoView: View {
    
    @StateObject var viewModel: AddTodoViewModel
    
    init(category: Category) {
        self._viewModel = StateObject(wrappedValue: AddTodoViewModel(category: category))
    }
    
    
    var body: some View {
        VStack {
            Text("Neue Todo")
                .bold()
                .font(.system(size: 32))
                .padding(.top, 10)
            
            Form {
                //Title
                TextField("Titel", text: $viewModel.title)
                    .textFieldStyle(RoundTextFieldStyle())
                    .padding(.horizontal, 20)
                    .submitLabel(.next)
                
                //Due Data
                DatePicker("Zu erledigen bis", selection: $viewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                //High Priority Toggle
                Toggle("Hohe Priorität", isOn: $viewModel.isHighPriority)
                
                //Categeory Selection
                Picker("Kategorie", selection: $viewModel.categorySelection) {
                    ForEach(viewModel.TestCategories, id: \.self) {
                                    Text($0)
                                }
                            }
                .pickerStyle(.menu)
                
                Button {
                    //Haptic Feedback on Tap
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    //Safe
                } label: {
                    Text("hinzufügen")
                        .padding(.vertical, 2.5)
                    
                }
                .buttonStyle(.borderedProminent)
                .accentColor(Color.blue)
                .cornerRadius(8)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 20)
                .disabled(false)
                
                
                
            }
            
            .padding()
           
            
            
        }
        
        
    }
}

struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView(category: Category(id: "dkfjddk213", name: "Swisscom", dateCreated: getCurrentDateString(), lastModified: getCurrentDateString()))
    }
}
