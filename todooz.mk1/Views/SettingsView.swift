//
//  SettingsView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 31.08.23.
//

import SwiftUI

struct SettingsView: View {
    
    
    @State private var Flugmodus = false
    
    
    var body: some View {
        
        List {
            
            Section(header: Text("Allgmein")) {
                HStack {
                    Image(systemName: "airplane")
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(.orange)
                        .cornerRadius(5)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .padding(.vertical, 2.5)
                    
                    Text("Flugmodus")
                    
                    Toggle("Flugmodus", isOn: $Flugmodus)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    
                    
                }
                
                NavigationLink(destination: Text("Wlan Settings")) {
                    HStack {
                        Image(systemName: "wifi")
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(.blue)
                            .cornerRadius(5)
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .padding(.vertical, 2.5)
                            .padding(.trailing, 5)
                        
                        Text("Wlan")
                    }
                    
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
