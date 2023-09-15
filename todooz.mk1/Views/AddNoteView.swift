//
//  AddNoteView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 13.09.23.
//

import SwiftUI

struct AddNoteView: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    @ObservedObject var viewModel = AddNoteViewModel()
    @Binding var isPresented: Bool
    
    
    var body: some View {
        
        
        NavigationView {
            
            VStack {
                
                
                
                Form {
                    
                                      
                    Section {
                        TextField("Beschreibung", text: $viewModel.text,  axis: .vertical)
                            .padding()
                            .lineLimit(5...10)
                            .font(.body)
                            .foregroundColor(.black)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        
                    }
                    .background(Color(hex: viewModel.selectedColor))
                    .cornerRadius(15)
                    
                    
                    
                    
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
                            
                            
                        }
                    }
                    
                    
                    if viewModel.text.trimmingCharacters(in: .whitespaces).isEmpty {
                        HStack {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .padding(.vertical, 2.5)
                            Text("Notiz darf nicht leer sein")
                                .font(.footnote)
                                .foregroundColor(.red)
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
                    Text("Neue Notiz")
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

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView(isPresented: .constant(true))
    }
}
