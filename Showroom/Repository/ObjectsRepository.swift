//
//  ObjectsRepository.swift
//  Showroom
//
//  Created by Luka Lešić on 01.11.2023..
//

import Foundation
import FirebaseFirestore
import Observation

final class ObjectsRepository: Repository {
    var loadingState = LoadingState.empty
    let database = Firestore.firestore()
    var objects: [ModelObject] = []
    
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
                        self.mapSnapshotToObjects(snapshot: documents)
                        self.loadingState = .loaded
                    }
                }
            }
        }
    }
    
    func mapSnapshotToObjects(snapshot: [DocumentSnapshot]) {
        let adapter = FirebaseAdapter()
        let modelObjects = snapshot.map {
            adapter.adaptSnapshot($0)
        }
        self.objects.append(contentsOf: modelObjects)
    }
}
