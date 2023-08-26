//
//  ProfileView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel = ProfileViewViewModel()
    
    
    var body: some View {
        
        NavigationStack {
            VStack {
                if let user = viewModel.user {
                    VStack(spacing: 20) {
                        Text(user.firstName)
                        Text(user.lastName)
                        Text(user.id)
                        Text(user.email)
                        
                        Button {
                            print("tapped logout")
                            viewModel.logout()
                        } label: {
                            Text("Logout")
                                .frame(width: 330)
                                .padding(.vertical, 2.5)
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .accentColor(Color.blue)
                        .cornerRadius(8)
                        .padding(.top, 10)
                        
                    }
                    
                    
                } else {
                    LoadingView()
                }
                
                
                
                
            }
            
            
            
                .navigationTitle("User Profil")
        }
        .onAppear {
            viewModel.getUser()
        }
        
        
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
