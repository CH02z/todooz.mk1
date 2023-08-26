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
        
        if viewModel.IsSignedIn && !viewModel.currentUserID.isEmpty {
            TabsView()
        } else {
            LoginView()
        }
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
