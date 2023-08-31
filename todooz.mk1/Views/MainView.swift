//
//  ContentView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel = MainViewModel()
    
    var body: some View {
            
            if viewModel.userSession == nil {
                LoginView()
            } else {
                TabsView(currentUser: viewModel.currentUser)
            }
            
        }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
