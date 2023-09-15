//
//  StandardCategorieView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 04.09.23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct StandardCategoryPreviewView: View {
    
    @AppStorage("accentColor") private var accentColor = "B35AEF"    
    
    let currentUser: User?
    let allCategories: [Category]
    
    @State var numberOfHighPrioTasks: String = ""
    @State var numberOfTodayTasks: String = ""
    @State var numberOfDoneTasks: String = ""
    @State var numberOfMarkedTasks: String = ""
    
    @FirestoreQuery(collectionPath: "users") var highPrioTasks: [Tasc]
    @FirestoreQuery(collectionPath: "users") var todayTasks: [Tasc]
    @FirestoreQuery(collectionPath: "users") var doneTasks: [Tasc]
    @FirestoreQuery(collectionPath: "users") var markedTasks: [Tasc]
    
    @State var filteredByDateTasks: [Tasc] = []
    
    private func setNumberOfHighPrioTasks(uid: String) async throws {
        $highPrioTasks.path = "users/\(uid)/tasks"
        $highPrioTasks.predicates = [
            .isEqualTo("isHighPriority", true),
            .whereField("isDone", isEqualTo: false)
        ]
        try await Task.sleep(seconds: 0.2)
        self.numberOfHighPrioTasks = String(highPrioTasks.count)
    }
    
    
    private func setNumberOfDoneTasks(uid: String) async throws {
        $doneTasks.path = "users/\(uid)/tasks"
        $doneTasks.predicates = [
            .isEqualTo("isDone", true),
            .order(by: "dueDate", descending: true)
            ]
            try await Task.sleep(seconds: 0.2)
            self.numberOfDoneTasks = String(self.doneTasks.count)
        }
    
    
        
    private func setNumberOfTodayTasks(uid: String) async throws {
        $todayTasks.path = "users/\(uid)/tasks"
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
            return isSameDay(date1: Date(), date2: getDateFromString(dateString: tasc.dueDate))
        }
    }
    
    private func setNumberOfMarkedTasks(uid: String) async throws {
        $markedTasks.path = "users/\(uid)/tasks"
        $markedTasks.predicates = [
            .isEqualTo("isMarked", true),
            .whereField("isDone", isEqualTo: false)
        ]
        try await Task.sleep(seconds: 0.2)
        self.numberOfMarkedTasks = String(markedTasks.count)
    }
    
    var body: some View {
        
        if let user = currentUser {
            
            
            VStack {
                HStack {
                    NavigationLink(destination: TodayTaskListView(currentUser: currentUser, allCategories: allCategories)) {
                        HStack {
                            VStack {
                                Image(systemName: "calendar.circle")
                                    .foregroundColor(Color(hex: accentColor))
                                    .font(.system(size: 35))
                                    //.fontWeight(.semibold)
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
                        .foregroundColor(Color("MainFontColor"))
                        .frame(width: 155, height: 80)
                        .cornerRadius(8)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                    }
                    .background(Color("ElementBackround"))
                    .cornerRadius(10)
                    //.padding(.leading, 25)
                    
                    Spacer()
                    
                    
                    NavigationLink(destination: HighPrioTaskListView(currentUser: currentUser, allCategories: allCategories)) {
                        HStack {
                            VStack {
                                Image(systemName: "exclamationmark.circle")
                                    .foregroundColor(Color(hex: accentColor))
                                    .font(.system(size: 35))
                                    //.fontWeight(.semibold)
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
                        .foregroundColor(Color("MainFontColor"))
                        .frame(width: 155, height: 80)
                        .cornerRadius(8)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 5)
                    }
                    .background(Color("ElementBackround"))
                    .cornerRadius(10)
                    //.padding(.trailing, 25)
                    
                }
                .onAppear() {
                    Task { try await self.setNumberOfHighPrioTasks(uid: user.id) }
                    Task { try await self.setNumberOfTodayTasks(uid: user.id) }
                    Task { try await self.setNumberOfDoneTasks(uid: user.id) }
                    Task { try await self.setNumberOfMarkedTasks(uid: user.id) }
                    
                }
                
                NavigationLink(destination: IsDoneTaskListView(allCategories: allCategories, currentUser: currentUser)) {
                    // Done Task Preview:
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(Color(hex: accentColor))
                            .font(.system(size: 35))
                            //.fontWeight(.semibold)
                            .padding(.vertical, 3.5)
                            .padding(.trailing, 5)
                            .padding(.leading, 20)
                        //.overlay(Circle().stroke(Color.white, lineWidth: 1))
                        
                        Text("Erledigt")
                            .foregroundColor(Color("MainFontColor"))
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                        
                        Text(numberOfDoneTasks)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 20)
                            .foregroundColor(Color("MainFontColor"))
                    }
                    .padding(.vertical, 4)
                }
                .background(Color("ElementBackround"))
                .cornerRadius(10)
                .padding(.top, 30)
                
                NavigationLink(destination: MarkedTaskListView(currentUser: currentUser, allCategories: allCategories)) {
                    // Done Task Preview:
                    HStack {
                        Image(systemName: "flag")
                            .foregroundColor(Color(hex: accentColor))
                            .font(.system(size: 35))
                            //.fontWeight(.semibold)
                            .padding(.vertical, 3.5)
                            .padding(.trailing, 5)
                            .padding(.leading, 20)
                        //.overlay(Circle().stroke(Color.white, lineWidth: 1))
                        
                        Text("Markiert")
                            .foregroundColor(Color("MainFontColor"))
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                        
                        Text(numberOfMarkedTasks)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 20)
                            .foregroundColor(Color("MainFontColor"))
                    }
                    .padding(.vertical, 4)
                }
                .background(Color("ElementBackround"))
                .cornerRadius(10)
                .padding(.top, 10)
                
        
                
            }
   
        }
            
        
    }
    
}

struct StandardCategorieView_Previews: PreviewProvider {
    static var previews: some View {
        StandardCategoryPreviewView(currentUser: TestData.users[0], allCategories: [TestData.categories[0]])
    }
}
