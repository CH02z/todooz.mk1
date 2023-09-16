//
//  AddTodoView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 02.09.23.
//

import SwiftUI

struct AddCategoryView: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    @ObservedObject var viewModel = AddCategoryViewModel()
    @Binding var isPresented: Bool

    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Form {
                    
                    HStack {
                        
                        Image(systemName: viewModel.selectedIcon)
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(Color(hex: viewModel.selectedColor))
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
                                            .foregroundColor(Color(hex: viewModel.colors[index]))
                                            .frame(width: 40, height: 40)
                                            .overlay(Circle().stroke(Color.gray, lineWidth: viewModel.colors[index] == viewModel.selectedColor ? 4 : 0))
                                            .padding(.horizontal, 8)
                                            .padding(.bottom, 10)
                                            .onTapGesture {
                                                viewModel.selectedColor = viewModel.colors[index]
                                            }
                                    }
                                
                                
                            }
                            GridRow {
                                ForEach(5...8, id: \.self) { index in
                                    Circle()
                                        .foregroundColor(Color(hex: viewModel.colors[index]))
                                        .frame(width: 40, height: 40)
                                        .overlay(Circle().stroke(Color.gray, lineWidth: viewModel.colors[index] == viewModel.selectedColor ? 4 : 0))
                                        .onTapGesture {
                                            viewModel.selectedColor = viewModel.colors[index]
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
                                        
                                        Image(systemName: viewModel.icons[index])
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .background(Color(.systemGray4))
                                            .overlay(Circle().stroke(Color.gray, lineWidth: viewModel.icons[index] == viewModel.selectedIcon ? 4 : 0))
                                            .padding(.horizontal, 4)
                                            .clipShape(Circle())
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .onTapGesture {
                                                viewModel.selectedIcon = viewModel.icons[index]
                                            }
                                        

                                    }
                            }
                            
                            GridRow {
                                    ForEach(6...9, id: \.self) { index in
                                        
                                        Image(systemName: viewModel.icons[index])
                                            .foregroundColor(.white)
                                            .frame(width: 40, height: 40)
                                            .background(Color(.systemGray4))
                                            .overlay(Circle().stroke(Color.gray, lineWidth: viewModel.icons[index] == viewModel.selectedIcon ? 4 : 0))
                                            .padding(.horizontal, 4)
                                            .clipShape(Circle())
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .onTapGesture {
                                                viewModel.selectedIcon = viewModel.icons[index]
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
                            .foregroundColor(Color(hex: accentColor))
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
                            .foregroundColor(Color(hex: accentColor))
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
        AddCategoryView(isPresented: .constant(true))
    }
}
