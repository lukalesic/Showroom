//
//  Object.swift
//  Showroom
//
//  Created by Luka Lešić on 02.11.2023..
//

import Foundation

@Observable
class Object {
    var name: String
    var modelURL: String
    
    init(name: String, modelURL: String) {
        self.name = name
        self.modelURL = modelURL
    }
}
