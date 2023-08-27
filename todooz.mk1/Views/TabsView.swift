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
            ToDoListView()
                .tabItem {
                    Label("Todo", systemImage: "list.bullet")
                }
            ProfileView(currentUser: currentUser)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .accentColor(.red)
        
    }
}
    
    
struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView(currentUser: User(id: "234j3i4j34kl3j43l", firstName: "Chris", lastName: "Zimmermann", email: "chris.zimmermann@hotmail.ch", joined: Date().timeIntervalSince1970))
    }
}
