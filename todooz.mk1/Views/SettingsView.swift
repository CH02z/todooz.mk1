//
//  SettingsView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 31.08.23.
//

import SwiftUI

struct SettingsView: View {
    
    
    @AppStorage("isDarkMode") private var isDarkMode = true
    
    
    var body: some View {
        
        List {
            
            Section(header: Text("Allgmein")) {
                HStack {
                    Image(systemName: "lightbulb")
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(.orange)
                        .cornerRadius(5)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .padding(.vertical, 2.5)
                    
                    Text("Dunkelmodus")
                    
                    Toggle("Flugmodus", isOn: $isDarkMode)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    
                    
                }
                
            }
            
            
            Section {
                NavigationLink(destination: Text("Notification Center")) {
                    HStack {
                        Image(systemName: "bell.badge.fill")
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(.red)
                            .cornerRadius(5)
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .padding(.vertical, 2.5)
                            .padding(.trailing, 5)
                        
                        Text("Mitteilungen")
                    }
                }
                
                NavigationLink(destination: Text("General Settings")) {
                    HStack {
                        Image(systemName: "gear")
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(.gray)
                            .cornerRadius(5)
                            .font(.system(size: 19))
                            .fontWeight(.bold)
                            .padding(.vertical, 2.5)
                            .padding(.trailing, 5)
                        
                        Text("Allgemein")
                    }
                }
                
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(.gray)
                        .cornerRadius(5)
                        .font(.system(size: 19))
                        .fontWeight(.bold)
                        .padding(.vertical, 2.5)
                        .padding(.trailing, 5)
                    
                    Text("abmelden")
                        .foregroundColor(.red)
                }
                .onTapGesture {
                    Task { await AuthService.shared.signOut() }
                }
                
                
                
                
                
            }
            
            
        }
        
        //.navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
