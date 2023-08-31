//
//  ToDoListView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct CategoryView: View {
    
    var categories: [Category] = TestData.categories
    
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading) {
        
                List(categories, id: \.id) { category in
                    
                    NavigationLink(destination: ToDoListView(category: category)) {
                        CategoryPreviewView(category: category)
                    }
                }
                
            }
            
            .navigationTitle("Kategorien")
        }
    }
}


struct CategoryPreviewView: View {
    
    let category: Category
    
    var body: some View {
        HStack {
            Image(systemName: "list.bullet")
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(.green)
                .clipShape(Circle())
                .font(.system(size: 15))
                .fontWeight(.bold)
                .padding(.vertical, 3.5)
                .padding(.trailing, 5)
                //.overlay(Circle().stroke(Color.white, lineWidth: 1))
            
            Text(category.name)
                .fontWeight(.semibold)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
            
            Text("0")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.gray)
                
            
        }
    }
    
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
