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
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            //.shadow(color: .gray, radius: 10)
    }
}
