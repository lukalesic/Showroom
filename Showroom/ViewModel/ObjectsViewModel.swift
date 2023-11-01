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
    let database = Firestore.firestore()
    var selectedCategory: ModelType
    var data: [DocumentSnapshot] = []
    var filteredData: [DocumentSnapshot] = []
    var loadingState = LoadingState.empty
    
    init(selectedCategory: ModelType) {
        self.selectedCategory = selectedCategory
        print(self.selectedCategory)
    }
    
    //MARK: fetching data
    
    func fetchAllData() {
        loadingState = .loading
        for modelType in ModelType.allCases {
            let collectionRef = database.collection(modelType.databaseId)
            collectionRef.getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                }
                else {
                    if let documents = snapshot?.documents {
                        self.data.append(contentsOf: documents)
                        self.loadingState = .loaded
                    }
                }
            }
        }
    }
    
    func filterDocuments() {
        let filteredDocuments = data.filter { document in
            let collectionName = document.reference.parent.collectionID
            return collectionName == selectedCategory.databaseId
        }
        filteredData = filteredDocuments
    }
    
    func fetchDocuments() {
        loadingState = .loading
        let collectionRef = database.collection(selectedCategory.databaseId)
        collectionRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                if let documents = snapshot?.documents {
                    self.data = documents
                    self.loadingState = .loaded
                }
            }
        }
    }
}
