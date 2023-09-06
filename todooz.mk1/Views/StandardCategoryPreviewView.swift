//
//  StandardCategorieView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 04.09.23.
//

import SwiftUI

struct StandardCategoryPreviewView: View {
    

    let currentUser: User?
    
    var body: some View {
        
        HStack {
            
            NavigationLink(destination: TodayTaskListView(currentUser: currentUser)) {
                HStack {
                    VStack {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                            .background(.orange)
                            .clipShape(Circle())
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.vertical, 3.5)
                            .padding(.trailing, 5)
                        
                        Text("Heute")
                            .fontWeight(.semibold)
                    }
                    .padding(.leading, 6)
                    
                    Spacer()
                    Text("0")
                        .padding(.trailing, 6)
                        .font(.title)
                }
                .foregroundColor(.white)
                .frame(width: 155, height: 80)
                .cornerRadius(8)
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
            //.padding(.leading, 25)
            
            Spacer()
            
            
            NavigationLink(destination: HighPrioTaskListView(currentUser: currentUser)) {
                HStack {
                    VStack {
                        Image(systemName: "exclamationmark.circle")
                            .foregroundColor(Color.red)
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                            .padding(.vertical, 3.5)
                            .padding(.trailing, 20)
                        
                        
                        Text("Priorität")
                            .fontWeight(.semibold)
                            .padding(.leading, 6)
                    }
                    .frame(alignment: .leading)
                    
                    
                    Spacer()
                    Text("0")
                        .padding(.trailing, 6)
                        .font(.title)
                }
                .foregroundColor(.white)
                .frame(width: 155, height: 80)
                .cornerRadius(8)
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
            //.padding(.trailing, 25)
            
        }
        
        
        
    }
        
}

struct StandardCategorieView_Previews: PreviewProvider {
    static var previews: some View {
        StandardCategoryPreviewView(currentUser: User(id: "234j3i4j34kl3j43l", firstName: "Chris", lastName: "Zimmermann", email: "chris.zimmermann@hotmail.ch", joined: Date().timeIntervalSince1970))
    }
}
