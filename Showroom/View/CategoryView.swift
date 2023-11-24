//
//  ObjectDetailView.swift
//  Showroom
//
//  Created by Luka Lešić on 01.11.2023..
//

import SwiftUI

struct CategoryView: View {
    @Environment(ObjectsViewModel.self) private var viewModel: ObjectsViewModel
    var columns: [GridItem] = [.init(.adaptive(minimum: 200), spacing: 20)]
    @Environment(ImmersiveViewManager.self) private var manager: ImmersiveViewManager


    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.filteredObjects, id: \.name) { object in
                        NavigationLink(destination: ObjectDetailsView(object: object).environment(manager).environment(viewModel)) {
                            SingleObjectListView(object: object)
                        }
                            .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }.navigationViewStyle(.stack)
    }
}
