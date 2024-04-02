//
//  ModelObject.swift
//  Showroom
//
//  Created by Luka Lešić on 02.11.2023..
//

import Foundation

@Observable
class ModelObject: Decodable {
    var name: String
    var modelURL: String?
    var price: Int?
    var parentCollection: String
    var description: String?
    var isFavourite: Bool
    
    init(name: String, modelURL: String, price: Int, parentCollection: String, description: String, isFavourite: Bool) {
        self.name = name
        self.modelURL = modelURL
        self.price = price
        self.parentCollection = parentCollection
        self.description = description
        self.isFavourite = isFavourite
    }
}
