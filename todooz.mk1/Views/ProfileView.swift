//
//  ProfileView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel = ProfileViewViewModel()
    
    let currentUser: User?
    
    
    var body: some View {
        
        NavigationStack {
            VStack {
                if let user = currentUser {
                    VStack(spacing: 20) {
                        Text(user.firstName)
                        Text(user.lastName)
                        Text(user.id)
                        Text(user.email)
                        
                        Button {
                            print("tapped logout")
                            Task { try await viewModel.logout() }
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
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(currentUser: User(id: "234j3i4j34kl3j43l", firstName: "Chris", lastName: "Zimmermann", email: "chris.zimmermann@hotmail.ch", joined: Date().timeIntervalSince1970))
    }
}
