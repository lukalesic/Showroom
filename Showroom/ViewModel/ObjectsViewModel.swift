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
    let repository = ModelObjectsRepository()
    var filteredObjects: [ModelObject] = []

    init(selectedCategory: ModelType) {
        self.selectedCategory = selectedCategory
        repository.fetchAllData()
    }
    
    //MARK: filtering data
    
    func filterObjects() {
        let filteredDocuments = repository.modelObjects.filter { object in
            let collectionName = object.parentCollection
            return collectionName == selectedCategory.databaseId
        }
      filteredObjects = filteredDocuments
    }
}
