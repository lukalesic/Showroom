//
//  ObjectsViewModel.swift
//  Showroom
//
//  Created by Luka Lešić on 01.11.2023..
//

import Foundation
import Observation
import FirebaseFirestore

@Observable
class ObjectsViewModel {
    var selectedCategory: ModelType
    let repository = ObjectsRepository()
    var filteredData: [DocumentSnapshot] = []

    init(selectedCategory: ModelType) {
        self.selectedCategory = selectedCategory
        repository.fetchAllData()
    }
    
    //MARK: fetching data
    
    func filterDocuments() {
        let filteredDocuments = repository.data.filter { document in
            let collectionName = document.reference.parent.collectionID
            return collectionName == selectedCategory.databaseId
        }
       filteredData = filteredDocuments
    }
}
