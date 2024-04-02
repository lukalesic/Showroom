//
//  BuyingInfoScreen.swift
//  Showroom
//
//  Created by Luka Lešić on 02.04.2024..
//

import SwiftUI

struct BuyingInfoScreen: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var address = ""
    @State private var isShowingBuyingAlert = false

    var body: some View {
        VStack {
            if CartManager.shared.items.count > 0 {
                buyFormView()
            }
            else {
                emptyCartView()
            }
        }
        .alert("Purchase completed! Thank you, \(self.$firstName.wrappedValue)", isPresented: $isShowingBuyingAlert) {
            Button("OK", role: .cancel) { }
        }
        .navigationBarTitle("Checkout")
    }
}

#Preview {
    BuyingInfoScreen()
}

private extension BuyingInfoScreen {
    
    @ViewBuilder
    func totalPrice() -> some View {
       Text("Total price: \(CartManager.shared.totalPrice) EUR")
            .font(.extraLargeTitle)
    }
    
    @ViewBuilder
    func buyFormView() -> some View {
        VStack {
            totalPrice()
            forms()
            buyButton()
        }
    }
    
    @ViewBuilder
    func emptyCartView() -> some View {
        ContentUnavailableView("No items in cart!", image: "")
    }
    
    @ViewBuilder
    func forms() -> some View {
        Group {
            TextField("First Name", text: $firstName)
            TextField("Last Name", text: $lastName)
            TextField("Address", text: $address)
        }
            .textFieldStyle(.roundedBorder)
            .padding(.all)
    }
    
    @ViewBuilder
    func buyButton() -> some View {
        Button {
            isShowingBuyingAlert = true
            CartManager.shared.clearCart()
        } label: {
            Text("\(Image(systemName: "cart")) Buy")
                .font(.largeTitle)
        }
    }
}
