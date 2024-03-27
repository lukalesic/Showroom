//
//  ObjectDetailView.swift
//  Showroom
//
//  Created by Luka Lešić on 01.11.2023..
//

import SwiftUI

struct CategoryView: View {
    @Environment(ObjectsViewModel.self) private var viewModel: ObjectsViewModel
    var columns: [GridItem] = [.init(.adaptive(minimum: 300), spacing: 30)]
    @Environment(ImmersiveViewManager.self) private var manager: ImmersiveViewManager

    var body: some View {
        NavigationView {
            ScrollView {
                CustomGridLayout(viewModel.filteredObjects, numberOfColumns: 3) { object in
                        NavigationLink(destination: ObjectDetailsView(object: object).environment(manager).environment(viewModel)) {
                            SingleObjectListView(object: object)
                        }
                    
                            .buttonStyle(PlainButtonStyle())
                    }
            }
            .refreshable {
                viewModel.refresh()
            }
        }.navigationViewStyle(.stack)
    }
}

//using LazyVGrid causes bugs on the current VisionOS beta. Alternative provided below:

extension Array {
    func getElementAt(index: Int) -> Element? {
        return (index < self.endIndex) ? self[index] : nil
    }
}

struct CustomGridLayout<Element, GridCell>: View where GridCell: View {

    private var array: [Element]
    private var numberOfColumns: Int
    private var gridCell: (_ element: Element) -> GridCell
        
    init(_ array: [Element], numberOfColumns: Int, @ViewBuilder gridCell: @escaping (_ element: Element) -> GridCell) {
        self.array = array
        self.numberOfColumns = numberOfColumns
        self.gridCell = gridCell
    }
        
        var body: some View {
            Grid {
                ForEach(Array(stride(from: 0, to: self.array.count, by: self.numberOfColumns)), id: \.self) { index in
                    GridRow {
                        ForEach(0..<self.numberOfColumns, id: \.self) { j in
                            if let element = self.array.getElementAt(index: index + j) {
                                self.gridCell(element)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

