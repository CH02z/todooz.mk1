//
//  SettingsView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 31.08.23.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    
    
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("accentColor") private var accentColor = "B35AEF"
    
    @AppStorage("language") private var language = LocalizationService.shared.language
    
    
    let colors: [String] = ["F2503F", "63D163", "F8A535", "B35AEF", "3380FE"]
    let languages: [String] = ["Deutsch", "English", "Französisch"]
    
    @StateObject var AppIconviewModel = ChangeAppIconViewModel()
    
    
    
    
    var body: some View {
        
        List {
            
            Section(header: Text("general".localized(language))) {
                HStack {
                    Image(systemName: "lightbulb")
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(.orange)
                        .cornerRadius(5)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                        .padding(.vertical, 2.5)
                    
                    Text("darkmode".localized(language))
                    
                    Toggle("theme", isOn: $isDarkMode)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    
                    
                }
                
            }
            
            Section(header: Text("accent-color".localized(language))) {
                
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
                                    switch accentColor {
                                    case "F2503F":
                                        AppIconviewModel.updateAppIcon(to: AppIcon.red)
                                    case "63D163":
                                        AppIconviewModel.updateAppIcon(to: AppIcon.green)
                                    case "F8A535":
                                        AppIconviewModel.updateAppIcon(to: AppIcon.orange)
                                    case "B35AEF":
                                        AppIconviewModel.updateAppIcon(to: AppIcon.purple)
                                    case "3380FE":
                                        AppIconviewModel.updateAppIcon(to: AppIcon.blue)
                                    default:
                                        AppIconviewModel.updateAppIcon(to: AppIcon.purple)
                                    }
                                    
                                    
                                }
                        }
                        
                        
                    }
                    
                    
                }
                .padding(.top, 10)
                
                
                
            }
            
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(.blue)
                    .cornerRadius(5)
                    .font(.system(size: 19))
                    .fontWeight(.bold)
                    .padding(.vertical, 2.5)
                    .padding(.trailing, 5)
                
                Spacer()
                
                Menu("chose language") {
                    Button {
                        LocalizationService.shared.language = .german
                    } label: {
                        Text("Deutsch")
                    }
                    
                    Button {
                        LocalizationService.shared.language = .english
                    } label: {
                        Text("English")
                    }
                    
                }
                
            }
            
            Section {
                NavigationLink(destination: notificationView()) {
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
                        
                        Text("notification".localized(language))
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
                    
                    Text("logout".localized(language))
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



struct notificationView: View {
    
    @State private var showNotificationDeniedAlert : Bool = false
    
    var body: some View {
        Text("Mitteilungszentrale")
            .font(.title)
        
            .onAppear() {
                DispatchQueue.main.async {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:],
                                              completionHandler: nil)
                }
            }
        
    }
    
    
    
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
