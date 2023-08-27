//
//  SetPasswordView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct SetPasswordView: View {
    
    var InputEmail: String
    
    @ObservedObject var viewModel = RegistrationViewModel()
    
    //Password Data and Validation
    @State private var PasswordEntry: String = ""
    @State private var PasswordReEntry: String = ""
    @State private var ShowPassword: Bool = false
    @State private var IsSecPassword: Bool = false
    
    
    
    
    var body: some View {
        VStack(spacing: 12) {
            
            Text("Create a Password")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("You'll use this email to sign in to your account")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            
            
            HStack {
                if ShowPassword {
                    TextField("password", text: $PasswordEntry)
                        .textFieldStyle(RoundTextFieldStyle())
                        .padding(.horizontal, 20)
                } else {
                    SecureField("password", text: $PasswordEntry)
                        .textFieldStyle(RoundTextFieldStyle())
                        .padding(.horizontal, 20)
                }
                
                if PasswordEntry != "" {
                    Button {
                        self.ShowPassword.toggle()
                    } label: {
                        Image(systemName: ShowPassword ? "eye.slash" : "eye")
                            .padding(.trailing, 25)
                    }
                }
            }
            
            
            
            
            
            if PasswordEntry != "" {
                if ShowPassword {
                    TextField("password (verify)", text: $PasswordReEntry)
                        .textFieldStyle(RoundTextFieldStyle())
                        .padding(.horizontal, 20)
                } else {
                    SecureField("password (verify)", text: $PasswordReEntry)
                        .textFieldStyle(RoundTextFieldStyle())
                        .padding(.horizontal, 20)
                }
            }
            
            
            
            // Validation Labels--------------------------------------------
            
            VStack(alignment: .leading) {
                if !PasswordEntry.isEmpty && !PasswordReEntry.isEmpty {
                    if PasswordEntry != PasswordReEntry {
                        Label("Passwords entered do not match", systemImage: "xmark")
                            .foregroundColor(.red)
                            .font(.subheadline)
                    } else {
                        Label("Passwords entered match", systemImage: "checkmark")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    }
                }
                if !PasswordEntry.isEmpty {
                    if IsSecPassword {
                        Label("Passwords passed all security checks", systemImage: "checkmark")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    } else{
                        Label("Password does not meet the security requirements: [a-z], [A-Z], min. length 8 characters, at least 1 special character and Number", systemImage: "xmark")
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                }
                
            }
            .padding(.horizontal, 10)
            
            
            
            NavigationLink {
                FinalRegistrationView(InputEmail: self.InputEmail, InputPW: self.PasswordReEntry)
            } label: {
                Text("Next")
                    .fontWeight(.semibold)
                    .frame(width: 350)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
            }
            .disabled(!self.IsSecPassword || PasswordEntry.isEmpty || PasswordReEntry.isEmpty || PasswordEntry != PasswordReEntry)
            
            
            Spacer()
            
        }
        .onChange(of: PasswordEntry, perform: { value in
                            self.IsSecPassword = viewModel.isSecurePassword(password: value)
                        })
    }
}

struct SetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        SetPasswordView(InputEmail: "chris.zimmermann@hotmail.ch")
    }
}
