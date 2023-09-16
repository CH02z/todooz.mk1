//
//  AuthService.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 27.08.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class NoteService {
    
    
    @Published var userID: String?
    
    init() {
        self.userID = Auth.auth().currentUser?.uid
    }
    
    static let shared = NoteService()
    
    
    @MainActor
    func createNote(text: String, noteColor: String) async throws {
        guard let uid = self.userID else { return }
        let newNote = QuickNote(id: UUID().uuidString,
                                text: text,
                                noteColor: noteColor,
                                dateCreated: getStringFromDate(date: Date(), dateFormat: "dd.MM.yyyy, HH:mm")
        )
        try await Firestore.firestore().collection("users").document(uid).collection("notes").document(newNote.id).setData(newNote.asDictionary())
        print("Note \(newNote.id) inserted to firestore")
    }
    
    
    @MainActor
    func deleteNote(noteID: String) async throws {
        guard let uid = self.userID else { return }
        try await Firestore.firestore().collection("users").document(uid).collection("notes").document(noteID).delete()
        print("Note with ID: \(noteID) deleted from firestore")
    }
    
    
}
