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
    var data: [DocumentSnapshot] = []
    
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
}