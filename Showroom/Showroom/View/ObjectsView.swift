//
//  ModelsView.swift
//  Showroom
//
//  Created by Luka Lešić on 01.11.2023..
//

import SwiftUI
import Observation
import FirebaseAuth

struct ObjectsView: View {
    @State var selectedCategory: ModelType?
    @State var viewModel: ObjectViewModel
    @State var authenticationViewModel = AuthenticationViewModel()
    @Environment(ImmersiveViewManager.self) private var manager: ImmersiveViewManager

    init() {
        _viewModel = State(initialValue: ObjectViewModel(selectedCategory: .technology))
        }
    
    var body: some View {
        NavigationSplitView {
            sidebarView()
            HStack {
                cartButton()
                logOutButton()
            }
                .padding(.bottom)
        } detail: {
            if let selectedCategory {
                switch viewModel.repository.loadingState {
                case .loaded:
                    CategoryView()
                        .environment(viewModel)
                        .environment(manager)
                        .animation(.easeInOut, value: viewModel.selectedCategory)

                default:
                    placeholderObjectView()
                        .animation(.easeInOut, value: viewModel.selectedCategory)
                }
            }
            else {
                placeholderObjectView()
                    .animation(.easeInOut, value: viewModel.selectedCategory)

            }

        }
        .onChange(of: selectedCategory) { _, newCategory in
            if let newCategory = newCategory {
                viewModel.selectedCategory = newCategory
                if newCategory == .favourites {
                    viewModel.fetchFavourites()
                }
                else {
                    viewModel.filterObjects()
                }
            }
        }
        .onAppear() {
            if (selectedCategory == .favourites) {
                viewModel.fetchFavourites()
            }
        }
        .navigationTitle(viewModel.selectedCategory.rawValue)
    }
}

private extension ObjectsView {
    
    @ViewBuilder
    func cartButton() -> some View {
        NavigationLink {
            CartView()
        } label: {
            Text("\(Image(systemName: "cart.fill")) Cart")
        }
    }
    
    @ViewBuilder
    func logOutButton() -> some View {
        Button {
            Task {
                    await authenticationViewModel.signOut()
                }
        } label: {
            Text("Log out")
        }

    }
    
    @ViewBuilder
    func placeholderObjectView() -> some View {
        Image(systemName: "square.3.layers.3d.top.filled")
            .font(.system(size: 60))
        Text("Choose a category!")
            .font(.largeTitle)
            .padding(.top, 12)
    }
    
    @ViewBuilder
    func sidebarView() -> some View {
        List(ModelType.allCases, id: \.self, selection: $selectedCategory) { category in
            HStack {
                Image(systemName: category.imageName)
                    .scaleEffect(1.8)
                Text(category.rawValue)
                    .padding(.leading, 12)
                    .font(.system(size: 17))
            }
        }
    }
}
