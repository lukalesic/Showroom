//
//  ObjectView.swift
//  Showroom
//
//  Created by Luka Lešić on 02.11.2023..
//

import SwiftUI
import FirebaseFirestore
import RealityKit

struct SingleObjectListView: View {
    let object: ModelObject
    
    var body: some View {
            VStack {
                if let modelURL = object.modelURL, let url = URL(string: modelURL) {
                    Model3D(url: url) { phase in
                        switch phase {
                        case .success(let model):
                            model
                                .resizable()
                                .clipped()
                                .scaledToFit()
                                .frame(maxWidth: 200, maxHeight: 200)
                        case .failure(let error):
                            Text(error.localizedDescription)
                        default:
                            ProgressView()
                        }
                    }
                }
                else {
                    EmptyView()
                }
                Text(object.name)
            }
            .frame(width: 250, height: 250)
    }
}

