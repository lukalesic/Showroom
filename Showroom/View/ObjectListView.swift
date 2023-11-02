//
//  ObjectView.swift
//  Showroom
//
//  Created by Luka Lešić on 02.11.2023..
//

import SwiftUI
import FirebaseFirestore
import RealityKit

struct ObjectListView: View {
    let object: ModelObject
    var body: some View {
            Button {
                //lead to new screen
            } label: {
                VStack {
                    if let modelURL = object.modelURL, let url = URL(string: modelURL) {
                        Model3D(url: url) { phase in
                                      switch phase {
                                      case .success(let model):
                                          model.resizable()
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
            .buttonStyle(.borderless)
        }
}

