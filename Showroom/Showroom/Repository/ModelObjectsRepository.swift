//
//  ModelObjectsRepository.swift
//  Showroom
//
//  Created by Luka Lešić on 01.11.2023..
//

import Foundation
import FirebaseFirestore
import Observation
import FirebaseAuth

final class ModelObjectsRepository: Repository {
    var loadingState = LoadingState.empty
    let database = Firestore.firestore()
    var modelObjects: [ModelObject] = []
    var favouriteObjects: [ModelObject] = []
    let adapter = FirebaseAdapter()
    
    func fetchAllData() {
        modelObjects = []
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
        fetchFavourites()
    }
    
    func fetchFavourites() {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            // No user is signed in, handle this case
            return
        }
        
        var collectionRefs = [CollectionReference]()
        for path in ModelType.allCases {
            let collectionRef = database.collection(path.databaseId)
            collectionRefs.append(collectionRef)
          }
        
        for collectionRef in collectionRefs {
          let query = collectionRef.whereField("favorites.\(userId)", isEqualTo: true)
          query.getDocuments { (snapshot, error) in
            if let error = error {
              print("Error fetching favourites: \(error.localizedDescription)")
              return
            }
              
              if let documents = snapshot?.documents {
                  self.mapFavourites(snapshot: documents)
                  self.loadingState = .loaded
              }
            }
        }
    }
    
    func mapSnapshotToModelObjects(snapshot: [DocumentSnapshot]) {
        self.modelObjects.append(contentsOf: adapter.mapDocumentSnapshot(snapshot))
    }
    
    func mapFavourites(snapshot: [DocumentSnapshot]) {
        self.favouriteObjects.append(contentsOf: adapter.mapDocumentSnapshot(snapshot))
    }
}
