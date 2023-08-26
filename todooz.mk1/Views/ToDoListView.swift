//
//  ToDoListView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct ToDoListView: View {
    var body: some View {
        NavigationStack {
            Text("To do List")
            .navigationTitle("To Do's")
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
