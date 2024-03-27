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
    case decorations = "Decorations"
    case kitchen = "Kitchen"
    case favourites = "Favourites"
    
    var databaseId: String {
        switch self {
        case .technology:
            return "TechnologyModels"
        case .furniture:
            return "FurnitureModels"
        case .clothes:
            return "ClothesModels"
        case .favourites:
            return "Favourites"
        case .decorations:
            return "DecorationModels"
        case .kitchen:
            return "KitchenModels"
        }
    }
    
    var imageName: String {
        switch self {
        case .technology:
            return "gamecontroller.fill"
        case .furniture:
            return "sofa.fill"
        case .clothes:
            return "tshirt.fill"
        case .favourites:
            return "star.fill"
        case .decorations:
            return "chair.lounge.fill"
        case .kitchen:
            return "cup.and.saucer.fill"
        }
    }
}
