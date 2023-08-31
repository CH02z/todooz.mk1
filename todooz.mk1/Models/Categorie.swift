//
//  User.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import Foundation

struct Category: Codable {
    let id: String
    let name: String
    var iconColor: String?
    let dateCreated: TimeInterval?
}


struct TestData {
    
    static let categories: [Category] = [
        Category(id: "dkfjddk213", name: "Swisscom", dateCreated: Date().timeIntervalSince1970),
        Category(id: "dkfj2334343?k213", name: "Privat", dateCreated: Date().timeIntervalSince1970),
        Category(id: "dfadsfdsaf34%&/&(", name: "allgemein", dateCreated: Date().timeIntervalSince1970)
    ]
}



