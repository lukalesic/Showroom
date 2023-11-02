//
//  ModelsView.swift
//  Showroom
//
//  Created by Luka Lešić on 01.11.2023..
//

import SwiftUI
import Observation

struct ObjectsView: View {
    @State var selectedCategory: ModelType?
    @State var viewModel: ObjectsViewModel

    init() {
        _viewModel = State(initialValue: ObjectsViewModel(selectedCategory: .technology))
        }
    
    var body: some View {
        NavigationSplitView {
            sidebarView()
        } detail: {
            if let selectedCategory {
                switch viewModel.repository.loadingState {
                case .loaded:
                    CategoryView()
                        .environment(viewModel)
                default:
                    ProgressView()
                }
            }
            else {
                placeholderObjectView()
            }
        }
        .onChange(of: selectedCategory) { _, newCategory in
            if let newCategory = newCategory {
                viewModel.selectedCategory = newCategory
                viewModel.filterDocuments()
            }
        }
        .navigationTitle(viewModel.selectedCategory.rawValue)
    }
}

private extension ObjectsView {
    
    @ViewBuilder
    func placeholderObjectView() -> some View {
        Text("Choose a category!")
    }
    
    @ViewBuilder
    func sidebarView() -> some View {
        List(ModelType.allCases, id: \.self, selection: $selectedCategory) { category in
            HStack {
                //TODO: replace with appropriate icons from ModelType enum
                Image(systemName: "pencil")
                Text(category.rawValue)
            }
        }
    }
}
#Preview {
    ObjectsView()
}
