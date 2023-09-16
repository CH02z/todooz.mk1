//
//  LoginView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct LoginView: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    @ObservedObject var viewModel = LoginViewModel()
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
           
            
            VStack() {
                
                Spacer()
                
                
                Image("todoozlogo_test1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .padding(.bottom, 40)
                
                
                TextField("Email eingeben", text: $email)
                    .textFieldStyle(RoundTextFieldStyle())
                    .padding(.horizontal, 20)
             
              
                
                SecureField("Passwort eingeben", text: $password)
                    .textFieldStyle(RoundTextFieldStyle())
                    .padding(.horizontal, 20)
                
                
                
                Button {
                    //print("forgot pw")
                } label: {
                    Text("Passwort vergessen?")
                        .foregroundColor(Color.blue)
                        .font(.footnote)
                        .padding(.trailing, 28)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                
                Button {
                    //Haptic Feedback on Tap
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    viewModel.email = self.email
                    viewModel.password = self.password
                    Task { try await viewModel.login() }
                } label: {
                    Text("Login")
                        .frame(width: 330)
                        .padding(.vertical, 2.5)
                    
                }
                .buttonStyle(.borderedProminent)
                .accentColor(Color(hex: accentColor))
                .cornerRadius(8)
                .padding(.top, 10)
                .disabled(self.email.isEmpty || self.password.isEmpty)
                
                
                HStack {
                    Rectangle()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                    //(UIScreen.main.bounds.width / 2)
                    Text("Oder")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Rectangle()
                        .frame(width: (UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                    
                }.foregroundColor(.gray)
                    .padding(.vertical, 20)
                

                
                
                Button(action: {
                    //Haptic Feedback on Tap
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    Task { await viewModel.signInWithGoogle() }
                }) {
                    HStack {
                        Image("Google-logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                        Text("Weiter mit Google")
                            .font(.body)
                            .foregroundColor(Color("MainFontColor"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    
                }
                .padding(.vertical, 8)
                //.border(Color.gray, width: 1.5, cornerRadius: 20)
                
                Button(action: {
                    //Haptic Feedback on Tap
                    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                    impactHeavy.impactOccurred()
                    
                    print("apple button tapped!")
                }) {
                    HStack {
                        Image("Apple-logo-black")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                        Text("Anmelden mit Apple")
                            .fontWeight(.light)
                            .font(.body)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 70)
                    .padding(.vertical, 13)
                    .background(.white)
                    .foregroundColor(.black)
                    
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
                Text("Noch kein Account?")
                Text("Registrieren")
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
