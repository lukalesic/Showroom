//
//  FirebaseAdapter.swift
//  Showroom
//
//  Created by Luka Lešić on 02.11.2023..
//

import Foundation
import FirebaseFirestore

class FirebaseAdapter: Adapter {
    func adaptSnapshot(_ snapshot: DocumentSnapshot) -> ModelObject {
        let name = snapshot.data()?["name"] as? String ?? ""
        let modelURL = snapshot.data()?["modelURL"] as? String ?? ""
        let description = snapshot.data()?["description"] as? String ?? ""
        let isFavourite = snapshot.data()?["isFavourite"] as? Bool ?? false
        let price = snapshot.data()?["price"] as? Int ?? 0
        let parentCollection = snapshot.reference.parent.collectionID
        let modelObject = ModelObject(name: name, modelURL: modelURL, price: price, parentCollection: parentCollection, description: description, isFavourite: isFavourite)
        return modelObject
    }
    
    func mapDocumentSnapshot(_ snapshot: [DocumentSnapshot]) -> [ModelObject] {
        let modelObjects = snapshot.map {
            self.adaptSnapshot($0)
        }
        return modelObjects
    }
}
