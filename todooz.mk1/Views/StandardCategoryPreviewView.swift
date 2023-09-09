//
//  StandardCategorieView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 04.09.23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct StandardCategoryPreviewView: View {
    
    
    let currentUser: User?
    let allCategories: [Category]
    
    @State var numberOfHighPrioTasks: String = ""
    @State var numberOfTodayTasks: String = ""
    
    @FirestoreQuery(collectionPath: "users") var highPrioTasks: [Tasc]
    @FirestoreQuery(collectionPath: "users") var todayTasks: [Tasc]
    
    @State var filteredByDateTasks: [Tasc] = []
    
        
        
    private func setNumberOfHighPrioTasks(uid: String) async throws {
        $highPrioTasks.path = "users/\(uid)/tasks"
        $highPrioTasks.predicates = [
            .isEqualTo("isHighPriority", true)
        ]
        try await Task.sleep(seconds: 0.2)
        self.numberOfHighPrioTasks = String(highPrioTasks.count)
    }
        
    private func setNumberOfTodayTasks(uid: String) async throws {
        $todayTasks.path = "users/\(self.currentUser?.id ?? "")/tasks"
        $todayTasks.predicates = [
            .whereField("dueDate", isNotIn: [""]),
            .isEqualTo("isDone", false),
            .order(by: "dueDate", descending: true)
            ]
            try await Task.sleep(seconds: 0.2)
            try await self.filterTodayTasks()
            self.numberOfTodayTasks = String(self.filteredByDateTasks.count)
        }
    
    private func filterTodayTasks() async throws {
        try await Task.sleep(seconds: 0.1)
        self.filteredByDateTasks = self.todayTasks.filter { tasc in
            return isSameDay(date1: Date(), date2: getDateFromString(dateString: tasc.dueDate!))
        }
    }
    
    var body: some View {
        
        if let user = currentUser {
            
            HStack {
                NavigationLink(destination: TodayTaskListView(currentUser: currentUser, allCategories: allCategories)) {
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
                        Text(numberOfTodayTasks)
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
                
                
                NavigationLink(destination: HighPrioTaskListView(currentUser: currentUser, allCategories: allCategories)) {
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
                        Text(numberOfHighPrioTasks)
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
            .onAppear() {
                Task { try await self.setNumberOfHighPrioTasks(uid: user.id) }
                Task { try await self.setNumberOfTodayTasks(uid: user.id) }
                
            }
            
        }
            
        
    }
    
}

struct StandardCategorieView_Previews: PreviewProvider {
    static var previews: some View {
        StandardCategoryPreviewView(currentUser: TestData.users[0], allCategories: [TestData.categories[0]])
    }
}
