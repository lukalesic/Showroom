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
            List(ModelType.allCases, id: \.self, selection: $selectedCategory) { category in
                HStack {
                    //TODO: replace with appropriate icons
                    Image(systemName: "pencil")
                    Text(category.rawValue)
                }
            }
        } detail: {
            if let selectedCategory {
                switch viewModel.loadingState {
                case .loaded:
                    Text(viewModel.selectedCategory.rawValue)
                    //TODO: DetailView(selectedcategory: viewModel.selectedCategory)
                    List(viewModel.filteredData, id: \.documentID) { document in
                        Text(document.data()?["test"] as? String ?? "No data")
                    }
                default:
                    ProgressView()
                }
            }
            else {
                Text("Choose a category!")
            }
        }
        
        .onChange(of: selectedCategory) { _, newCategory in
            if let newCategory = newCategory {
                viewModel.selectedCategory = newCategory
               // viewModel.fetchDocuments()
             //   viewModel.fetchAllData()
                viewModel.filterDocuments()
            }
        }
        .onAppear() {
            viewModel.fetchAllData()
        }
    }
}

#Preview {
    ObjectsView()
}
