//
//  ObjectDetailsView.swift
//  Showroom
//
//  Created by Luka Lešić on 07.11.2023..
//

import SwiftUI
import RealityKit

struct ObjectDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.openWindow) var openWindow
    @Environment(ImmersiveViewManager.self) private var manager: ImmersiveViewManager
    @Environment(ObjectViewModel.self) private var viewModel: ObjectViewModel
    @State private var isShowingFavouritesAlert = false
    @State private var isShowingCartAlert = false

    var object: ModelObject
    
    var body: some View {
        modelBodyView()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                shareButton()
            }
        }
    }
}

private extension ObjectDetailsView {
    
    @ViewBuilder
    func customBackButton() -> some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Back")
        })
    }
    
    @ViewBuilder
    func modelView() -> some View {
        if let modelURL = object.modelURL, let url = URL(string: modelURL) {
            Model3D(url: url) { phase in
                switch phase {
                case .success(let model):
                    model
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 300)
                case .failure(let error):
                    Text(error.localizedDescription)
                default:
                    ProgressView()
                        .frame(width: 300, height: 300)
                }
            }
            .opacity(isShowingFavouritesAlert || isShowingCartAlert ? 0 : 1)
            .animation(.easeInOut, value: isShowingFavouritesAlert)
            .animation(.easeInOut, value: isShowingCartAlert)

        }
    }
    
    @ViewBuilder
    func modelBodyView() -> some View {
        VStack {
            HStack(spacing: 25) {
                Spacer()
                modelView()
                Spacer()
                VStack(spacing: 20) {
                    Text(object.name)
                        .font(.system(size: 30))
                    Text(object.description ?? "")
                        .font(.system(size: 25))
                    HStack(spacing: 15) {
                        price()
                        addToCartButton()
                    }
                    addToSpaceButton()
                    addToFavouritesButton()
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func addToSpaceButton() -> some View {
        Button(action: {
            SoundManager.shared.playSound(soundName: "ding")
                manager.activeObject = object
                openWindow(id: "object")
        }, label: {
            HStack(spacing: 5) {
                Image(systemName: "move.3d")
                Text("View in real space")
            }
        })
    }
    
    @ViewBuilder
    func price() -> some View {
        Text("Price: \(object.price ?? 0) EUR")
            .font(.title)
    }
    
    @ViewBuilder
    func shareButton() -> some View {
        ShareLink(item: object.modelURL!, subject: Text(object.name), message: Text(object.description ?? ""))
    }
    
    @ViewBuilder
    func addToCartButton() -> some View {
        Button {
            CartManager.shared.addToCart(object: object)
            SoundManager.shared.playSound(soundName: "ding")
            isShowingCartAlert = true
        } label: {
            Text("\(Image(systemName: "cart")) Add to cart")
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .alert("Added to cart!", isPresented: $isShowingCartAlert)
        {
            Button("OK", role: .cancel) { }
        }
        
    }
    
    func addToFavouritesButton() -> some View {
        Button(action: {
            SoundManager.shared.playSound(soundName: "ding")
            if (object.isFavourite == false) {
                isShowingFavouritesAlert.toggle()
            }
            withAnimation {
                viewModel.addToFavourites(object)
            }
        }, label: {
            HStack(spacing: 5) {
                Image(systemName: "star.fill")
                Text(object.isFavourite ? "Remove from Favourites" : "Add to Favourites")
            }
        })
        .tint(object.isFavourite ? .orange : .accentColor)
        .alert("Added to favourites!", isPresented: $isShowingFavouritesAlert) {
                  Button("OK", role: .cancel) { }
              }
    }
}
