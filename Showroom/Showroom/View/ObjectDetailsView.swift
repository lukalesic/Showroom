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
    @Environment(ObjectsViewModel.self) private var viewModel: ObjectsViewModel

    var object: ModelObject
    
    var body: some View {
        modelBodyView()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                customBackButton()
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
    
    func addToFavouritesButton() -> some View {
        Button(action: {
            SoundManager.shared.playSound(soundName: "ding")
            viewModel.addToFavourites(object)
        }, label: {
            HStack(spacing: 5) {
                Image(systemName: "star.fill")
                Text(object.isFavourite ? "Remove from Favourites" : "Add to Favourites")
            }
        })
    }
}
