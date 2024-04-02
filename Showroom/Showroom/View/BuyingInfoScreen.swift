//
//  BuyingInfoScreen.swift
//  Showroom
//
//  Created by Luka Lešić on 02.04.2024..
//

import SwiftUI

struct BuyingInfoScreen: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    BuyingInfoScreen()
}

private extension BuyingInfoScreen {
    
    @ViewBuilder
    func totalPrice() -> some View {
       Text("Total price: \(CartManager.shared.totalPrice) EUR")
            .font(.headline)
    }
}
