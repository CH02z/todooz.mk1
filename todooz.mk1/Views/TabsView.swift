//
//  TabView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct TabsView: View {
    
    let currentUser: User?
    
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
         
    }
}
    
    
struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView(currentUser: User(id: "234j3i4j34kl3j43l", firstName: "Chris", lastName: "Zimmermann", email: "chris.zimmermann@hotmail.ch", joined: Date().timeIntervalSince1970))
    }
}
