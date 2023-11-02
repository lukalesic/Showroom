//
//  Object.swift
//  Showroom
//
//  Created by Luka Lešić on 02.11.2023..
//

import Foundation

@Observable
class ModelObject {
    var name: String
    var modelURL: String?
    var parentCollection: String
    
    init(name: String, modelURL: String, parentCollection: String) {
        self.name = name
        self.modelURL = modelURL
        self.parentCollection = parentCollection
    }
}
