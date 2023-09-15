//
//  User.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import Foundation
import SwiftUI

struct Category: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    var description: String?
    var iconColor: String?
    var icon: String?
    let dateCreated: String?
    var lastModified: String?
    var numberOfTasks: Int?
}








