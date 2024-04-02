//
//  CartView.swift
//  Showroom
//
//  Created by Luka Lešić on 02.04.2024..
//

import SwiftUI

struct CartView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    CustomGridLayout(
                        CartManager.shared.items,
                        numberOfColumns: 3
                    ) { object in
                        NavigationLink(
                            destination: ObjectDetailsView(
                                object: object
                            )
                        ) {
                            SingleObjectListView(
                                object: object
                            )
                        }
                        .buttonStyle(
                            PlainButtonStyle()
                        )
                    }
                }
            }
            .navigationTitle(
                "Cart"
            )
        }.navigationViewStyle(
            .stack
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    NavigationLink {
                        //
                    } label: {
                        Text("\(Image(systemName: "cart.circle.fill")) Buy all")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)

                    
                    Button {
                        CartManager.shared.clearCart()
                    } label: {
                        Text("\(Image(systemName: "xmark.circle")) Remove all")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            ToolbarItem(placement: .principal) {
                Text(
                    "Total price: \(CartManager.shared.totalPrice) EUR"
                )
                .font(
                    .system(size: 30, weight: .bold)
                )
            }
        }
    }
}

#Preview {
    CartView()
}
