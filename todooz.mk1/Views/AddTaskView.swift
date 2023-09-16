//
//  AddTodoView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 02.09.23.
//

import SwiftUI

struct AddTaskView: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    @StateObject var viewModel: AddTaskViewModel
    @Binding var isPresented: Bool
    
    //Input Properties
    let allCategories: [Category]
    let originalCat: String
    
    //used for Picker
    var categories: [String] = []
    
    
    
    
    init(isPresented: Binding<Bool>, allCategories: [Category], originalCat: String) {
        self._viewModel = StateObject(wrappedValue: AddTaskViewModel(originalCat: originalCat))
        self._isPresented = isPresented
        self.allCategories = allCategories
        self.originalCat = originalCat
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
                    if viewModel.title.trimmingCharacters(in: .whitespaces).isEmpty {
                        HStack {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .padding(.vertical, 2.5)
                            Text("Titel darf nicht leer sein")
                                .font(.footnote)
                                .foregroundColor(.red)
                        }
                        
                    }
                    
                    Section {
                        TextField("Notizen", text: $viewModel.description,  axis: .vertical)
                            .lineLimit(5...10)
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
                    
                    //Due Date Sections
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
                        .onChange(of: viewModel.letPickDate) { newValue in
                            //If no Date is selected, user reminders is deactivated
                            if newValue == false {
                                viewModel.useReminder = false
                            }
                        }
                        
                        if viewModel.letPickDate && viewModel.dueDate <= Calendar.current.date(byAdding: .minute, value: -5, to: Date())! {
                            HStack {
                                Image(systemName: "xmark")
                                    .foregroundColor(.red)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .padding(.vertical, 2.5)
                                Text("Datum darf nicht in der Vergangenheit liegen")
                                    .font(.footnote)
                                    .foregroundColor(.red)
                            }
                            
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
                    
                    if viewModel.letPickDate {
                        // Reminder Section
                        Section {
                            HStack {
                                Image(systemName: "bell")
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                                    .background(.purple)
                                    .cornerRadius(5)
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .padding(.vertical, 2.5)
                                
                                Text("Erinnern")
                                
                                //Datum toggle
                                Toggle("", isOn: $viewModel.useReminder)
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                
                            }
                            
                            if viewModel.useReminder && viewModel.reminderDateisPastDate() {
                                HStack {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.red)
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .padding(.vertical, 2.5)
                                    Text("Reminder Zeit kann nicht in der Vergangenheit liegen.")
                                        .font(.footnote)
                                        .foregroundColor(.red)
                                }
                                
                            }
                            
                            
                            
                            if viewModel.useReminder {
                                Picker("\(viewModel.selectedUnit) vorher:", selection: $viewModel.selectedUnit) {
                                    
                                    ForEach(viewModel.reminderUnits, id: \.self){
                                        
                                        Text($0)
                                        
                                    }
                                }
                                .pickerStyle(.menu)
                                
                            }
                            
                            if viewModel.selectedUnit == "Hours" && viewModel.useReminder {
                                Picker("", selection: $viewModel.reminderValue){
                                    ForEach(1..<13, id: \.self) { i in
                                        Text("\(i)").tag(i)
                                    }
                                }.pickerStyle(WheelPickerStyle())
                                
                            }
                            
                            if viewModel.selectedUnit == "Minutes" && viewModel.useReminder {
                                Picker("", selection: $viewModel.reminderValue){
                                    ForEach(1..<60, id: \.self) { i in
                                        Text("\(i)").tag(i)
                                    }
                                }.pickerStyle(WheelPickerStyle())
                                
                            }
                            
                            if viewModel.selectedUnit == "Days" && viewModel.useReminder {
                                Picker("", selection: $viewModel.reminderValue){
                                    ForEach(1..<7, id: \.self) { i in
                                        Text("\(i)").tag(i)
                                    }
                                }.pickerStyle(WheelPickerStyle())
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    
                    
                    
                    Section {
                        //High Priority Toggle
                        Toggle("Hohe Priorität", isOn: $viewModel.isHighPriority)
                        //.padding(.vertical, 3)
                    }
                    
                    Section {
                        //Marked Toggle
                        Toggle("Markiert", isOn: $viewModel.isMarked)
                        //.padding(.vertical, 3)
                    }
                    
                    
                    
                }
                
            }
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("abbrechen")
                            .foregroundColor(Color(hex: accentColor))
                    }
                    
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Neuer Task")
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
                        Text("hinzufügen")
                            .foregroundColor(Color(hex: accentColor))
                    }
                    .disabled(!viewModel.formIsValid())
                    
                }
                
                
                
            }
        }
        
        
        
        
        
    }
}

struct AddTaskView_Previews: PreviewProvider {
    @State var isPresented: Bool = false
    static var previews: some View {
        AddTaskView(isPresented: .constant(true), allCategories: [TestData.categories[0]], originalCat: "Swisscom")
    }
}
