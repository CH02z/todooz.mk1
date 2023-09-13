//
//  FinalRegistrationView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct FinalRegistrationView: View {
    
    var InputEmail: String
    var InputPW: String
    
    @ObservedObject var viewModel = RegistrationViewModel()
    
    //Password Data and Validation
    @State private var PasswordEntry: String = ""
    @State private var PasswordReEntry: String = ""
    @State private var ShowPassword: Bool = false
    @State private var IsSecPassword: Bool = false
    
    
    
    var body: some View {
        VStack(spacing: 12) {
            
            Spacer()
            
            Text("Neuer Account")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Es wird ein neuer Account für folgenden Benutzer erstellt.")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            
            Text(self.InputEmail)
                .font(.body)
                .fontWeight(.semibold)
                .accentColor(.black)
            
            
            /*
             
             
             
             
             }
             */
            
            
            Button {
                viewModel.email = self.InputEmail
                viewModel.password = self.InputPW
                Task { try await viewModel.register() }
                
                
            } label: {
                Text("Registrieren")
                    .frame(width: 330)
                    .padding(.vertical, 2.5)
                
            }
            .buttonStyle(.borderedProminent)
            .accentColor(Color.blue)
            .cornerRadius(8)
            .padding(.top, 10)
            
            Spacer()
            
        }
    }
}

struct FinalRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        FinalRegistrationView(InputEmail: "chris.zimmermann@hotmail.ch", InputPW: "Test4CZ!!")
    }
}
