//
//  AddEmailView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct AddEmailView: View {
    
    @ObservedObject var viewModel = RegistrationViewModel()
    
    @State private var email: String = ""
    
    
    var body: some View {
        VStack(spacing: 12) {
            
            Text("Email hinzufügen")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Die Email wird als Benutzername gebraucht, um dich anzumelden")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundTextFieldStyle())
                .padding(.horizontal, 20)
                .autocapitalization(.none)
            
            if !self.email.isEmpty {
                VStack(alignment: .leading) {
                    
                    if viewModel.isValidEmail(self.email) {
                        Label("Email is gültig", systemImage: "checkmark")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    } else {
                        Label("Email ist ungültig", systemImage: "xmark")
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                }
                
            }
            
            NavigationLink {
                SetPasswordView(InputEmail: self.email)
            } label: {
                Text("weiter")
                    .fontWeight(.semibold)
                    .frame(width: 350)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
            }.disabled(!viewModel.isValidEmail(self.email))
            
            
            
            
            Spacer()
            
        }
    }
}

struct AddEmailView_Previews: PreviewProvider {
    static var previews: some View {
        AddEmailView()
    }
}
