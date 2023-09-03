//
//  ToDoListView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import SwiftUI

struct CategoryView: View {
    
    let currentUser: User?
    
    var categories: [Category] = TestData.categories
    
    
    var body: some View {
        NavigationStack {
            
            VStack(alignment: .leading) {
        
                List(categories, id: \.id) { category in
                    
                    NavigationLink(destination: TasklistView(category: category, currentUser: currentUser)) {
                        CategoryPreviewView(category: category)
                    }
                }
                
                .refreshable {
                    //reload in Task { get categories }
                }
                
            }
            
            .navigationTitle("Kategorien")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView(currentUser: currentUser)) {
                        Image(systemName: "person.circle")
                            //.foregroundColor(.gray)
                            .font(.system(size: 25))
                          
                      
                    }

                }
            }
            
            .safeAreaInset(edge: .bottom, alignment: .center) {
                            Button{
                                
                                //Haptic Feedback on Tap
                                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                                impactHeavy.impactOccurred()
                                
                                //self.showAddItemSheet = true
                            } label: {
                                Label("hinzufügen", systemImage: "plus")
                                    .bold()
                                    .font(.title2)
                                    .padding(8)
                                    .background(.gray.opacity(0.1),
                                                in: Capsule())
                                    .padding(.leading)
                                    .symbolVariant(.circle.fill)
                            }
                        }
            .padding(.bottom, 10)
            
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
        CategoryView(currentUser: User(id: "234j3i4j34kl3j43l", firstName: "Chris", lastName: "Zimmermann", email: "chris.zimmermann@hotmail.ch", joined: Date().timeIntervalSince1970))
    }
}
