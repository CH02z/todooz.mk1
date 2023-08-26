//
//  TabView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct TabsView: View {
    var body: some View {
        
        
        
        Text("Test")
        /*
         .onAppear() {
         UITabBar.appearance().backgroundColor = .gray
         }
         */
        
        
        TabView {
            ToDoListView()
                .tabItem {
                    Label("Todo", systemImage: "list.bullet")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .accentColor(.red)
        
    }
}
    
    
struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
