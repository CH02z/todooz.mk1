//
//  LoginView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel = LoginViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
           
            
            VStack() {
                
                Spacer()
                
                
                Image("Instagram-logo-text")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .padding(.bottom, 20)
                
                
                TextField("Enter your Email", text: $email)
                    .textFieldStyle(RoundTextFieldStyle())
                    .padding(.horizontal, 20)
             
              
                
                SecureField("Enter your Password", text: $password)
                    .textFieldStyle(RoundTextFieldStyle())
                    .padding(.horizontal, 20)
                
                
                
                Button {
                    print("forgot pw")
                } label: {
                    Text("Forgot Password")
                        .foregroundColor(Color.blue)
                        .font(.footnote)
                        .padding(.trailing, 28)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                
                Button {
                    viewModel.email = self.email
                    viewModel.password = self.password
                    Task { try await viewModel.login() }
                } label: {
                    Text("Login")
                        .frame(width: 330)
                        .padding(.vertical, 2.5)
                    
                }
                .buttonStyle(.borderedProminent)
                .accentColor(Color.blue)
                .cornerRadius(8)
                .padding(.top, 10)
                .disabled(self.email.isEmpty || self.password.isEmpty)
                
                
                HStack {
                    Rectangle()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                    //(UIScreen.main.bounds.width / 2)
                    Text("OR")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Rectangle()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                    
                }.foregroundColor(.gray)
                    .padding(.vertical, 20)
                

                
                
                Button(action: {
                    Task { await viewModel.signInWithGoogle() }
                }) {
                    HStack {
                        Image("Google-logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                        Text("Continue with Google")
                            .fontWeight(.semibold)
                            .font(.body)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    
                }
                .border(Color.gray, width: 1.5, cornerRadius: 20)
                    .padding(.vertical, 5)
                    .frame(width: 400)
                
                Button(action: {
                    print("apple button tapped!")
                }) {
                    HStack {
                        Image("Apple-logo-white")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                        Text("Sign in with Apple")
                            .fontWeight(.light)
                            .font(.body)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 70)
                    .padding(.vertical, 13)
                    .background(.black)
                    .foregroundColor(.white)
                    
                }
                .cornerRadius(20)
                .frame(width: 600)
                
                
                
                Spacer()
                
                
                
                
                
                
                
            }
            .padding(.top, 40)
            
            Divider()
            
            NavigationLink {
                AddEmailView()
            } label: {
                Text("Don't have an Account Yet?")
                Text("Sign up")
                    .fontWeight(.semibold)
            }
            .padding(.vertical, 20)
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
