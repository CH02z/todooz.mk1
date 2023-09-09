//
//  AddTodoView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 02.09.23.
//

import SwiftUI

struct AddCategoryView: View {
    
    @ObservedObject var viewModel = AddCategoryViewModel()
    @Binding var isPresented: Bool
    
    private let colors:[Color] = [.red, .yellow, .orange, .purple, .blue, .indigo, .green, .mint, .black]
    @State var selectedColor: Color
    
    private let icons: [String] = ["list.bullet", "car.fill", "house.fill", "person.fill", "dumbbell.fill", "desktopcomputer"]
    @State var selectedIcon: String
    
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Form {
                    
                    HStack {
                        
                        Image(systemName: selectedIcon)
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(selectedColor)
                            .clipShape(Circle())
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                        
                        TextField("Name", text: $viewModel.name)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .submitLabel(.next)
                    }
                    
                    
                    Section {
                        TextField("Beschreibung", text: $viewModel.description,  axis: .vertical)
                            .lineLimit(5...10)
                    }
                    
                    
                    Section {
                        //Color Picker Section
                        Grid() {
                            GridRow {
                                    ForEach(0...4, id: \.self) { index in
                                        Circle()
                                            .foregroundColor(colors[index])
                                            .frame(width: 40, height: 40)
                                            .overlay(Circle().stroke(Color.gray, lineWidth: colors[index] == selectedColor ? 4 : 0))
                                            .padding(.horizontal, 8)
                                            .padding(.bottom, 10)
                                            .onTapGesture {
                                                selectedColor = colors[index]
                                            }
                                    }
                                
                                
                            }
                            GridRow {
                                ForEach(5...8, id: \.self) { index in
                                    Circle()
                                        .foregroundColor(colors[index])
                                        .frame(width: 40, height: 40)
                                        .overlay(Circle().stroke(Color.gray, lineWidth: colors[index] == selectedColor ? 4 : 0))
                                        .onTapGesture {
                                            selectedColor = colors[index]
                                        }
                                }
                            }
                            
                            
                        }
                    }
                    
                    
                    Section {
                        //Icon Picker Section
                        Grid() {
                            GridRow {
                                    ForEach(0...5, id: \.self) { index in
                                        
                                        Image(systemName: icons[index])
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .background(Color(.systemGray4))
                                            .overlay(Circle().stroke(Color.gray, lineWidth: icons[index] == selectedIcon ? 4 : 0))
                                            .padding(.horizontal, 4)
                                            .clipShape(Circle())
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .onTapGesture {
                                                selectedIcon = icons[index]
                                            }
                                        

                                    }
                                
                                
                            }
                            
                            
                        }
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
                    Text("Neue Kategorie")
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
                    }
                    .disabled(!viewModel.formIsValid())
                    
                }
                
                
                
            }
            
        }
        
        
        
        
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    @State var isPresented: Bool = false
    static var previews: some View {
        AddCategoryView(isPresented: .constant(true), selectedColor: .blue, selectedIcon: "list.bullet")
    }
}
