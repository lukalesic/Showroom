//
//  ModelType.swift
//  Showroom
//
//  Created by Luka Lešić on 01.11.2023..
//

import Foundation

enum ModelType: String, CaseIterable {
    case technology = "Technology"
    case furniture = "Furniture"
    case clothes = "Clothes"
    
    var databaseId: String {
        switch self {
        case .technology:
            return "TechnologyModels"
        case .furniture:
            return "FurnitureModels"
        case .clothes:
            return "ClothesModels"
        }
    }
}
