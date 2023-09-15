//
//  ToDoListItem.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import Foundation
import SwiftUI

struct QuickNote: Codable, Identifiable {
    let id: String
    var text: String
    var noteColor: String
    let dateCreated: String
    var dateModified: String?
}
