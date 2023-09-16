//
//  RoundTextFieldStyle.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import Foundation
import SwiftUI

struct RoundTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.subheadline)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(20)
            .background(Color("ElementBackround"))
            .cornerRadius(10)
            //.shadow(color: .gray, radius: 10)
    }
}


struct NoteTextFieldStyle: TextFieldStyle {
    var backroundColor: String
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .lineLimit(5...10)
            .font(.body)
            .foregroundColor(.black)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(20)
            .background(Color(hex: backroundColor))
            .cornerRadius(15)
            //.shadow(color: .gray, radius: 10)
    }
}
