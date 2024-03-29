//
//  ProfileView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    @StateObject var viewModel: ProfileViewViewModel
    
    // Try move this to View Model
    @State private var selectedPickerItem: PhotosPickerItem?
    
    @State var avatarImage: UIImage?
    @State var avatarMemojiImage: UIImage = UIImage(named: "memoji_white")!
    @State var showAvatarImage: Bool = false
    
    
    let currentUser: User?
    
    
    init(currentUser: User?) {
        self._viewModel = StateObject(wrappedValue: ProfileViewViewModel())
        self.currentUser = currentUser
        
    }
    
    
    private func loadUserImage() async throws {
        self.avatarImage = try await viewModel.loadUserProfileImage()
    }
    
    var body: some View {
        
        if let user = currentUser {
            
            NavigationStack {
                VStack {
                    VStack() {
                        
                        ZStack {
                            
                            if showAvatarImage {
                                Image(uiImage: self.avatarImage ?? avatarMemojiImage)
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
                                .background(Color(hex: accentColor))
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
                                Task { try await self.loadUserImage() }
                            }
                        
                        Spacer()
                    }
                    
                }
                
                
            }
            .onAppear() {
                Task { @MainActor in
                    //
                    try await self.loadUserImage()
                    try await Task.sleep(seconds: 0.5)
                    try await self.loadUserImage()
                    try await Task.sleep(seconds: 0.5)
                    self.showAvatarImage = true
                    
                   
                }
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




struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(currentUser: TestData.users[0])
    }
}
