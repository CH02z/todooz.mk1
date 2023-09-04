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
    
    
    var body: some View {
        VStack {
            Text("Neue Kategorie")
                .bold()
                .font(.system(size: 32))
                .padding(.top, 30)
            
            Form {
                //Title
                TextField("Name", text: $viewModel.name)
                    .textFieldStyle(RoundTextFieldStyle())
                    .submitLabel(.next)
                
           
                
                
                
                TextField("Beschreibung", text: $viewModel.description,  axis: .vertical)
                    .lineLimit(5...10)
                    .textFieldStyle(RoundTextFieldStyle())
                
                
                
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
        
        
    }
}

struct AddCategoryView_Previews: PreviewProvider {
    @State var isPresented: Bool = false
    static var previews: some View {
        AddCategoryView(isPresented: .constant(true) )
    }
}
