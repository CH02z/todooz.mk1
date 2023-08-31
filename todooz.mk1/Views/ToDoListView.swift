//
//  ToDoListView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 31.08.23.
//

import SwiftUI

struct ToDoListView: View {
    
    let category: Category
    
    var body: some View {
        NavigationStack {
            Text("Todo Lsit")
            
            
                .navigationTitle(category.name)
        }
    }
}




struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(category: Category(id: "dkfjddk213", name: "Swisscom", dateCreated: Date().timeIntervalSince1970))
    }
}
