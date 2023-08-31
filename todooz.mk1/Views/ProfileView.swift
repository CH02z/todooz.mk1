//
//  ProfileView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @ObservedObject var viewModel = ProfileViewViewModel()
    
    @State private var avatarItem: PhotosPickerItem?
    
    let currentUser: User?
    
    
    var body: some View {
        
        NavigationStack {
            VStack {
                if let user = currentUser {
                    VStack(spacing: 20) {
                        
                        VStack {
                            
                            ZStack(alignment: .top) {
                                Rectangle()
                                    .foregroundColor(.blue)
                                    .edgesIgnoringSafeArea(.top)
                                    .frame(height: 150)
                                
                                
                                
                                ZStack {
                                    if let image = viewModel.avatarImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 200, height: 200)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                            .shadow(radius: 10)
                                            .padding(.top, 50)
                                        
                                    } else {
                                        Image("memoji_white")
                                            .resizable()
                                            .scaledToFit()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 200, height: 200)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                            .shadow(radius: 10)
                                            .padding(.top, 50)
                                    }
                                    
                                }
                                
                            }
                            
                            
                            
                            ProfileText(firstName: user.firstName, lastName: user.lastName, email: user.email)
                        }
                        
                        
                        .onChange(of: avatarItem) { _ in
                            Task {
                                if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        viewModel.avatarImage = uiImage
                                        try await viewModel.uploadPhoto(image: uiImage)
                                        return
                                    }
                                }
                                
                                print("Failed")
                            }
                        }
                        
                        .onAppear { Task { try await viewModel.loadUserProfileImage() } }
                        
                        Spacer()
                        
                        Button {
                            print("tapped load image")
                            Task { try await viewModel.loadUserProfileImage() }
                        } label: {
                            Text("load image")
                                .padding(.vertical, 2.5)
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .accentColor(Color.blue)
                        .cornerRadius(8)
                        .padding(.top, 10)
                        
                        Button {
                            print("tapped logout")
                            Task { try await viewModel.logout() }
                        } label: {
                            Text("Logout")
                                .padding(.vertical, 2.5)
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .accentColor(Color.blue)
                        .cornerRadius(8)
                        .padding(.top, 10)
                        
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            
                            PhotosPicker(selection: $avatarItem, matching: .images) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.black)
                                    .font(.system(size: 30))
                            }
                            
                            
                        }
                    }
                    
                    
                } else {
                    LoadingView()
                    Text("Something Went Wrong")
                    Button {
                        print("tapped logout")
                        Task { try await viewModel.logout() }
                    } label: {
                        Text("Emergency Logout")
                            .frame(width: 330)
                            .padding(.vertical, 2.5)
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .accentColor(Color.red)
                    .cornerRadius(8)
                    .padding(.top, 10)
                }
                
                
            }
            
        }
        
    }
}


struct ProfileText: View {
    
    var firstName: String
    var lastName: String
    var email: String
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 5) {
                Text("\(firstName) \(lastName)")
                    .bold()
                    .font(.title)
                Text("\(email)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }.padding()
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }
}


struct PlusButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue)
                .frame(width: 50, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
            
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .bold))
        }
        .opacity(configuration.isPressed ? 0.7 : 1.0)
        .onTapGesture {
            //
        }
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(currentUser: User(id: "234j3i4j34kl3j43l", firstName: "Chris", lastName: "Zimmermann", email: "chris.zimmermann@hotmail.ch", joined: Date().timeIntervalSince1970))
    }
}
