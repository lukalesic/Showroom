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
    let object: DocumentSnapshot
    var body: some View {
            Button {
                //lead to new screen
            } label: {
                VStack {
                          if let modelURL = object.data()?["modelURL"] as? String {
                              Model3D(url: URL(string: modelURL)!) { phase in
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
                          Text(object.data()?["test"] as? String ?? "No data")
                      }
                     .frame(width: 250, height: 250)
                  }
            .buttonStyle(.borderless)
        }
}

