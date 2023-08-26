//
//  BorderExtension.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import Foundation
import SwiftUI

extension View {
    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }
}
