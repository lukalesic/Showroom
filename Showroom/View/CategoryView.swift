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
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.filteredData, id: \.self) {object in
                    ObjectListView(object: object)
                        .onDrag {
                            NSItemProvider()
                    }
                }
            }
        }
    }
}
