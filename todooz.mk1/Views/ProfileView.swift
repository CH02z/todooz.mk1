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
    
    // Try move this to View Model
    @State private var selectedPickerItem: PhotosPickerItem?
    
    let currentUser: User?
    
    
    var body: some View {
        
        NavigationStack {
            VStack {
                if let user = currentUser {
                    VStack() {
                        
                        ZStack {
                            
                            if let image = viewModel.avatarImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 10)
                                    .padding(.top, 30)
                            } else {
                                Image("memoji_white")
                                    .resizable()
                                    .scaledToFit()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 10)
                                    .padding(.top, 30)
                            }
                            
                            PhotosPicker(selection: $selectedPickerItem, matching: .images) {
                                Circle()
                                    .opacity(0.0)
                                    .frame(width: 150, height: 150)
                                    .padding(.top, 30)
                                
                            }
                            
                            
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .frame(width: 35, height: 35)
                                .background(.blue)
                                .clipShape(Circle())
                                .font(.system(size: 25))
                                .fontWeight(.bold)
                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                .padding(.leading, 130)
                                .padding(.top, 145)
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        VStack(spacing: 5) {
                            Text("\(user.firstName) \(user.lastName)")
                                .bold()
                                .font(.title)
                            Text("\(user.email)")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }.padding()
                        
                        
                        SettingsView()
                        
                        
                        
                        
                            .onChange(of: selectedPickerItem) { _ in
                                Task {
                                    if let data = try? await selectedPickerItem?.loadTransferable(type: Data.self) {
                                        if let uiImage = UIImage(data: data) {
                                            print("on change called")
                                            viewModel.avatarImage = uiImage
                                            await viewModel.uploadPhoto(image: uiImage)
                                            return
                                        }
                                    }
                                    
                                    print("Failed")
                                }
                            }
                        
                            .refreshable {
                                Task { try await viewModel.loadUserProfileImage() }
                            }
                        
      
                        Spacer()
                    }
                    
                    
                    
                } else {
                    LoadingView()
                    Text("Something Went Wrong")
                    Button {
                        print("tapped logout")
                        Task { await AuthService.shared.signOut() }
                        
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
        .onAppear() {
            Task { try await viewModel.loadUserProfileImage() }
        }
    }
        
    
        
    
}
    



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(currentUser: User(id: "234j3i4j34kl3j43l", firstName: "Chris", lastName: "Zimmermann", email: "chris.zimmermann@hotmail.ch", joined: Date().timeIntervalSince1970))
    }
}
