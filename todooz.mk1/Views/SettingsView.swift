//
//  SettingsView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 31.08.23.
//

import SwiftUI

struct SettingsView: View {
    
    
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    
    
    let colors: [String] = ["F2503F", "63D163", "F8A535", "B35AEF", "3380FE"]
    
    
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
            
            Section(header: Text("Akzent Farbe")) {
                
                    //Accent color Picker Section
                    Grid() {
                        GridRow {
                                ForEach(0...4, id: \.self) { index in
                                    Circle()
                                        .foregroundColor(Color(hex: colors[index]))
                                        .frame(width: 40, height: 40)
                                        .overlay(Circle().stroke(Color.gray, lineWidth: colors[index] == accentColor ? 4 : 0))
                                        .padding(.horizontal, 8)
                                        .padding(.bottom, 10)
                                        .onTapGesture {
                                            accentColor = colors[index]
                                        }
                                }
                            
                            
                        }
                        
                        
                    }
                    .padding(.top, 10)
                
                
                
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
