//
//  ObjectsViewModel.swift
//  Showroom
//
//  Created by Luka Lešić on 01.11.2023..
//

import Foundation
import Observation
import FirebaseFirestore
import FirebaseAuth

@Observable
class ObjectsViewModel {
    var selectedCategory: ModelType
    let repository = ModelObjectsRepository()
    var filteredObjects: [ModelObject] = []
    var selectedObject: ModelObject?
    let database = Firestore.firestore()

    init(selectedCategory: ModelType) {
        self.selectedCategory = selectedCategory
        repository.fetchAllData()
    }
    
    //MARK: filtering data
 
    func fetchFavourites() {
        filteredObjects = repository.favouriteObjects
    }
    
    func filterObjects() {
        let filteredDocuments = repository.modelObjects.filter { object in
            let collectionName = object.parentCollection
            return collectionName == selectedCategory.databaseId
        }
      filteredObjects = filteredDocuments
    }
    
    func addToFavourites(_ object: ModelObject) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        let collectionRef = database
            .collection(selectedCategory.databaseId)
            .whereField("name", isEqualTo: object.name)
            .getDocuments() {
            snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
            }
            else {
                let favouriteStatus = object.isFavourite
                
                object.isFavourite = !favouriteStatus
                let document = snapshot!.documents.first
                document?.reference.updateData(
                [
                    "isFavourite": !favouriteStatus,
                    "favorites.\(userId)": !favouriteStatus
                ])
            }
        }
    }
}
