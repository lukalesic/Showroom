//
//  ModelObjectsRepository.swift
//  Showroom
//
//  Created by Luka Lešić on 01.11.2023..
//

import Foundation
import FirebaseFirestore
import Observation

final class ModelObjectsRepository: Repository {
    var loadingState = LoadingState.empty
    let database = Firestore.firestore()
    var modelObjects: [ModelObject] = []
    
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
                        self.mapSnapshotToModelObjects(snapshot: documents)
                        self.loadingState = .loaded
                    }
                }
            }
        }
    }
    
    func mapSnapshotToModelObjects(snapshot: [DocumentSnapshot]) {
        let adapter = FirebaseAdapter()
        let modelObjects = snapshot.map {
            adapter.adaptSnapshot($0)
        }
        self.modelObjects.append(contentsOf: modelObjects)
    }
}
