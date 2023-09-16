//
//  NoteView.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 13.09.23.
//

import SwiftUI

struct NoteView: View {
    
    
    @State var quickNote: QuickNote
    
    
    var body: some View {
        
        VStack {
            Text(quickNote.text)
                .font(.body)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text(quickNote.dateCreated)
                    .foregroundColor(.gray)
                    .opacity(0.8)
                
                Spacer(minLength: 0)
                
               
            }
            .padding(.top, 55)
             
            
            
        }
        .padding()
        .background(Color(hex: quickNote.noteColor)!)
        .cornerRadius(18)
        
        
        
        
        
        
        
    
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(quickNote: TestData.quickNotes[0])
    }
}
