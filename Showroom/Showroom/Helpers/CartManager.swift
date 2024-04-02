//
//  CartManager.swift
//  Showroom
//
//  Created by Luka Lešić on 02.04.2024..
//

import Foundation

@Observable
class CartManager {
    static let shared = CartManager()
    var totalPrice = 0
    var items: [ModelObject] = []
    
    private init() {
        
    }
    
    func addToCart(object: ModelObject) {
        items.append(object)
        totalPrice += object.price ?? 0
        print(items)
    }
    
    func removeFromCart(name: String) {
        if let index = items.firstIndex(where: { $0.name == name }) {
            items.remove(at: index)
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
    
    func calculatePrice() {
        for item in items {
            totalPrice += item.price ?? 0
        }
    }
}
