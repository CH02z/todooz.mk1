//
//  TabView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI
import UserNotifications

struct TabsView: View {
    
    let currentUser: User?
    
    @State private var showNotificationDeniedAlert : Bool = false
    
    var body: some View {
         
         TabView {
             CategoryView(currentUser: currentUser)
                 .tabItem {
                     Label("Tasks", systemImage: "list.bullet")
                 }
             NotesListView(currentUser: currentUser)
                 .tabItem {
                     Label("Notizen", systemImage: "square.and.pencil")
                 }
         }
         .onAppear() {
             
             NotificationHandler.shared.requestPermission(onDeny: {
                 self.showNotificationDeniedAlert.toggle()
             })
         }
         .alert(isPresented : $showNotificationDeniedAlert){

              Alert(title: Text("Notification has been disabled for this app"),
              message: Text("Please go to settings to enable it now"),
              primaryButton: .default(Text("Go To Settings")) {
                 self.goToSettings()
              },
              secondaryButton: .cancel())
         }
         
    }
    
    
}
    
    
struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView(currentUser: User(id: "234j3i4j34kl3j43l", firstName: "Chris", lastName: "Zimmermann", email: "chris.zimmermann@hotmail.ch", joined: Date().timeIntervalSince1970))
    }
}
