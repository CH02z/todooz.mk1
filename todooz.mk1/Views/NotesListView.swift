//
//  NotesView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 13.09.23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct NotesListView: View {
    
    let currentUser: User?
    
    @State var showAddNoteSheet: Bool = false
    @FirestoreQuery(collectionPath: "users") var notes: [QuickNote]
    
    private func filterNotes() {
        $notes.path = "users/\(self.currentUser?.id ?? "")/notes"
        $notes.predicates = [
            .order(by: "dateCreated", descending: true),
        ]
    }
    
    
    
    var body: some View {
        
        
        NavigationStack {
            
            
            
            VStack {
                
                ScrollView(.vertical) {
                    let columns = [
                            GridItem(.flexible())
                        ]
                    
                    LazyVGrid(columns: columns) {
                        ForEach(notes) { quicknote in
                            
                            NoteView(quickNote: quicknote)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .contextMenu {
                                    Button {
                                        Task { try await NoteService.shared.deleteNote(noteID: quicknote.id) }
                                        
                                    } label: {
                                        Label("Löschen", systemImage: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                               
                        }
                    }
                    
                    
                    
                }
                .refreshable {
                    Task { @MainActor in
                        self.filterNotes()
                    }
                }
                .sheet(isPresented: $showAddNoteSheet, content: {
                    AddNoteView(isPresented: $showAddNoteSheet)
                })
                    
            }
            
            
            
            .navigationTitle("Notizen")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        
                        //Haptic Feedback on Tap
                        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                        impactHeavy.impactOccurred()
                        showAddNoteSheet = true
                        //self.showAddCategorySheet = true
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 25))
                        
                    }
                    
                }
                
                
            }
            
            
        }
        .onAppear() {
            Task { @MainActor in
                self.filterNotes()
            }
        }
            
            
            
        
        
        
            
    }
}

struct NotesListView_Previews: PreviewProvider {
    static var previews: some View {
        NotesListView(currentUser: TestData.users[0])
    }
}
